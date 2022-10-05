local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local ErrorService = PowerHorseEngine:GetService("ErrorService");
local Engine = PowerHorseEngine:GetGlobal("Engine");
local CustomClassService = PowerHorseEngine:GetService("CustomClassService");

local SharedWorkflowFolder;
local SharedServicesFolder;
local FrameworkServerStorageFolder;

local ComponentClasses = {};
setmetatable(ComponentClasses, {__mode="v"});

local function BuildServer()
    local PHeReplicated = Engine:FetchReplicatedStorage();
    local PHeServerStorage = Engine:FetchServerStorage();

    local FrameworkServerStorage = Instance.new("Folder", PHeServerStorage);
    FrameworkServerStorage.Name = "Framework_Workflow:ServerStorage";
    FrameworkServerStorage.Parent = PHeServerStorage;
    FrameworkServerStorageFolder = FrameworkServerStorage

    local FrameworkReplicatedStorage = Instance.new("Folder", PHeReplicated);
    FrameworkReplicatedStorage.Name = "Framework_Workflow:Shared";
    SharedWorkflowFolder = FrameworkReplicatedStorage;
    
    local FrameworkReplicatedStorage_Services = Instance.new("Folder");
    FrameworkReplicatedStorage_Services.Name = "SharedServices";
    SharedServicesFolder = FrameworkReplicatedStorage_Services;
end;

BuildServer();

local FrameworkServer = {};
--[=[
    @class FrameworkServer
    @server
    Use `PowerHorseEngine:Import("Framework")` from a server script to access this library.
]=]


local PortedServices = {};

local ServerStarted=false;
local StartPromise;

--[=[
    Starts Framework on the server. It will return a `Promise`. You can call start multiple times
    but it is recommended that you have it called from one script only.
    ```lua
        local Framework = :Import("Framework");
        Framework:Start():Then(function(lib)
            print("Framework is running on the server");
        end):Catch(function(err)
            warn("Framework failed to start on the server because ",err)
        end);
    ```
]=]
function FrameworkServer:Start()
    -- print("Start")
    if(StartPromise)then return StartPromise;end;
    local Promise = PowerHorseEngine.new("Promise");
    Promise:Try(function(resolve,reject)
        local ServicesFolder = Instance.new("Folder",FrameworkServerStorageFolder);
        ServicesFolder.Name = "@Services";
        for _,v in pairs(PortedServices) do
            pcall(function()
                if(v.Shared)then
                    local SharedContainer = Instance.new("Folder");
                    SharedContainer.Name = v.ClassName;
                    v._dev.__SharedContainer = SharedContainer;
                    for name,value in pairs(v.Shared) do
                        local remotefunc = Instance.new("RemoteFunction",SharedContainer);
                        local Invoker = function(player,...)
                            if(typeof(value) == "function")then
                                local x = {...};
                                table.remove(x,1);
                                -- print(unpack(x));
                                return v.Shared[name](v,player,unpack(x));
                            end
                            return value;
                        end;
                       
                        remotefunc.OnServerInvoke = Invoker;
                        remotefunc.Name = name;
                    end;
                    SharedContainer.Parent = SharedServicesFolder;
                end
            end)
            --//Init
            local initRan,initResults = pcall(function()
                -- local PHe_RS = Engine:FetchReplicatedStorage();
                -- local WorflowShared = PHe_RS:WaitForChild("Framework_Workflow:Shared");
                -- local Modulars = Instance.new("Folder",FrameworkServerStorage);
                -- Modulars.Name = "@Services";
                v.Parent = ServicesFolder;
                return v:Init();
            end);
            if(not initRan)then
                reject("Failed to :Init a service at ["..v.ClassName.."] -> "..initResults);
                return;
            end;
        end;

        --//Start
        for _,v in pairs(PortedServices) do
            local startRan,startResults = pcall(function()
                return v:Start();
            end);
            if(not startRan)then
                reject("Failed to :Start a service at ["..v.ClassName.."] -> "..startResults);
                return;
            end
        end;
        SharedServicesFolder.Parent = SharedWorkflowFolder;
        ServerStarted = true;
        resolve(FrameworkServer);
    end);
    StartPromise = Promise;
    return Promise;
end;
--[=[
    Allows you to port multiple component classes at once.
]=]
function FrameworkServer:PortComponentClasses(...:any)
    local arr = {...};
    for _,v in pairs(arr) do
        for _,x in pairs(typeof(v) == "Instance" and v:GetDescendants() or v) do
            if(typeof(x) == "Instance" and x:IsA("ModuleScript"))then
                self:PortComponentClass(x);
            end;
        end
    end
end
--[=[
    ComponentClass are just modules which you can access by using Framework:GetComponentClass()

    For example, let's say in one of our services, we want to create a custom class. Instead of having the custom 
    class code in the service, we can port it as a component class. This is just a shorter version of having your
    components stored somewhere in replicated storage/server storage and having to load them.

    So basically, instead of having to use `game:GetService("ReplicatedStorage"):WaitForChild("Components"):WaitForChild("Component")`;
    You would just port your entire Component folder, then access them using `:GetComponentClass`
]=]
function FrameworkServer:PortComponentClass(Component:any)
    assert(not ComponentClasses[Component.Name], ("%s is already a component class stored in memory"):format(Component.Name));
    assert(Component:IsA("ModuleScript"), ("Expected ModuleScript as ComponentClass, got %s"):format(Component.ClassName))
    ComponentClasses[Component.Name] = require(Component);
end;
--[=[
    Allows you to port multiple services at once
]=]
function FrameworkServer:PortServices(...:any)
    local arr = {...};
    for _,v in pairs(arr) do
        for _,x in pairs(typeof(v) == "Instance" and v:GetDescendants() or v) do
            if(typeof(x) == "Instance" and x:IsA("ModuleScript"))then
                self:PortService(x);
            end;
        end
    end
end
--[=[
    Before Framework starts, you should call this method.

    You are expected to pass a folder, every module in that folder will be converted into Services then destroyed.

    Services need two methods, Init and Start

    ## Services Lifecycle

    :::note
    Whenever PortServices is called, it will loop through each Service and call their :Init method. After all
    Services are Initiated, It will then call the :Start method for each Service. So within the :Start method that means
    every Service was created and initiated, hence you can use :GetService() to get other Services within a Service.
    :::

    Example Service 1:
    ```lua
    local MyService = {
        initiated = false --> example property
    };
    
    function MyService:Init()
        print(self.Name.." is being initiated"); --> "MyService is being initiated";
        self.initiated = true;
        print(self.Name.." was initiated");
    end;

    function MyService:Start()
        print(self.Name.." has started"); --> "MyService has started";
    end;

    return MyService;
    ```
    Example Service 2:
    ```lua
    local MyService2 = {}
    
    function MyService2:Init()
        print(self.Name.." is being initiated"); --> "MyService2 is being initiated" !! Will print along side "MyService is being ititiated"
    end;

    function MyService2:Start()
        local MyService = self:GetService("MyService");
        print(MyService.initiated) --> true
    end;

    return MyService;
    ```

    :::warning
    There's no order in which services are initiated, this means trying to access another service within your Service
    :Init lifecycle can throw an error or infinite yield
    :::

]=]
function FrameworkServer:PortService(Service:any)
    ErrorService.assert(not ServerStarted, "Framework: Late service port caught. You tried to port a service after frame work :Start()");
    if(typeof(Service) == "Instance")then
        local ServiceRequired=require(Service);
        ServiceRequired.Name = ServiceRequired.Name or Service.Name;
        ServiceRequired.ClassName = ServiceRequired.ClassName or Service.Name;
        Service:Destroy();
        Service=ServiceRequired;
    end;

    ErrorService.assert(not PortedServices[Service.ClassName], "Framework: Failed to port service \""..Service.ClassName.."\" because the given service classname was already used");
  
    if(not Service.Init)then
        function Service:Init()
            -- ErrorService.tossMessage("Framework: No :Init() method is applied to your service \""..Service.ClassName.."\".");
            return;
        end
    end
    if(not Service.Start)then
        function Service:Start()
            -- ErrorService.tossMessage("Framework: No :Start() method is applied to your service \""..Service.ClassName.."\".");
            return;
        end
    end;
    
    function Service:GetService(...:any)
        return FrameworkServer:GetService(...);
    end;

    function Service:GetComponentClass(...:any)
        return FrameworkServer:GetComponentClass(...);
    end;

    function Service:UseChannel(ChannelName:string, ...:any):RemoteEvent
        local hasChannelsContainer = self._dev.__SharedContainer:FindFirstChild("Channels");
        if(not hasChannelsContainer)then
            local c = Instance.new("Folder");
            c.Name = "Channels";
            hasChannelsContainer = c;
            hasChannelsContainer.Parent = self._dev.__SharedContainer;
        end;
        local hasChannel = hasChannelsContainer:FindFirstChild(ChannelName);
        if(not hasChannel)then
            local ch = Instance.new("RemoteEvent");
            ch.Name = ChannelName;
            ch.Parent = hasChannelsContainer;
            hasChannel = ch;
        end;
        return hasChannel;
    end;


    function Service:_Render()
        return{};
    end;

    local AsClass = CustomClassService:Create(Service);
    PortedServices[Service.ClassName] = AsClass;
    -- AsClass.Parent = SharedServicesFolder;

end;

local function getServiceAsync(n,tries)
    if(PortedServices[n])then
        return PortedServices[n];
    else
  
        if(tries == nil)then tries = 1;end;
        task.wait(tries/4);
        if(StartPromise and StartPromise.PromiseState == "rejected")then
            ErrorService.tossError("Framework -> Could not fetch service : Promise Rejected, Services Were Not Loaded. Check Framework:Start():Catch to view what went wrong")
            return;
        end
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Framework:GetService(\""..n.."\") Because The Server Has Not Been Started. Make Sure :Start Was Called And Did Not Fail")
        end
        return getServiceAsync(n,tries+1);
    end
end
--//
local function getComponentClassAsync(n,tries)
    if(ComponentClasses[n])then
        return ComponentClasses[n];
    else
        if(tries == nil)then tries = 1;end;
        task.wait(tries/4);
        if(StartPromise and StartPromise.PromiseState == "rejected")then
            ErrorService.tossError("Framework -> Could not fetch component class : Promise Rejected, ComponentClasses Were Not Loaded. Check Framework:Start():Catch to view what went wrong")
            return;
        end
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Framework:GetComponentClass(\""..n.."\") Because The Server Has Not Been Started. Make Sure :Start Was Called And Did Not Fail")
        end
        return getComponentClassAsync(n,tries+1);
    end
end

--[=[]=]
function FrameworkServer:GetService(ServiceName:string)
    if(not ServerStarted)then
        return getServiceAsync(ServiceName);
    end
    return PortedServices[ServiceName];
end;

--[=[]=]
function FrameworkServer:GetComponentClass(ClassName:string)
    print(ComponentClasses);
    if(not ServerStarted)then
        return getComponentClassAsync(ClassName);
    end
    return ComponentClasses[ClassName];
end

return FrameworkServer;