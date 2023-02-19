local Players = game:GetService("Players")
local RunService = game:GetService("RunService");
local Types = require(script.Parent.Parent.Parent.Parent.Types);
local IsClient = RunService:IsClient();

--[=[
    @class SillitoBranch
]=]

local SillitoBranch = {
    Name = "WTF",
    ClassName = "SillitoBranch";
};

function SillitoBranch:_Render()
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local BranchContainer = IsClient and (Engine:FetchReplicatedStorage():WaitForChild("Sillito_Workflow:Shared"):WaitForChild("@Branches")) or (Engine:FetchServerStorage():WaitForChild("Sillito_Workflow:Server"):WaitForChild("@Branches"))

    local args = self._dev.args;
    self._portedServices = {};
    self._portedModulars = {};
    self._ServiceObjects = {};
    self._ComponentClasses = {};

    self.Name = args.BranchName;
    self.Parent = BranchContainer;

    self:_lockProperty("Name", "Branch name cannot be changed after initiation, changing the name may result in unwanted behaviour.")

    return {};
end;
--[=[
    @client
]=]
function SillitoBranch:CreateDedicatedScreenGui(ScreenGuiProps:{[string]:any}?)
    local ErrorService = self:_GetAppModule():GetService("ErrorService");
    if(not IsClient)then
        ErrorService.tossError("CreateDedicatedScreenGui Can only be called by a Sillito client branch", self.Name);
        return;
    end;
    local ScreenGui = Instance.new("ScreenGui");
    ScreenGui.Name = self.Name;
    ScreenGui.ResetOnSpawn = false;
    if(ScreenGuiProps)then
        for a,b in pairs(ScreenGuiProps) do
            ScreenGui[a] = b;
        end;
    end;
    if not (ScreenGuiProps and ScreenGuiProps.Parent)then
        local Player = game:GetService("Players").LocalPlayer;
        local PlayerGui = Player:WaitForChild("PlayerGui");
        ScreenGui.Parent = PlayerGui;
    end;
    return ScreenGui;
end;
--[=[
    @client
]=]
function SillitoBranch:PortModulars(...:any)
    local arr = {...};
    for _,v in pairs(arr) do
        for _,x in pairs(typeof(v) == "Instance" and v:GetDescendants() or v) do
            if(typeof(x) == "Instance" and x:IsA("ModuleScript"))then
                self:PortModular(x);
            end;
        end
    end;
    return self;
end;
--[=[]=]
function SillitoBranch:PortComponentClass(Component:any)
    assert(not self._ComponentClasses[Component.Name], ("%s is already a component class stored in memory"):format(Component.Name));
    assert(Component:IsA("ModuleScript"), ("Expected ModuleScript as ComponentClass, got %s"):format(Component.ClassName))
    self._ComponentClasses[Component.Name] = require(Component);
    return self;
end;
--[=[]=]
function SillitoBranch:PortComponentClasses(...:any)
    local arr = {...};
    for _,v in pairs(arr) do
        for _,x in pairs(typeof(v) == "Instance" and v:GetDescendants() or v) do
            if(typeof(x) == "Instance" and x:IsA("ModuleScript"))then
                self:PortComponentClass(x);
            end;
        end
    end;
    return self;
end;
function SillitoBranch:_getComponentClassAsync(n,tries)
    local ErrorService = self:_GetAppModule():GetService("ErrorService");
    local StartPromise = self._startPromise;
    if(self._ComponentClasses[n])then
        return self._ComponentClasses[n];
    else
        if(tries == nil)then tries = 1;end;
        task.wait(tries/4);
        if(StartPromise and StartPromise.State == "rejected")then
            ErrorService.tossError("Sillito -> Could not fetch component class : Promise Rejected, ComponentClasses Were Not Loaded. Check Sillito:Start():Catch to view what went wrong")
            return;
        end
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Sillito:GetComponentClass(\""..n.."\") Because The Server Has Not Been Started. Make Sure :Start Was Called And Did Not Fail")
        end
        return self:_getComponentClassAsync(n,tries+1);
    end
end
--[=[]=]
function SillitoBranch:GetComponentClass(ClassName:string)
    if not(IsClient and self._clientStarted or self._serverStarted)then
        return self:_getComponentClassAsync(ClassName);
    end
    return self._ComponentClasses[ClassName];
end

--[=[
    @client
]=]
function SillitoBranch:PortModular(Modular:any)
    local App = self:_GetAppModule();
    local CustomClassService = App:GetService("CustomClassService");
    local ErrorService = App:GetService("ErrorService");
    ErrorService.assert(not self._clientStarted, "Sillito: Late modular port caught. You tried to port a molular after frame work :Start()");
    if(typeof(Modular) == "Instance")then
        local ServiceRequired=require(Modular);
        ServiceRequired.Name = ServiceRequired.Name or Modular.Name;
        ServiceRequired.ClassName = ServiceRequired.ClassName or Modular.Name;
        Modular:Destroy();
        Modular=ServiceRequired;
    end;
    ErrorService.assert(not self._portedModulars[Modular.ClassName], "Sillito: Failed to port modular \""..Modular.ClassName.."\" because the given modular classname was already used");
  
    if(not Modular.Init)then
        function Modular:Init()
            -- ErrorService.tossMessage("Sillito: No :Init() method is applied to your modular \""..Modular.ClassName.."\".");
            return;
        end
    end
    if(not Modular.Start)then
        function Modular:Start()
            -- ErrorService.tossMessage("Sillito: No :Start() method is applied to your modular \""..Modular.ClassName.."\".");
            return;
        end
    end;

    local ogSelf = self;

    function Modular:GetModular(...)
        return ogSelf:GetModular(...)
    end;
    
    function Modular:GetService(...)
        return ogSelf:GetService(...);
    end;

    function Modular:GetComponentClass(...:any)
        return ogSelf:GetComponentClass(...);
    end;

    function Modular:CreateDedicatedScreenGui(ScreenGuiProps:{[string]:any}?)
        ScreenGuiProps = ScreenGuiProps or {};
        ScreenGuiProps.Name = ogSelf.Name.."-Branch@"..self.Name;
        return ogSelf:CreateDedicatedScreenGui(ScreenGuiProps);
    end;

    if(not Modular._Render)then
        function Modular:_Render()
            return function (Hooks)
                self._RenderHooksPassOn = Hooks;
            end
        end;
    end;

    local AsClass = CustomClassService:Create(Modular);
    self._portedModulars[Modular.ClassName] = AsClass;
    return self
end;

--
function SillitoBranch:_StartClient()
    if(self._startPromise)then
        return self._startPromise;
    end;
    local App = self:_GetAppModule();
    local State = App:Import("State");
    local Engine = App:GetGlobal("Engine");
    local Promise = App.new("Promise");
    Promise:Try(function(resolve,reject)
        local PHe_RS = Engine:FetchReplicatedStorage();
        local Modulars = Instance.new("Folder",self:GetRef());
        Modulars.Name = "@Modulars";
        --//Init
        for _,v in pairs(self._portedModulars) do
            local initRan,initResults = pcall(function()
                v.Parent = Modulars;
                v:Init(v._RenderHooksPassOn);
            end);
            if(not initRan)then
                reject("Failed to :Init a Modular at ["..v.ClassName.."] -> "..initResults);
                return;
            end;
        end;
        --//Start
        for _,v in pairs(self._portedModulars) do
            local startRan,startResults = pcall(function()
                local Hooks = v._RenderHooksPassOn;
                v._RenderHooksPassOn = nil;
                v:Start(Hooks);
            end);
            if(not startRan)then
                reject("Failed to :Start a Modular at ["..v.ClassName.."] -> "..startResults);
                return;
            end
        end;
        self._clientStarted = true;
        resolve(self);
    end);
    self._startPromise = Promise;
    return Promise;
end;

--[=[]=]
function SillitoBranch:Start()
    if(IsClient)then
        return self:_StartClient();
    end
    if(self._startPromise)then
        return self._startPromise;
    end;
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local ErrorService = App:GetService("ErrorService");
    local Promise = App.new("Promise");
    Promise:Try(function(resolve,reject)
        local ServicesFolder = Instance.new("Folder",self:GetRef());
        ServicesFolder.Name = "@Services";
        for _,v in pairs(self._portedServices) do
            pcall(function()
                if(v.Shared)then
                    local BranchShare = self._branchShare;
                    if(not BranchShare)then
                        BranchShare = Instance.new("Folder");
                        BranchShare.Name = self.Name;
                        BranchShare.Parent = Engine:FetchReplicatedStorage():WaitForChild("Sillito_Workflow:Shared"):WaitForChild("@Shared");
                        self._branchShare = BranchShare;
                    end
                    local SharedContainer = Instance.new("Folder");
                    SharedContainer.Name = v.ClassName;
                    v._dev.__SharedContainer = SharedContainer;
                    for name,value in pairs(v.Shared) do
                        local remotefunc = Instance.new("RemoteFunction",SharedContainer);
                        local Invoker = function(player,...)
                            if(typeof(value) == "function")then
                                local x = {...};
                                table.remove(x,1);
                                return v.Shared[name](v,player,unpack(x));
                            end
                            return value;
                        end;
                        remotefunc.OnServerInvoke = Invoker;
                        remotefunc.Name = name;
                    end;
                    SharedContainer.Parent = BranchShare;
                end;

                if(v.props)then
                    setmetatable(v.props, {
                       __newindex = function(_,key,value)
                        if(typeof(key) == "number" and Players:GetPlayerByUserId(key))then
                            local targetPlayer = Players:GetPlayerByUserId(key);
                            local proxy = {};

                            --> Set the values to the proxy and set the initial table to an empty one so __newindex and __index works.
                            for a,b in pairs(value) do
                                proxy[a] = b;
                                value[a] = nil;
                            end;

                            local clientPropsRemoter = v._dev.__SharedContainer:FindFirstChild("$"..key);
                            local initialListener;

                            if(not clientPropsRemoter)then
                                clientPropsRemoter = Instance.new("RemoteEvent");
                                initialListener = clientPropsRemoter.OnServerEvent:Connect(function(Player:Player)
                                    if(Player == targetPlayer)then
                                    --> We only listen for OnServerEvent once from the owner client to initiate values
                                        if(initialListener)then
                                            initialListener:Disconnect();initialListener = nil;
                                        end;
                                     --> Send the server props to the owner client (initial request from client)
                                        clientPropsRemoter:FireClient(Player,proxy)
                                    else
                                        warn(("%s fired an event that they should not have access to, serverSideProps for sillito"):format(Player.Name));
                                    end
                                end)
                                clientPropsRemoter.Name = "$"..key;
                                clientPropsRemoter.Parent = v._dev.__SharedContainer;
                            end;
                            setmetatable(value, {
                                __newindex = function(_,prop,val)
                                    proxy[prop] = val;
                                    clientPropsRemoter:FireClient(targetPlayer, proxy);
                                end;
                                __index = function(_,prop)
                                    return proxy[prop];
                                end
                            });
                        else
                            ErrorService.tossWarn(("[Sillito] You attempted to set a .prop key to \"%s\", You can only pass UserIds of players currently in this game. Value will not be added"):format(tostring(key)))
                        --[[
                        else
                            --> For props that aren't scoped to player id
                            rawset(v.props,key,value);
                            local propsRemoter = v._dev.__SharedContainer:FindFirstChild("$propsRemoter");
                            if(not propsRemoter)then
                                propsRemoter = Instance.new("RemoteEvent");
                                propsRemoter.Name = "$propsRemoter";
                                propsRemoter.Parent = v._dev.__SharedContainer;
                            end;
                            propsRemoter:FireAllClients(v.props);
                            ]]
                        end;

                       end
                    });
                end
            end);
            --//Init
            local initRan,initResults = pcall(function()
                v.Parent = ServicesFolder;
                v:Init(v._RenderHooksPassOn);
            end);
            if(not initRan)then
                reject("Failed to :Init a service at ["..v.ClassName.."] -> "..initResults);
                return;
            end;
        end;
        --//Start
        for _,v in pairs(self._portedServices) do
            local startRan,startResults = pcall(function()
                local Hooks = v._RenderHooksPassOn;
                v._RenderHooksPassOn = nil;
                v:Start(Hooks);
            end);
            if(not startRan)then
                reject("Failed to :Start a service at ["..v.ClassName.."] -> "..startResults);
                return;
            end
        end;
        -- SharedServicesFolder.Parent = self:GetRef();
        self._serverStarted = true;
        resolve(self);
    end);
    self._startPromise = Promise;
    return Promise;
end

--[=[
    @server
]=]
function SillitoBranch:PortServices(...:any)
    local arr = {...};
    for _,v in pairs(arr) do
        for _,x in pairs(typeof(v) == "Instance" and v:GetDescendants() or v) do
            if(typeof(x) == "Instance" and x:IsA("ModuleScript"))then
                self:PortService(x);
            end;
        end
    end;
    return self;
end

--[=[
    @server
]=]
function SillitoBranch:PortService(Service:any)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    local CustomClassService = App:GetService("CustomClassService");
    if(IsClient)then
        ErrorService.tossError("PortServices Can only be called by a Server branch");
    end;
    ErrorService.assert(not self._serverStarted, "Sillito: Late service port caught on branch \""..self.Name.."\". You tried to port a service after frame work :Start()");
    if(typeof(Service) == "Instance")then
        local ServiceRequired=require(Service);
        ServiceRequired.Name = ServiceRequired.Name or Service.Name;
        ServiceRequired.ClassName = ServiceRequired.ClassName or Service.Name;
        Service:Destroy();
        Service=ServiceRequired;
    end;

    ErrorService.assert(not self._portedServices[Service.ClassName], "Sillito: Failed to port service \""..Service.ClassName.."\" because the given service classname was already used");
  
    if(not Service.Init)then
        function Service:Init()
            -- ErrorService.tossMessage("Sillito: No :Init() method is applied to your service \""..Service.ClassName.."\".");
            return;
        end
    end
    if(not Service.Start)then
        function Service:Start()
            -- ErrorService.tossMessage("Sillito: No :Start() method is applied to your service \""..Service.ClassName.."\".");
            return;
        end
    end;

    local ogSelf = self;
    
    function Service:GetService(...:any)
        return ogSelf:GetService(...);
    end;
    --[=[
        @within SillitoBranch
    ]=]
    function Service:GetBranch(Branch:string)
        return ogSelf:GetBranch(Branch);
    end;
    --[=[
        @within SillitoBranch
    ]=] 
    function Service:HasBranch(Branch:string)
        return ogSelf:HasBranch(Branch);
    end;

    --[=[
        @within SillitoBranch
    ]=]
    function Service:GetComponentClass(...:any)
        return ogSelf:GetComponentClass(...);
    end;

    --[=[
        @within SillitoBranch
        :::warning
        In Order for this to work the service must have a `Shared` property.
        :::

        Idealy, you would want to call this method during the services Init lifecycle. You will then be able to access
        this Channel on the client by using `Service:UseChannel(ChannelName)`

        Channels are just [RemoteEvent]'s.
    ]=]
    function Service:UseChannel(ChannelName:string, ...:any):RemoteEvent
        local hasSharedContainer = self._dev.__SharedContainer;
        if(not hasSharedContainer)then
            error( ("Internal Sillito: Tried to UseChannel(\"%s\") on Service \"%s\" but no .Shared Property was provided, Services must be shared to use channel"):format(ChannelName,self.Name))
        end;
        local hasChannelsContainer = self._dev.__SharedContainer:FindFirstChild("@Channels");
        if(not hasChannelsContainer)then
            local c = Instance.new("Folder");
            c.Name = "@Channels";
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
        return function (Hooks)
            self._RenderHooksPassOn = Hooks;
        end
    end;

    local AsClass = CustomClassService:Create(Service);
    self._portedServices[Service.ClassName] = AsClass;
end;
--//
function SillitoBranch:_getServiceAsync(n,tries)
    local ErrorService = self:_GetAppModule():GetService("ErrorService");
    local StartPromise = self._startPromise;
    if(self._portedServices[n])then
        return self._portedServices[n];
    else
        if(tries == nil)then tries = 1;end;
        task.wait(tries/4);
        if(StartPromise and StartPromise.State == "rejected")then
            ErrorService.tossError("Sillito ["..self.Name.."] branch -> Could not fetch service : Promise Rejected, Services Were Not Loaded. Check Sillito:Start():Catch to view what went wrong")
            return;
        end
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Sillito:GetService(\""..n.."\") on branch \""..self.Name.."\" Because The Server Has Not Been Started. Make Sure :Start Was Called And Did Not Fail")
            ErrorService.tossWarn(debug.traceback("Call Stack:",1));
        end
        return self:_getServiceAsync(n,tries+1);
    end
end
--//
function SillitoBranch:_getModularAsync(n:string,tries:number?)
    local ErrorService = self:_GetAppModule():GetService("ErrorService");
    local StartPromise = self._startPromise;
    if(self._portedModulars[n])then
        return self._portedModulars[n];
    else
        if(tries == nil)then tries = 1;end;
        task.wait(tries/4);
        if(StartPromise and StartPromise.State == "rejected")then
            ErrorService.tossError("Sillito ["..self.Name.."] branch -> Could not fetch modular : Promise Rejected, Services Were Not Loaded. Check Sillito:Start():Catch to view what went wrong")
            return;
        end
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Sillito:GetModular(\""..n.."\")  on branch \""..self.Name.."\" Because The Server Has Not Been Started. Make Sure :Start Was Called And Did Not Fail")
            ErrorService.tossWarn(debug.traceback("Call Stack:",1));
        end
        return self:_getModularAsync(n,tries+1);
    end 
end

function SillitoBranch:GetBranch(BranchName:string)
    return require(script.Parent):GetBranch(BranchName);
end;
function SillitoBranch:HasBranch(BranchName:string)
    return require(script.Parent):HasBranch(BranchName);
end;

--[=[
    @client
]=]
function SillitoBranch:GetModular(ModularName:string)
    if(not self._clientStarted)then
        return self:_getModularAsync(ModularName);
    end
    return self._portedModulars[ModularName];
end

--[=[]=]
function SillitoBranch:GetService(ServiceName:string)
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local CustomClassService = App:GetService("CustomClassService");
    local ErrorService = App:GetService("ErrorService");
    if(IsClient)then
        if(self._ServiceObjects[ServiceName])then
            return self._ServiceObjects[ServiceName];
        end
        local PHe_RS = Engine:FetchReplicatedStorage();
        local WorflowShared = PHe_RS:WaitForChild("Sillito_Workflow:Shared");
        local SharedService = WorflowShared:WaitForChild("@Shared"):WaitForChild(self.Name);
        
        local hasShared = SharedService:FindFirstChild(ServiceName);
        if(not hasShared)then
            return ErrorService.tossError("\""..ServiceName.."\" Could not be found on branch \""..self.Name.."\". Make sure the server is returning \"Shared\" Functions");
        end;
    
        local newServiceObject = {
            Name = hasShared.Name;
            ClassName = hasShared.Name;
        };
        function newServiceObject:_Render()
            return{};
        end;
    
        function newServiceObject:UseChannel(ChannelName:string)
            local ContainsChannel = hasShared:FindFirstChild("@Channels");
            if(not ContainsChannel)then
                return self:_GetAppModule():GetService("ErrorService").tossWarn("No Channel Provided For \""..self.Name.."\"");
            end;
            return ContainsChannel:WaitForChild(ChannelName);
            -- return hasShared:FindFirstChild(ChannelName); 
        end;

        --[=[
            @within SillitoBranch
            @client
            Gets the server side objects within the .prop of the service. Service must have both .shared and .prop
        ]=]
        function newServiceObject:getServerSideProps()
            local State = self:_GetAppModule():Import("State");
            if(self.__loadedServerSideProps)then
                return self.__loadedServerSideProps;
            end;
            self.Parent = workspace;
            self.__loadedServerSideProps = {};
            local function updateServerSideProps(data:{[any]:any})
                --> Delete any state from a key that the server no longer has
                --[[
                for a,_ in pairs(self.__loadedServerSideProps) do
                    if(data[a] == nil)then
                        self.__loadedServerSideProps[a]:Destroy();
                        self.__loadedServerSideProps[a] = nil;
                    end
                end
                ]]
                --> Set and Create States
                for key,value in pairs(data) do
                    local existingState = (self.__loadedServerSideProps[key]);
                    if(existingState)then
                        existingState.State = value;
                    else
                        local newState = State(value);
                        newState.Parent = self;
                        self.__loadedServerSideProps[key] = newState;
                    end
                end;
            end;

            --[[
            local function updateServerSidePropsFromRemoter(props)
                if(not self.___loadedServerSideProps_FromRemoter)then
                    for a,b in pairs(props) do
                        if not(self.__loadedServerSideProps[a])then
                            self.__loadedServerSideProps[a] = true;
                        end
                    end
                end;
                updateServerSideProps(self.__loadedServerSideProps);
            end;
            
            local function connectToserverpropsRemoter(serverpropsRemoter)
                self._dev.serverpropsRemoter_Connected = serverpropsRemoter.OnClientEvent:Connect(function(props)
                    updateServerSidePropsFromRemoter(props);
                end);
            end;
            
            local serverpropsRemoter = hasShared:FindFirstChild("$propsRemoter");
            if(not serverpropsRemoter)then
                self._dev.serverpropsRemoterAdded_Connection = hasShared.ChildAdded:Connect(function(c)
                    if(c.Name == "$propsRemoter")then
                        self._dev.serverpropsRemoterAdded_Connection:Disconnect();
                        self._dev.serverpropsRemoterAdded_Connection = nil;
                        connectToserverpropsRemoter(c);
                    end;
                end);
            else
                connectToserverpropsRemoter(serverpropsRemoter);
            end
            serverpropsRemoter = nil;
            ]]
            
            local coms:RemoteEvent = hasShared:WaitForChild("$"..Players.LocalPlayer.UserId);
            coms:FireServer() --> Requests initial render request
            updateServerSideProps(coms.OnClientEvent:Wait()) --> Waits for the server to send back the initial data
            --> We then connect to the following events
            self._dev._serverProps_comsConnection = coms.OnClientEvent:Connect(function(data)
                updateServerSideProps(data);
            end);
            return self.__loadedServerSideProps;
        end
    
        for _,x in pairs(hasShared:GetChildren()) do
            newServiceObject[x.Name] = function(...)
                return x:InvokeServer(...);
                -- return res;
            end
        end
    
        local asClass = CustomClassService:Create(newServiceObject);
        self._ServiceObjects[ServiceName] = asClass;
        return asClass; 
    else
        if(not self._serverStarted)then
            return self:_getServiceAsync(ServiceName);
        end
        return self._portedServices[ServiceName];
    end
end;

return SillitoBranch;