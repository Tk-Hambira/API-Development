import ballerina/http;
import ballerina/time;


type Component record {| 
    string id;
    string name;
    string description?;
|};

type Schedule record {| 
    string id;
    string scheduleType; // renamed from 'type' to avoid reserved keyword
    string nextDueDate;
|};

type Task record {| 
    string id;
    string description;
    string status;
|};

type WorkOrder record {| 
    string id;
    string description;
    string status;
    Task[] tasks = [];
|};

type Asset record {| 
    string assetTag;
    string name;
    string faculty;
    string department;
    string status;
    string acquiredDate;
    map<Component> components = {};
    map<Schedule> schedules = {};
    map<WorkOrder> workOrders = {};
|};

service /assets on new http:Listener(8080) {
    private map<Asset> assetDB = {};

    resource function post .(Asset asset) returns json|error {
        if self.assetDB.hasKey(asset.assetTag) {
            return { message: "Asset already exists" };
        }
        self.assetDB[asset.assetTag] = asset;
        return { message: "Asset created", asset: asset };
    }

    resource function get .() returns Asset[] {
        Asset[] assets = [];
        foreach var v in self.assetDB.cloneReadOnly() {
            assets.push(v);
        }
        return assets;
    }

    resource function get [string assetTag]() returns Asset|json {
        if self.assetDB.hasKey(assetTag) {
            return self.assetDB[assetTag];
        }
        return { message: "Asset not found" };
    }

    resource function put [string assetTag](Asset asset) returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        self.assetDB[assetTag] = asset;
        return { message: "Asset updated", asset: asset };
    }

    resource function delete [string assetTag]() returns json {
        var removed = self.assetDB.remove(assetTag);
        if removed is Asset {
            return { message: "Asset deleted" };
        } else {
           
        }
    }

    resource function get faculty/[string faculty]() returns Asset[] {
        Asset[] result = [];
        foreach var asset in self.assetDB.cloneReadOnly() {
            if asset.faculty == faculty {
                result.push(asset);
            }
        }
        return result;
    }

    resource function get overdue() returns Asset[] {
        Asset[] result = [];
        foreach var asset in self.assetDB.cloneReadOnly() {
            foreach var schedule in asset.schedules {
                time:Utc|error due = time:utcFromString(schedule.nextDueDate);
                if due is time:Utc {
                    if due < time:utcNow() {
                        result.push(asset);
                        break;
                    }
                }
            }
        }
        return result;
    }

    resource function post [string assetTag]/components(Component component) returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        self.assetDB[assetTag].components[component.id] = component;
        return { message: "Component added", component: component };
    }

    resource function delete [string assetTag]/components/[string componentId]() returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        Asset? asset = self.assetDB[assetTag];
        if asset is Asset {
            var removed = asset.components.remove(componentId);
            if removed is Component {
                self.assetDB[assetTag] = asset;
                return { message: "Component removed" };
            }
            
        }
        return { message: "Asset not found" };
    }

    resource function post [string assetTag]/schedules(Schedule schedule) returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        self.assetDB[assetTag].schedules[schedule.id] = schedule;
        return { message: "Schedule added", schedule: schedule };
    }

    resource function delete [string assetTag]/schedules/[string scheduleId]() returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        Asset? asset = self.assetDB[assetTag];
        if asset is Asset {
            var removed = asset.schedules.remove(scheduleId);
            if removed is Schedule {
                self.assetDB[assetTag] = asset;
                return { message: "Schedule removed" };
            }
            
        }
        return { message: "Asset not found" };

 }

    resource function post [string assetTag]/workorders(WorkOrder workOrder) returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        self.assetDB[assetTag].workOrders[workOrder.id] = workOrder;
        return { message: "Work order added", workOrder: workOrder };
    }

    resource function put [string assetTag]/workorders/[string workOrderId](WorkOrder workOrder) returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        Asset? asset = self.assetDB[assetTag];
        if asset is Asset {
            if !asset.workOrders.hasKey(workOrderId) {
                return { message: "Work order not found" };
            }
            asset.workOrders[workOrderId] = workOrder;
            self.assetDB[assetTag] = asset;
            return { message: "Work order updated", workOrder: workOrder };
        }
        return { message: "Asset not found" };
    }

    resource function delete [string assetTag]/workorders/[string workOrderId]() returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        Asset? asset = self.assetDB[assetTag];
        if asset is Asset {
            var removed = asset.workOrders.remove(workOrderId);
            if removed is WorkOrder {
                self.assetDB[assetTag] = asset;
                return { message: "Work order closed" };

            }
        } else {
            return { message: "Asset not found" };
        }
    }

    resource function post [string assetTag]/workorders/[string workOrderId]/tasks(Task task) returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        Asset? asset = self.assetDB[assetTag];
        if asset is Asset {
            WorkOrder? wo = asset.workOrders[workOrderId];
            if wo is WorkOrder {
                wo.tasks.push(task);
                asset.workOrders[workOrderId] = wo;
                self.assetDB[assetTag] = asset;
                return { message: "Task added", task: task };
            } else {
                return { message: "Work order not found" };
            }
        }
        return { message: "Asset not found" };
    }

    resource function delete [string assetTag]/workorders/[string workOrderId]/tasks/[string taskId]() returns json {
        if !self.assetDB.hasKey(assetTag) {
            return { message: "Asset not found" };
        }
        Asset? asset = self.assetDB[assetTag];
        if asset is Asset {
            WorkOrder? wo = asset.workOrders[workOrderId];
            if wo is WorkOrder {
                int idx = -1;
                foreach int i in 0 ..< wo.tasks.length() {
                    if wo.tasks[i].id == taskId {
                        idx = i;
                        break;
                    }
                }
                if idx >= 0 {
                    // Remove the task at idx
                    Task[] newTasks = [];
                    foreach int j in 0 ..< wo.tasks.length() {
                        if j != idx {
                            newTasks.push(wo.tasks[j]);
                        }
                    }
                    wo.tasks = newTasks;
                    asset.workOrders[workOrderId] = wo;
                    self.assetDB[assetTag] = asset;
                    return { message: "Task removed" };
                }
                return { message: "Task not found" };
            } else {
                return { message: "Work order not found" };
            }
        }
        return { message: "Asset not found" };
    }
};


