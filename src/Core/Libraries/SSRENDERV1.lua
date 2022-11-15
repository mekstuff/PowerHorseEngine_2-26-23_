--[=[
    @class SSRENDERV1
]=]

local RunService = game:GetService("RunService");
local IsClient,IsRunning = RunService:IsClient(),RunService:IsRunning();

local SSRENDERV1 = {
    Name = "SSRENDERV1",
    ClassName = "SSRENDERV1",
    Hosts = {};
};
function SSRENDERV1:_Render()
    if(not IsClient)then
        self:_HandleRequests();
        self:_InitiateStorage();

        return function(Hooks)
            local useEffect = Hooks.useEffect;
        end
    end
    return {};
end

--[=[]=]
function SSRENDERV1:_InitiateStorage()
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local SSRENDERV1Storage = Instance.new("Folder");
    SSRENDERV1Storage.Name = self.Name.."-HOSTS";
    SSRENDERV1Storage.Parent = Engine:FetchReplicatedStorage();
    self._Storage = SSRENDERV1Storage;
end;

--[=[
    @private
]=]
function SSRENDERV1:_HandleRequests()
    local App = self:_GetAppModule();
    if(IsRunning and IsClient)then
        local Engine = App:GetGlobal("Engine");
        local SSRENDERV1_SUBSCRIBEREQUEST = Engine:FetchStorageEvent("SSRENDERV1_SUBSCRIBEREQUEST");
        SSRENDERV1_SUBSCRIBEREQUEST.OnServerEvent:Connect(function(Player:Player,HOST_KEY:string)
            
        end);
        return;
    end;

end;
--[=[
    @param INITIALIZER function -- Called whenever the state of the HOST is nil (Return a value to setState of HOST)
    @param HANDLER function -- Called whenever the state of the HOST is not nil
]=]
local function defaultClientSubscriptionHandler()
    print("["..script.Name.."] defaultClientSubscriptionHandler in use, this will always return true. Validate your ClientSubscriptionHandler by passing a function as your fourth argument in your HOST method.");
    return true;
end;

function SSRENDERV1:HOST(HOST_KEY:string, INITIALIZER:any, HANDLER:any, ClientSubscriptionHandler:any?, ClientSubscriptionHandlerTriggeredByServer:boolean?)
    local App = self:_GetAppModule();
    local State = App:Import("State");
    local ErrorService = App:GetService("ErrorService");
    ErrorService.assert(typeof(HOST_KEY) == "string", ("[$SCRIPT_NAME] Cannot HOST without a HOST_KEY as a string, got %s"):format(typeof(HOST_KEY)));
    if(self.Hosts[HOST_KEY])then
        return ErrorService.tossError(("[$SCRIPT_NAME] Tried to create HOST with HOST_KEY \"%s\" but the HOST_KEY already exists"):format(HOST_KEY));
    end;
    ErrorService.assert(typeof(INITIALIZER) == "function", ("[$SCRIPT_NAME] Cannot HOST without a INITIALIZER as a function, got %s"):format(typeof(INITIALIZER)));
    ErrorService.assert(typeof(INITIALIZER) == "function", ("[$SCRIPT_NAME] Cannot HOST without a HANDLER as a function, got %s"):format(typeof(HANDLER)));

    self.Hosts[HOST_KEY] = {
        INITIALIZER = INITIALIZER,
        HANDLER = HANDLER,
        ClientSubscriptionHandler = ClientSubscriptionHandler or defaultClientSubscriptionHandler;
        ClientSubscriptionHandlerTriggeredByServer = ClientSubscriptionHandlerTriggeredByServer;
        ServerSubscriptions = {};
        ClientSubscriptions = {};
    }

    local RemoteEvent = Instance.new("RemoteEvent");
    RemoteEvent.Name = "@"..HOST_KEY;
    RemoteEvent.Parent = self._Storage;

    local HostState,setHostState = State(nil);

    HostState:useEffect(function()
        if(HostState() == nil)then
            setHostState(INITIALIZER());
        else
            self:_HandleHost(self.Hosts[HOST_KEY])
            -- print(self.Hosts[HOST_KEY].ServerSubscriptions)
        end
    end);
end;

function SSRENDERV1:_HandleHost(Host:table)
    
end;

function SSRENDERV1:GetStorageClient(TRIES:number?,MAX_TRIES:number?)
    MAX_TRIES = MAX_TRIES or 30;
    TRIES = TRIES or 1;
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local ErrorService = App:GetService("ErrorService");
    local RStorage = Engine:FetchReplicatedStorage();
    local Item = RStorage:FindFirstChild(self.Name.."-HOSTS");
    if(Item)then
        return Item;
    else
        TRIES = TRIES+1;
        if(TRIES == MAX_TRIES)then
            ErrorService.tossWarn("[$SCRIPT_NAME] GetStorageClient exhuasted MAX_TRIES, will continue to attempt fetching infinitely");
        end;
        task.wait(TRIES/7)
        self:GetStorageClient(TRIES,MAX_TRIES)
    end
end;

--[=[]=]
function SSRENDERV1:SUBSCRIBE(HOST_KEY:string,Handler:any)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    ErrorService.assert(typeof(HOST_KEY) == "string", ("[$SCRIPT_NAME] Cannot SUBSCRIBE without a HOST_KEY as a string, got %s"):format(typeof(HOST_KEY)));
    -- if(IsRunning and IsClient)then
        local StorageClient = self:GetStorageClient();
        local n = "@"..HOST_KEY;
        local Eventer = StorageClient:FindFirstChild(n);
        if(not Eventer)then
            ErrorService.tossWarn(("[$SCRIPT_NAME] SUBSCRIBE requires yield on \"%s\" because it was not created by the server yet."):format(HOST_KEY));
            Eventer = StorageClient:WaitForChild(n);
        end;
        if(IsRunning and IsClient)then
            Eventer:FireServer();
        else
            local Host = self.Hosts[HOST_KEY];
            if(Host.ClientSubscriptionHandlerTriggeredByServer)then
                local proceed = Host.ClientSubscriptionHandler(nil, HOST_KEY);
                if(typeof(proceed) ~= "boolean")then
                    --> Error instead
                    ErrorService.tossWarn(("[$SCRIPT_NAME] Invalid response from ClientSubscriptionHandler, Must be a boolean [true/false], got %s"):format(typeof(proceed)))
                    return;
                end;
            end;
            table.insert(Host.ServerSubscriptions,Handler);
        end
end;

return require(script.Parent.Parent.Providers.ServiceProvider):LoadServiceAsync("CustomClassService"):Create(SSRENDERV1);
