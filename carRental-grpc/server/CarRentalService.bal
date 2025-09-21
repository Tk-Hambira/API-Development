mport ballerina/grpc;
import ballerina/io;
import ballerina/time;
import stubs;

listener grpc:Listener carListener = new(50051);

// In-memory storage
map<stubs:Car> cars = {};
map<stubs:User> users = {};
map<stubs:CartItem[]> carts = {};
stubs:Reservation[] reservations = [];

// Utility functions
function parseDateParts(string d) returns (int, int, int|error) {
    string[] parts = d.split("-");
    if parts.length() != 3 {
        return error("Invalid date format");
    }
    int year = checkpanic int:fromString(parts[0]);
    int month = checkpanic int:fromString(parts[1]);
    int day = checkpanic int:fromString(parts[2]);
    return (year, month, day);
}

function julianDayNumber(int y, int m, int d) returns int {
    int a = (14 - m) / 12;
    int yy = y + 4800 - a;
    int mm = m + 12*a - 3;
    return d + ((153*mm + 2) / 5) + 365*yy + yy/4 - yy/100 + yy/400 - 32045;
}

function daysBetween(string start, string end) returns int|error {
    var s = parseDateParts(start);
    var e = parseDateParts(end);
    if s is (int,int,int) && e is (int,int,int) {
        int sDay = julianDayNumber(s[0], s[1], s[2]);
        int eDay = julianDayNumber(e[0], e[1], e[2]);
        return eDay - sDay;
    }
    return error("Invalid date format");
}

function validateDateOrder(string start, string end) returns boolean {
    var diff = daysBetween(start, end);
    return diff is int && diff > 0;
}

function overlapsExisting(string plate, string start, string end) returns boolean {
    foreach var r in reservations {
        foreach var it in r.items {
            if it.plate == plate {
                var d1 = parseDateParts(it.start_date);
                var d2 = parseDateParts(it.end_date);
                var d3 = parseDateParts(start);
                var d4 = parseDateParts(end);
                if d1 is (int,int,int) && d2 is (int,int,int) && d3 is (int,int,int) && d4 is (int,int,int) {
                    int s1 = julianDayNumber(d1[0], d1[1], d1[2]);
                    int e1 = julianDayNumber(d2[0], d2[1], d2[2]);
                    int s2 = julianDayNumber(d3[0], d3[1], d3[2]);
                    int e2 = julianDayNumber(d4[0], d4[1], d4[2]);
                    if (s1 <= e2 && s2 <= e1) {
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

// gRPC service
service "CarRental" on carListener {

    remote function AddCar(stubs:Car car) returns stubs:CarResponse {
        cars[car.plate] = car;
        return {
            success: true,
            message: "Car added",
            car: car
        };
    }

    remote function CreateUsers(stream<stubs:User> userStream) returns stubs:UserResponse {
        int count = 0;
        string[] ids = [];
        check from userStream -> foreach stubs:User user in _ {
            users[user.user_id] = user;
            ids.push(user.user_id);
            count += 1;
        };
        return { created_count: count, created_ids: ids };
    }

    remote function UpdateCar(stubs:UpdateCarRequest req) returns stubs:CarResponse {
        if !cars.hasKey(req.plate) {
            return { success: false, message: "Car not found" };
        }
        stubs:Car car = cars[req.plate];
        car.daily_price = req.daily_price;
        car.status = req.status;
        car.mileage = req.mileage;
        cars[req.plate] = car;
        return { success: true, message: "Car updated", car: car };
    }

    remote function RemoveCar(stubs:CarPlate plate) returns stubs:CarList {
        cars.remove(plate.plate);
        return { cars: cars.values() };
    }

    remote function ListAvailableCars(stubs:CarFilter filter) returns stream<stubs:Car, error?> {
        stream<stubs:Car, error?> out = new();
        foreach var car in cars.values() {
            if car.status == "AVAILABLE" &&
               (filter.text == "" || car.make.contains(filter.text) || car.model.contains(filter.text)) {
                checkpanic out.send(car);
            }
        }
        out.complete();
        return out;
    }

    remote function SearchCar(stubs:CarPlate plate) returns stubs:CarSearchResponse {
        if !cars.hasKey(plate.plate) {
            return { found: false, message: "Car not found" };
        }
        stubs:Car car = cars[plate.plate];
        if car.status != "AVAILABLE" {
            return { found: false, message: "Car not available" };
        }
        return { found: true, message: "Car found", car: car };
    }

    remote function AddToCart(stubs:CartItem item) returns stubs:CartResponse {
        if !cars.hasKey(item.plate) {
            return { ok: false, message: "Car does not exist" };
        }
        if !validateDateOrder(item.start_date, item.end_date) {
            return { ok: false, message: "Invalid dates" };
        }
        if overlapsExisting(item.plate, item.start_date, item.end_date) {
            return { ok: false, message: "Car already booked for those dates" };
        }
        stubs:CartItem[] arr = carts.hasKey(item.user_id) ? carts[item.user_id] : [];
        arr.push(item);
        carts[item.user_id] = arr;
        return { ok: true, message: "Added to cart" };
    }

    remote function PlaceReservation(stubs:UserId req) returns stubs:ReservationResponse {
        if !carts.hasKey(req.user_id) {
            return { success: false, message: "Cart is empty" };
        }
        stubs:CartItem[] items = carts[req.user_id];
        stubs:PriceQuote[] quotes = [];

        foreach var it in items {
            var diff = daysBetween(it.start_date, it.end_date);
            if diff is int {
                decimal total = diff * cars[it.plate].daily_price;
                stubs:PriceQuote q = {
                    plate: it.plate,
                    days: diff,
                    daily_price: cars[it.plate].daily_price,
                    total_price: total
                };
                quotes.push(q);
            }
        }

        string resId = "RES-" + time:currentTime().unixTime.toString() + "-" + req.user_id;
        stubs:Reservation r = {
            reservation_id: resId,
            user_id: req.user_id,
            items: items,
            quotes: quotes,
            created_at: time:currentTime().toString()
        };
        reservations.push(r);
        carts.remove(req.user_id);

        return { success: true, message: "Reservation confirmed", reservation: r };
    }
}
