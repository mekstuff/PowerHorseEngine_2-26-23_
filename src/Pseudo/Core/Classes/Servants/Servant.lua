local Servant = {};
Servant.Name = "Servant";
Servant.ClassName = "Servant";

--[=[
@class Servant

Servants are PowerHorseEngine's way of classes like `Maid`.
]=]
function Servant:_Render()
    self._dev.keep = {};
    self._dev.connect = {};
    self._dev.keeptrack = {};
    self._dev.activeThreads = {};
    return{};
end;
--[=[
    Gives a function task to the servant that will be removed once the task was completed.
    If `Servant` is destroyed while trying to complete task, the task will end as well.

    ```lua
        local function loopFunction()
            for i = 1,1000, do
                print("Task is still running!");
                task.wait();
            end;
        end;
        Servant:Task(loopFunction); --> Will print "Task is still running" multiple times
        print("Lanzo,inc. Demonstration"); --> This will print even though a loop is running
        task.wait(5); 
        Servant:Destroy(); --> Will no longer print "Task is still running"
    ```
]=]
function Servant:Task(cb:any)
    local id = tostring(tick());
    local thread;
    thread = coroutine.create(function()
        cb();
        if(thread)then
            coroutine.close(thread);
            thread = nil;
            self._dev.activeThreads[id]=nil;
        end
    end);
    self._dev.activeThreads[id] = thread;
    coroutine.resume(thread);
end;
--[=[
    Calls Instance.new(...) and calls Servant:Keep() on the instance 
]=]
function Servant:Instance(...:any):Instance
    return self:Keep(Instance.new(...))
end;
--[=[
    Calls Pseudo.new(...) and calls Servant:Keep() on the pseudo 
    
]=]
function Servant:Pseudo(...:any)
    return self:Keep(self:_GetAppModule().new(...))
end;
--[=[
    Tells the Servant that it should keep the Instance or Pseudo
    Whenever the Servant is destroyed, the instance/pseudo will be destroyed aswell

]=]

function Servant:Keep(...:any)
    local t = {...};
    if(#t == 1)then
        return self:_Keep(...);
    else
        for _,x in pairs(t) do
            self:_Keep(x);
        end;
    end
end;

function Servant:_Keep(instance:any)
    self._dev.keep[instance] = instance;
    if(typeof(instance) == "Instance")then
        local tracker = self:Connect(instance.Destroying, function()
            self:Free(instance);
        end);
        self._dev.keeptrack[instance] = tracker;
    elseif(typeof(instance) == "table" and instance.IsA and instance:IsA("Pseudo"))then
        local tracker = self:Connect(instance:GetPropertyChangedSignal("Destroying"), function()
            self:Free(instance);
        end);
        self._dev.keeptrack[instance] = tracker;
    elseif(typeof(instance) == "table" and instance.Destroying)then
        local tracker = self:Connect(instance:GetPropertyChangedSignal("Destroying"), function()
            self:Free(instance);
        end);
        self._dev.keeptrack[instance] = tracker;
    end;
    return instance;
end;
--[=[
    Tells the servant to no longer track the Instance or Pseudo
]=]
function Servant:Free(instance:any)
    self._dev.keep[instance]=nil;
    if(self._dev.keeptrack[instance])then
        self:Disconnect(self._dev.keeptrack[instance]);
        -- self._dev.keeptrack[instance]:Disconnect();
        self._dev.keeptrack[instance] = nil;
        -- print("Cleaned tracker");
    end;
    print(self._dev);
end;
--[=[
    Tracks the connection
]=]
function Servant:Connect(connection:RBXScriptSignal, handler:any,id:any)
    local connected = connection:Connect(function(...)
        handler(...)
    end);
    table.insert(self._dev.connect, {
        connection = connected;
        id = id
    });
    return connected;
end;
--[=[
    Removes tracking from the connection
]=]
function Servant:Disconnect(connection:RBXScriptConnection)
    for i,v in pairs(self._dev.connect) do
        if(v.connection == connection or v.id == connection)then
            if(not v.Disconnect)then return end;
            v:Disconnect();
            table.remove(self._dev.connect, i);
            break;
        end
    end
end
--[=[
    Destroys the Servant, which will intern destroy all tracked instance and disconnect all tracked connections
]=]
function Servant:Destroy()
    for _,x in pairs(self._dev.activeThreads) do
        if(x)then
            coroutine.close(x);
        end
    end;
    self._dev.activeThreads = nil;
    self:GetRef():Destroy();
end


return Servant;