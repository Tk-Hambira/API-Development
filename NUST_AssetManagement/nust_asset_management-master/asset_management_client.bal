import ballerina/http;
import ballerina/io;

public function main() returns error? {
    // Base URL of the asset management service
    string baseUrl = "http://localhost:8080/assets";
    http:Client assetClient = check new (baseUrl);

    // Example: Create a new asset
    json newAsset = {
        assetTag: "EQ-002",
        name: "Laser Cutter",
        faculty: "Engineering",
        department: "Mechanical",
        status: "ACTIVE",
        acquiredDate: "2024-05-01",
        components: {},
        schedules: {},
        workOrders: {}
    };
    var createResp = assetClient->post("/", newAsset, targetType = json);
    io:println("Create Asset Response: ", createResp);

    // Example: Get all assets
    var getAllResp = assetClient->get("/", targetType = json);
    io:println("All Assets: ", getAllResp);

    // Example: Get asset by tag
    var getOneResp = assetClient->get("/EQ-002", targetType = json);
    io:println("Get Asset by Tag: ", getOneResp);

    // Example: Update asset
    json updatedAsset = newAsset.clone();
    if updatedAsset is map<json> {
        updatedAsset["status"] = "UNDER_REPAIR";
    }
    var updateResp = assetClient->put("/EQ-002", updatedAsset, targetType = json);
    io:println("Update Asset Response: ", updateResp);

    // Example: Add a component to the asset
    json newComponent = { id: "C-001", name: "Laser Head", description: "CO2 Laser Head" };
    var addCompResp = assetClient->post("/EQ-002/components", newComponent, targetType = json);
    io:println("Add Component Response: ", addCompResp);

    // Example: Remove a component from the asset
    var delCompResp = assetClient->delete("/EQ-002/components/C-001", targetType = json);
    io:println("Delete Component Response: ", delCompResp);

    // Example: Add a maintenance schedule
    json newSchedule = { id: "S-001", scheduleType: "Yearly", nextDueDate: "2025-05-01" };
    var addSchedResp = assetClient->post("/EQ-002/schedules", newSchedule, targetType = json);
    io:println("Add Schedule Response: ", addSchedResp);

    // Example: Remove a maintenance schedule
    var delSchedResp = assetClient->delete("/EQ-002/schedules/S-001", targetType = json);
    io:println("Delete Schedule Response: ", delSchedResp);

    // Example: Add a work order
    json newWorkOrder = { id: "WO-001", description: "Replace laser tube", status: "OPEN", tasks: [] };
    var addWOResp = assetClient->post("/EQ-002/workorders", newWorkOrder, targetType = json);
    io:println("Add Work Order Response: ", addWOResp);

    // Example: Update a work order status
    json updatedWO = newWorkOrder.clone();
    if updatedWO is map<json> {
        updatedWO["status"] = "IN_PROGRESS";
    }
    var updWOResp = assetClient->put("/EQ-002/workorders/WO-001", updatedWO, targetType = json);
    io:println("Update Work Order Response: ", updWOResp);

    // Example: Add a task to a work order
    json newTask = { id: "T-001", description: "Remove old tube", status: "PENDING" };
    var addTaskResp = assetClient->post("/EQ-002/workorders/WO-001/tasks", newTask, targetType = json);
    io:println("Add Task Response: ", addTaskResp);

    // Example: Remove a task from a work order
    var delTaskResp = assetClient->delete("/EQ-002/workorders/WO-001/tasks/T-001", targetType = json);
    io:println("Delete Task Response: ", delTaskResp);

    // Example: Get all assets for a faculty
    var getFacultyResp = assetClient->get("/faculty/Engineering", targetType = json);
    io:println("Assets for Faculty: ", getFacultyResp);

    // Example: Get all overdue assets
    var getOverdueResp = assetClient->get("/overdue", targetType = json);
    io:println("Overdue Assets: ", getOverdueResp);

    // Example: Delete asset
    var deleteResp = assetClient->delete("/EQ-002", targetType = json);
    io:println("Delete Asset Response: ", deleteResp);
}
