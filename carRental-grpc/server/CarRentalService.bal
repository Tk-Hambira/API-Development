import ballerina/io;
import ballerina/grpc;
import server.generated.carrental_pb as carrental_pb;


// In-memory data stores
map<carrental_pb:Car> cars = {};
map<carrental_pb:User> users = {};
map<carrental_pb:Reservation> reservations = {};

// gRPC service
service "CarRentalService" on new grpc:Listener(9090) {

    // Admin Operations

    // Add Car
    remote function AddCar(carrental_pb:AddCarRequest request)
            returns carrental_pb:AddCarResponse|error {
        carrental_pb:Car car = request.car;
        cars[car.id] = car;
        io:println("Car added: ", car.id, " - ", car.make, " ", car.model);

        return {
            message: "Car added successfully!",
            car: car
        };
    }

    // Update Car
    remote function UpdateCar(carrental_pb:UpdateCarRequest request)
            returns carrental_pb:UpdateCarResponse|error {
        carrental_pb:Car car = request.car;
        if (cars.hasKey(car.id)) {
            cars[car.id] = car;
            return { message: "Car updated successfully!", car: car };
        }
        return { message: "Car not found!", car: car };
    }

    // Remove Car
    remote function RemoveCar(carrental_pb:RemoveCarRequest request)
            returns carrental_pb:RemoveCarResponse|error {
        if (cars.hasKey(request.car_id)) {
            cars.remove(request.car_id);
            return { message: "Car removed successfully!" };
        }
        return { message: "Car not found!" };
    }

    //  Customer Operations

    // List Available Cars 
    remote function ListAvailableCars(carrental_pb:ListAvailableCarsRequest request)
            returns carrental_pb:ListAvailableCarsResponse|error {
        carrental_pb:ListAvailableCarsResponse response = {};

        foreach var [_, car] in cars.entries() {
            if (car.status == "available" &&
                (request.filter == "" || car.make == request.filter || car.model == request.filter)) {
                response.cars.push(car);
            }
        }
        return response;
    }

    // Search Car
    remote function SearchCar(carrental_pb:SearchCarRequest request)
            returns carrental_pb:SearchCarResponse|error {
        if (cars.hasKey(request.car_id)) {
            return { car: cars[request.car_id] };
        }
        return { car: { id: "", make: "", model: "", year: 0,
                        daily_price: 0.0, mileage: 0, status: "not found" } };
    }


                        // TODO: AddToCart, PlaceReservation, CancelReservation, CreateUsers
    // Add to Cart
    remote function AddToCart(carrental_pb:AddToCartRequest request)
            returns carrental_pb:AddToCartResponse|error {
        if (!cars.hasKey(request.car_id)) {
            return { message: "Car not found!" };
        }

        string[] userCart = carts[request.user_id] but { [] };
        userCart.push(request.car_id);
        carts[request.user_id] = userCart;

        return { message: "Car added to cart successfully!" };
    }

    //Place Reservation
    remote function PlaceReservation(carrental_pb:PlaceReservationRequest request)
            returns carrental_pb:PlaceReservationResponse|error {
        carrental_pb:PlaceReservationResponse response = { message: "Reservation placed!", reservations: [] };

        foreach var car_id in request.car_ids {
            if (cars.hasKey(car_id) && cars[car_id].status == "available") {
                carrental_pb:Reservation reservation = {
                    reservation_id: "res-" + car_id,
                    user_id: request.user_id,
                    car_id: car_id,
                    start_date: "2025-01-01", // For now, fixed dates — can be extended
                    end_date: "2025-01-07",
                    total_price: cars[car_id].daily_price * 7,
                    status: "active"
                };

                reservations[reservation.reservation_id] = reservation;
                cars[car_id].status = "rented"; // Mark car unavailable
                response.reservations.push(reservation);
            }
        }
        return response;
    }

    //Cancel Reservation
    remote function CancelReservation(carrental_pb:CancelReservationRequest request)
            returns carrental_pb:CancelReservationResponse|error {
        if (reservations.hasKey(request.reservation_id)) {
            carrental_pb:Reservation res = reservations[request.reservation_id];
            reservations[request.reservation_id].status = "cancelled";

            // free the car
            if (cars.hasKey(res.car_id)) {
                cars[res.car_id].status = "available";
            }
            return { message: "Reservation cancelled successfully!" };
        }
        return { message: "Reservation not found!" };
    }

        // User Creation(Implements client streaming)
    remote function CreateUsers(stream<carrental_pb:CreateUsersRequest, error?> clientStream)
            returns carrental_pb:CreateUsersResponse|error {
        error? e = clientStream.forEach(function(carrental_pb:CreateUsersRequest req) {
            foreach var user in req.users {
                users[user.user_id] = user;
                io:println("User created: ", user.user_id, " - ", user.name);
            }
        });

        if e is error {
            return { message: "Error while creating users!" };
        }
        return { message: "All users created successfully!" };
    }
}
