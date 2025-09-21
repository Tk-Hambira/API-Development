mport ballerina/io;
import ballerina/grpc;
import stubs;

public function main() returns error? {
    stubs:CarRentalClient client = check new ("localhost:50051");

    // 1. Add a car
    stubs:Car car = {
        plate: "N1234",
        make: "Toyota",
        model: "Corolla",
        year: 2020,
        daily_price: 45.0,
        mileage: 30000,
        status: "AVAILABLE"
    };
    stubs:CarResponse carResp = check client->AddCar(car);
    io:println("AddCar response: ", carResp.message);

    // 2. Create users (streaming)
    stream<stubs:User> userStream = new;
    checkpanic userStream.send({ user_id: "admin1", name: "Alice", role: "ADMIN" });
    checkpanic userStream.send({ user_id: "cust1", name: "Bob", role: "CUSTOMER" });
    userStream.complete();

    stubs:UserResponse userResp = check client->CreateUsers(userStream);
    io:println("Created users: ", userResp.created_ids);

    // 3. Update car
    stubs:UpdateCarRequest updateReq = {
        plate: "N1234",
        daily_price: 50.0,
        status: "AVAILABLE",
        mileage: 31000
    };
    stubs:CarResponse updateResp = check client->UpdateCar(updateReq);
    io:println("UpdateCar response: ", updateResp.message);

    // 4. Search car
    stubs:CarSearchResponse searchResp = check client->SearchCar({ plate: "N1234" });
    io:println("SearchCar response: ", searchResp.message);

    // 5. Add to cart
    stubs:CartItem item = {
        user_id: "cust1",
        plate: "N1234",
        start_date: "2025-09-22",
        end_date: "2025-09-25"
    };
    stubs:CartResponse cartResp = check client->AddToCart(item);
    io:println("AddToCart response: ", cartResp.message);

    // 6. Place reservation
    stubs:ReservationResponse resResp = check client->PlaceReservation({ user_id: "cust1" });
    io:println("Reservation: ", resResp.message);
    io:println("Reservation ID: ", resResp.reservation.reservation_id);
}
