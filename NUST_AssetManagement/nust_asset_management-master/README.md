# Asset Management RESTful API - Ballerina

This service provides a RESTful API for managing university assets, their components, maintenance schedules, work orders, and tasks.

## Base URL
```
http://localhost:8080/assets
```

## Endpoints & Practical Examples

### Asset Management
- **Create Asset**
  - `POST /`
  - Example:
    ```sh
    curl -X POST http://localhost:8080/assets/ \
      -H "Content-Type: application/json" \
      -d '{"assetTag":"EQ-001","name":"3D Printer","faculty":"Computing & Informatics","department":"Software Engineering","status":"ACTIVE","acquiredDate":"2024-03-10","components":{},"schedules":{},"workOrders":{}}'
    ```
- **Get All Assets**
  - `GET /`
  - Example:
    ```sh
    curl http://localhost:8080/assets/
    ```
- **Get Asset by Tag**
  - `GET /{assetTag}`
  - Example:
    ```sh
    curl http://localhost:8080/assets/EQ-001
    ```
- **Update Asset**
  - `PUT /{assetTag}`
  - Example:
    ```sh
    curl -X PUT http://localhost:8080/assets/EQ-001 \
      -H "Content-Type: application/json" \
      -d '{"assetTag":"EQ-001","name":"3D Printer","faculty":"Computing & Informatics","department":"Software Engineering","status":"UNDER_REPAIR","acquiredDate":"2024-03-10","components":{},"schedules":{},"workOrders":{}}'
    ```
- **Delete Asset**
  - `DELETE /{assetTag}`
  - Example:
    ```sh
    curl -X DELETE http://localhost:8080/assets/EQ-001
    ```

### Filter & Search
- **Get Assets by Faculty**
  - `GET /faculty/{faculty}`
  - Example:
    ```sh
    curl http://localhost:8080/assets/faculty/Computing%20%26%20Informatics
    ```
- **Get Overdue Assets**
  - `GET /overdue`
  - Example:
    ```sh
    curl http://localhost:8080/assets/overdue
    ```

### Component Management
- **Add Component**
  - `POST /{assetTag}/components`
  - Example:
    ```sh
    curl -X POST http://localhost:8080/assets/EQ-001/components \
      -H "Content-Type: application/json" \
      -d '{"id":"C-001","name":"Motor","description":"Stepper motor"}'
    ```
- **Remove Component**
  - `DELETE /{assetTag}/components/{componentId}`
  - Example:
    ```sh
    curl -X DELETE http://localhost:8080/assets/EQ-001/components/C-001
    ```

### Schedule Management
- **Add Schedule**
  - `POST /{assetTag}/schedules`
  - Example:
    ```sh
    curl -X POST http://localhost:8080/assets/EQ-001/schedules \
      -H "Content-Type: application/json" \
      -d '{"id":"S-001","scheduleType":"Yearly","nextDueDate":"2025-03-10"}'
    ```
- **Remove Schedule**
  - `DELETE /{assetTag}/schedules/{scheduleId}`
  - Example:
    ```sh
    curl -X DELETE http://localhost:8080/assets/EQ-001/schedules/S-001
    ```

### Work Order Management
- **Add Work Order**
  - `POST /{assetTag}/workorders`
  - Example:
    ```sh
    curl -X POST http://localhost:8080/assets/EQ-001/workorders \
      -H "Content-Type: application/json" \
      -d '{"id":"WO-001","description":"Fix print head","status":"OPEN","tasks":[]}'
    ```
- **Update Work Order**
  - `PUT /{assetTag}/workorders/{workOrderId}`
  - Example:
    ```sh
    curl -X PUT http://localhost:8080/assets/EQ-001/workorders/WO-001 \
      -H "Content-Type: application/json" \
      -d '{"id":"WO-001","description":"Fix print head","status":"IN_PROGRESS","tasks":[]}'
    ```
- **Delete (Close) Work Order**
  - `DELETE /{assetTag}/workorders/{workOrderId}`
  - Example:
    ```sh
    curl -X DELETE http://localhost:8080/assets/EQ-001/workorders/WO-001
    ```

### Task Management (under Work Order)
- **Add Task**
  - `POST /{assetTag}/workorders/{workOrderId}/tasks`
  - Example:
    ```sh
    curl -X POST http://localhost:8080/assets/EQ-001/workorders/WO-001/tasks \
      -H "Content-Type: application/json" \
      -d '{"id":"T-001","description":"Replace nozzle","status":"PENDING"}'
    ```
- **Remove Task**
  - `DELETE /{assetTag}/workorders/{workOrderId}/tasks/{taskId}`
  - Example:
    ```sh
    curl -X DELETE http://localhost:8080/assets/EQ-001/workorders/WO-001/tasks/T-001
    ```

---

## Example Base URL
- [http://localhost:8080/assets](http://localhost:8080/assets)

Replace `{assetTag}`, `{componentId}`, `{scheduleId}`, `{workOrderId}`, `{taskId}`, and `{faculty}` with actual values as needed.

---

For sample payloads, see the Ballerina client or service file.
