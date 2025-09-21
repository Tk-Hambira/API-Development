import ballerina/grpc;
import ballerina/protobuf;

public const string CARRENTAL_DESC = "0A0F63617272656E74616C2E70726F746F120963617272656E74616C22A6010A03436172120E0A0269641801200128095202696412120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12120A0479656172180420012805520479656172121F0A0B6461696C795F7072696365180520012801520A6461696C79507269636512180A076D696C6561676518062001280552076D696C6561676512160A06737461747573180720012809520673746174757322470A045573657212170A07757365725F6964180120012809520675736572496412120A046E616D6518022001280952046E616D6512120A04726F6C651803200128095204726F6C6522D7010A0B5265736572766174696F6E12250A0E7265736572766174696F6E5F6964180120012809520D7265736572766174696F6E496412170A07757365725F6964180220012809520675736572496412150A066361725F696418032001280952056361724964121D0A0A73746172745F64617465180420012809520973746172744461746512190A08656E645F646174651805200128095207656E6444617465121F0A0B746F74616C5F7072696365180620012801520A746F74616C507269636512160A06737461747573180720012809520673746174757322310A0D4164644361725265717565737412200A0363617218012001280B320E2E63617272656E74616C2E4361725203636172224C0A0E416464436172526573706F6E736512180A076D65737361676518012001280952076D65737361676512200A0363617218022001280B320E2E63617272656E74616C2E436172520363617222340A105570646174654361725265717565737412200A0363617218012001280B320E2E63617272656E74616C2E4361725203636172224F0A11557064617465436172526573706F6E736512180A076D65737361676518012001280952076D65737361676512200A0363617218022001280B320E2E63617272656E74616C2E436172520363617222290A1052656D6F76654361725265717565737412150A066361725F696418012001280952056361724964222D0A1152656D6F7665436172526573706F6E736512180A076D65737361676518012001280952076D65737361676522320A184C697374417661696C61626C65436172735265717565737412160A0666696C746572180120012809520666696C746572223F0A194C697374417661696C61626C6543617273526573706F6E736512220A046361727318012003280B320E2E63617272656E74616C2E43617252046361727322290A105365617263684361725265717565737412150A066361725F69641801200128095205636172496422350A11536561726368436172526573706F6E736512200A0363617218012001280B320E2E63617272656E74616C2E4361725203636172227E0A125265736572766174696F6E5265717565737412170A07757365725F6964180120012809520675736572496412150A066361725F696418022001280952056361724964121D0A0A73746172745F64617465180320012809520973746172744461746512190A08656E645F646174651804200128095207656E644461746522690A135265736572766174696F6E526573706F6E736512180A076D65737361676518012001280952076D65737361676512380A0B7265736572766174696F6E18022001280B32162E63617272656E74616C2E5265736572766174696F6E520B7265736572766174696F6E22410A1843616E63656C5265736572766174696F6E5265717565737412250A0E7265736572766174696F6E5F6964180120012809520D7265736572766174696F6E496422350A1943616E63656C5265736572766174696F6E526573706F6E736512180A076D65737361676518012001280952076D65737361676522420A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412150A066361725F696418022001280952056361724964222D0A11416464546F43617274526573706F6E736512180A076D65737361676518012001280952076D657373616765224B0A17506C6163655265736572766174696F6E5265717565737412170A07757365725F6964180120012809520675736572496412170A076361725F696473180220032809520663617249647322700A18506C6163655265736572766174696F6E526573706F6E736512180A076D65737361676518012001280952076D657373616765123A0A0C7265736572766174696F6E7318022003280B32162E63617272656E74616C2E5265736572766174696F6E520C7265736572766174696F6E73223B0A1243726561746555736572735265717565737412250A05757365727318012003280B320F2E63617272656E74616C2E5573657252057573657273222F0A134372656174655573657273526573706F6E736512180A076D65737361676518012001280952076D65737361676532DE050A1043617252656E74616C53657276696365123D0A0641646443617212182E63617272656E74616C2E416464436172526571756573741A192E63617272656E74616C2E416464436172526573706F6E736512460A09557064617465436172121B2E63617272656E74616C2E557064617465436172526571756573741A1C2E63617272656E74616C2E557064617465436172526573706F6E736512460A0952656D6F7665436172121B2E63617272656E74616C2E52656D6F7665436172526571756573741A1C2E63617272656E74616C2E52656D6F7665436172526573706F6E7365125E0A114C697374417661696C61626C654361727312232E63617272656E74616C2E4C697374417661696C61626C6543617273526571756573741A242E63617272656E74616C2E4C697374417661696C61626C6543617273526573706F6E736512460A09536561726368436172121B2E63617272656E74616C2E536561726368436172526571756573741A1C2E63617272656E74616C2E536561726368436172526573706F6E736512460A09416464546F43617274121B2E63617272656E74616C2E416464546F43617274526571756573741A1C2E63617272656E74616C2E416464546F43617274526573706F6E7365125B0A10506C6163655265736572766174696F6E12222E63617272656E74616C2E506C6163655265736572766174696F6E526571756573741A232E63617272656E74616C2E506C6163655265736572766174696F6E526573706F6E7365125E0A1143616E63656C5265736572766174696F6E12232E63617272656E74616C2E43616E63656C5265736572766174696F6E526571756573741A242E63617272656E74616C2E43616E63656C5265736572766174696F6E526573706F6E7365124E0A0B4372656174655573657273121D2E63617272656E74616C2E4372656174655573657273526571756573741A1E2E63617272656E74616C2E4372656174655573657273526573706F6E73652801620670726F746F33";

public isolated client class CarRentalServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CARRENTAL_DESC);
    }

    isolated remote function AddCar(AddCarRequest|ContextAddCarRequest req) returns AddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddCarResponse>result;
    }

    isolated remote function AddCarContext(AddCarRequest|ContextAddCarRequest req) returns ContextAddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddCarResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateCar(UpdateCarRequest|ContextUpdateCarRequest req) returns UpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateCarResponse>result;
    }

    isolated remote function UpdateCarContext(UpdateCarRequest|ContextUpdateCarRequest req) returns ContextUpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateCarResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveCar(RemoveCarRequest|ContextRemoveCarRequest req) returns RemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveCarResponse>result;
    }

    isolated remote function RemoveCarContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextRemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveCarResponse>result, headers: respHeaders};
    }

    isolated remote function ListAvailableCars(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns ListAvailableCarsResponse|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/ListAvailableCars", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ListAvailableCarsResponse>result;
    }

    isolated remote function ListAvailableCarsContext(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns ContextListAvailableCarsResponse|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/ListAvailableCars", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ListAvailableCarsResponse>result, headers: respHeaders};
    }

    isolated remote function SearchCar(SearchCarRequest|ContextSearchCarRequest req) returns SearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchCarResponse>result;
    }

    isolated remote function SearchCarContext(SearchCarRequest|ContextSearchCarRequest req) returns ContextSearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchCarResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns AddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartResponse>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextAddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceReservation(PlaceReservationRequest|ContextPlaceReservationRequest req) returns PlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceReservationResponse>result;
    }

    isolated remote function PlaceReservationContext(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ContextPlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceReservationResponse>result, headers: respHeaders};
    }

    isolated remote function CancelReservation(CancelReservationRequest|ContextCancelReservationRequest req) returns CancelReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        CancelReservationRequest message;
        if req is ContextCancelReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/CancelReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CancelReservationResponse>result;
    }

    isolated remote function CancelReservationContext(CancelReservationRequest|ContextCancelReservationRequest req) returns ContextCancelReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        CancelReservationRequest message;
        if req is ContextCancelReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("carrental.CarRentalService/CancelReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CancelReservationResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("carrental.CarRentalService/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendCreateUsersRequest(CreateUsersRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextCreateUsersRequest(ContextCreateUsersRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersResponse() returns CreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersResponse>payload;
        }
    }

    isolated remote function receiveContextCreateUsersResponse() returns ContextCreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class CarRentalServiceRemoveCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRemoveCarResponse(RemoveCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRemoveCarResponse(ContextRemoveCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceSearchCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSearchCarResponse(SearchCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSearchCarResponse(ContextSearchCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceAddCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddCarResponse(AddCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddCarResponse(ContextAddCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceCancelReservationResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCancelReservationResponse(CancelReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCancelReservationResponse(ContextCancelReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceAddToCartResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddToCartResponse(AddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddToCartResponse(ContextAddToCartResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServicePlaceReservationResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPlaceReservationResponse(PlaceReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPlaceReservationResponse(ContextPlaceReservationResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceUpdateCarResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUpdateCarResponse(UpdateCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUpdateCarResponse(ContextUpdateCarResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceListAvailableCarsResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendListAvailableCarsResponse(ListAvailableCarsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextListAvailableCarsResponse(ContextListAvailableCarsResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalServiceCreateUsersResponseCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUsersResponse(CreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUsersResponse(ContextCreateUsersResponse response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextCreateUsersRequestStream record {|
    stream<CreateUsersRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextCancelReservationResponse record {|
    CancelReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextListAvailableCarsResponse record {|
    ListAvailableCarsResponse content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationResponse record {|
    PlaceReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarRequest record {|
    UpdateCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarResponse record {|
    AddCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartResponse record {|
    AddToCartResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarResponse record {|
    UpdateCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextListAvailableCarsRequest record {|
    ListAvailableCarsRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarRequest record {|
    SearchCarRequest content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersRequest record {|
    CreateUsersRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarRequest record {|
    AddCarRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarResponse record {|
    RemoveCarResponse content;
    map<string|string[]> headers;
|};

public type ContextCancelReservationRequest record {|
    CancelReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationRequest record {|
    PlaceReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarResponse record {|
    SearchCarResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type ReservationResponse record {|
    string message = "";
    Reservation reservation = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type CancelReservationResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type User record {|
    string user_id = "";
    string name = "";
    string role = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type ListAvailableCarsResponse record {|
    Car[] cars = [];
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type PlaceReservationResponse record {|
    string message = "";
    Reservation[] reservations = [];
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type RemoveCarRequest record {|
    string car_id = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type UpdateCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type ReservationRequest record {|
    string user_id = "";
    string car_id = "";
    string start_date = "";
    string end_date = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddCarResponse record {|
    string message = "";
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddToCartResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type UpdateCarResponse record {|
    string message = "";
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    string car_id = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type ListAvailableCarsRequest record {|
    string filter = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type SearchCarRequest record {|
    string car_id = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type CreateUsersRequest record {|
    User[] users = [];
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type AddCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type RemoveCarResponse record {|
    string message = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type Reservation record {|
    string reservation_id = "";
    string user_id = "";
    string car_id = "";
    string start_date = "";
    string end_date = "";
    float total_price = 0.0;
    string status = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type CancelReservationRequest record {|
    string reservation_id = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type Car record {|
    string id = "";
    string make = "";
    string model = "";
    int year = 0;
    float daily_price = 0.0;
    int mileage = 0;
    string status = "";
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type PlaceReservationRequest record {|
    string user_id = "";
    string[] car_ids = [];
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type SearchCarResponse record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CARRENTAL_DESC}
public type CreateUsersResponse record {|
    string message = "";
|};
