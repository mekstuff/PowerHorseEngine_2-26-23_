local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local ErrorService = PowerHorseEngine:GetService("ErrorService");
local Engine = PowerHorseEngine:GetGlobal("Engine");
local CustomClassService = PowerHorseEngine:GetService("CustomClassService");

-- local FrameworkFolder;
local ComponentClasses = {};

local FrameworkClient = {};
--[=[
    @class FrameworkClient
    @client
    Use `PowerHorseEngine:Import("Framework")` from a client script to access this library.
]=]

local PortedModulars = {};

local ClientStarted=false;
local StartPromise;

--[=[
    Starts Framework on the client. It will return a `Promise`. You can call start multiple times
    but it is recommended that you have it called from one script only.
    ```lua
        local Framework = :Import("Framework");
        Framework:Start():Then(function(lib)
            print("Framework is running on the client");
        end):Catch(function(err)
            warn("Framework failed to start on the client because ",err)
        end);
    ```
]=]
function FrameworkClient:Start()
    if(StartPromise)then return StartPromise;end;
    -- FrameworkFolder = Instance.new("Folder");
    -- FrameworkFolder.Name = "@Modulars";

    local Promise = PowerHorseEngine.new("Promise");
    Promise:Try(function(resolve,reject)
        local PHe_RS = Engine:FetchReplicatedStorage();
        local WorflowShared = PHe_RS:WaitForChild("Framework_Workflow:Shared");
        local Modulars = Instance.new("Folder",WorflowShared);
        Modulars.Name = "@Modulars";
        --//Init
        for _,v in pairs(PortedModulars) do
            local initRan,initResults = pcall(function()
                v.Parent = Modulars;
                return v:Init();
            end);
            if(not initRan)then
                reject("Failed to :Init a service at ["..v.ClassName.."] -> "..initResults);
                return;
            end;
        end;
        --//Start
        for _,v in pairs(PortedModulars) do
            local startRan,startResults = pcall(function()
                return v:Start();
            end);
            if(not startRan)then

                reject("Failed to :Start a service at ["..v.ClassName.."] -> "..startResults);
                return;
            end
        end;
        ClientStarted = true;
        resolve(self);
    end);
    StartPromise = Promise;
    return Promise;
end;

--[=[
    Allows you to port multiple component classes at once.
]=]
function FrameworkClient:PortComponentClasses(...:any)
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
function FrameworkClient:PortComponentClass(Component:any)
    assert(not ComponentClasses[Component.Name], ("%s is already a component class stored in memory"):format(Component.Name));
    assert(Component:IsA("ModuleScript"), ("Expected ModuleScript as ComponentClass, got %s"):format(Component.ClassName))
    ComponentClasses[Component.Name] = require(Component);
end;

--[=[
    Allows you to port multiple modulars at once
    :PortModulars(BasicModularsPath,AdvancedModularsPath,BackupModularsPath)
]=]
function FrameworkClient:PortModulars(...:any)
    local arr = {...};
    for _,v in pairs(arr) do
        for _,x in pairs(typeof(v) == "Instance" and v:GetDescendants() or v) do
            if(typeof(x) == "Instance" and x:IsA("ModuleScript"))then
                self:PortModular(x);
            end;
        end
    end
end
--[=[
    Before Framework starts, you should call this method.
    A modular is considered the client version of a service.

    You are expected to pass a folder, every module in that folder will be converted into modulars then destroyed.

    Modulars need two methods, Init and Start

    ## Modulars Lifecycle

    :::note
    Whenever PortModulars is called, it will loop through each modular and call their :Init method. After all
    Modulars are Initiated, It will then call the :Start method for each modular. So within the :Start method that means
    every modular was created and initiated, hence you can use :GetModular() to get other modulars within a modular.
    :::

    Example Modular 1:
    ```lua
    local MyModular = {
        initiated = false --> example property
    };
    
    function MyModular:Init()
        print(self.Name.." is being initiated"); --> "MyModular is being initiated";
        self.initiated = true;
        print(self.Name.." was initiated");
    end;

    function MyModular:Start()
        print(self.Name.." has started"); --> "MyModular has started";
    end;

    return MyModular;
    ```
    Example Modular 2:
    ```lua
    local MyModular2 = {}
    
    function MyModular2:Init()
        print(self.Name.." is being initiated"); --> "MyModular2 is being initiated" !! Will print along side "MyModular is being ititiated"
    end;

    function MyModular2:Start()
        local MyModular = self:GetModular("MyModular");
        print(MyModular.initiated) --> true
    end;

    return MyModular;
    ```

    :::warning
    There's no order in which modulars are initiated, this means trying to access another modular within your modulars
    :Init lifecycle can throw an error or infinite yield
    :::



    :::note
    You can access server modulars which are actually just called "Services" within your modulars by using
    :GetService. The services must have a shared property though, learn more about here from `FrameworkServer` 
    :::
]=]
function FrameworkClient:PortModular(Modular:any)
    ErrorService.assert(not ClientStarted, "Framework: Late modular port caught. You tried to port a molular after frame work :Start()");
    if(typeof(Modular) == "Instance")then
        local ServiceRequired=require(Modular);
        ServiceRequired.Name = ServiceRequired.Name or Modular.Name;
        ServiceRequired.ClassName = ServiceRequired.ClassName or Modular.Name;
        Modular:Destroy();
        Modular=ServiceRequired;
    end;

    ErrorService.assert(not PortedModulars[Modular.ClassName], "Framework: Failed to port modular \""..Modular.ClassName.."\" because the given modular classname was already used");
  
    if(not Modular.Init)then
        function Modular:Init()
            -- ErrorService.tossMessage("Framework: No :Init() method is applied to your modular \""..Modular.ClassName.."\".");
            return;
        end
    end
    if(not Modular.Start)then
        function Modular:Start()
            -- ErrorService.tossMessage("Framework: No :Start() method is applied to your modular \""..Modular.ClassName.."\".");
            return;
        end
    end;

    function Modular:GetModular(...)
        return FrameworkClient:GetModular(...)
    end
    
    function Modular:GetService(...)
        return FrameworkClient:GetService(...);
    end

    function Modular:GetComponentClass(...:any)
        return FrameworkClient:GetComponentClass(...);
    end

    if(not Modular._Render)then
        function Modular:_Render()
            return{};
        end;
    end;

    local AsClass = CustomClassService:Create(Modular);
    PortedModulars[Modular.ClassName] = AsClass;
    -- AsClass.Parent = FrameworkFolder;
end;

local function getModularAsync(n,tries)
    if(PortedModulars[n])then
        return PortedModulars[n];
    else
  
        if(tries == nil)then tries = 1;end;
        task.wait(tries/4);
        if(StartPromise and StartPromise.PromiseState == "rejected")then
            ErrorService.tossError("Framework -> Could not fetch modular : Promise Rejected, Services Were Not Loaded. Check Framework:Start():Catch to view what went wrong")
            return;
        end
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Framework:GetModular(\""..n.."\") Because The Server Has Not Been Started. Make Sure :Start Was Called And Did Not Fail")
        end
        return getModularAsync(n,tries+1);
    end
end
--[=[]=]
function FrameworkClient:GetModular(ServiceName:string)
    if(not ClientStarted)then
        return getModularAsync(ServiceName);
    end
    return PortedModulars[ServiceName];
end;

--//
local ServiceObjects = {};
--[=[
    :::note
    Used to access server Services
    
    Once the Service provides a shared prop, It will wait until the Service was initiated on the server.
    So calling Framework:GetService before Frame:Start was called is fine and will yield until the server 
    initiated the service. You are not required to use `Modulars` to access `Services`
    :::
]=]
function FrameworkClient:GetService(ServiceName:string)
    if(ServiceObjects[ServiceName])then
        return ServiceObjects[ServiceName];
    end
    local PHe_RS = Engine:FetchReplicatedStorage();
    local WorflowShared = PHe_RS:WaitForChild("Framework_Workflow:Shared");
    local SharedService = WorflowShared:WaitForChild("SharedServices");

    local hasShared = SharedService:FindFirstChild(ServiceName);
    if(not hasShared)then
        return ErrorService.tossError("\""..ServiceName.."\" Could not be found. Make sure the server is returning \"Shared\" Functions");
    end;

    local newServiceObject = {
        Name = hasShared.Name;
        ClassName = hasShared.Name;
    };
    function newServiceObject:_Render()
        return{};
    end;

    function newServiceObject:UseChannel(ChannelName:string)
        local ContainsChannel = hasShared:FindFirstChild("Channels");
        if(not ContainsChannel)then
            return self:_GetAppFramework():GetService("ErrorService").tossWarn("No Channel Provided For \""..self.Name.."\"");
        end;
        return ContainsChannel:WaitForChild(ChannelName);
        -- return hasShared:FindFirstChild(ChannelName); 
    end

    for _,x in pairs(hasShared:GetChildren()) do
        newServiceObject[x.Name] = function(...)
            return x:InvokeServer(...);
            -- return res;
        end
    end

    local asClass = CustomClassService:Create(newServiceObject);
    ServiceObjects[ServiceName] = asClass;

    return asClass;
end;
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
function FrameworkClient:GetComponentClass(ClassName:string)

    if(not ClientStarted)then
        return getComponentClassAsync(ClassName);
    end
    return ComponentClasses[ClassName];
end

return FrameworkClient;