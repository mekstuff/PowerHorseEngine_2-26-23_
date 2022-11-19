local RunService = game:GetService("RunService");
local ServerScriptService = game:GetService("ServerScriptService")
local IsClient = RunService:IsRunning() and RunService:IsClient();
--[=[
    @class ServerBee
    @tag Library
]=]
local ServerBee = {
    Name = "ServerBee",
    ClassName = "ServerBee",
}

local function validateState(State)
    if(typeof(State) == "table" and State:IsA("State"))then
        return true;
    end
end;

function ServerBee:ValidateDepedency(Player:Player,objectHost:table,TargetHOST_KEY:string)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    local Validated = false;
    if(typeof(objectHost.ClientDepedencies) == "function")then
        local res = objectHost.ClientDepedencies(Player,TargetHOST_KEY);
        ErrorService.assert(typeof(res) == "boolean", ("boolean expected from ClientDepedencies Callback function, got %s"):format(typeof(res)));
        Validated = res;
    elseif(typeof(objectHost.ClientDepedencies) == "table")then
        if(#objectHost.ClientDepedencies == 0)then
            Validated = true;
        else
            --> Loop through and validate
            Validated = true;
        end
    end;
    return Validated;
end

--[=[]=]
function ServerBee:OnServerEvent(HOST_KEY:string,Handler:any)
     
end;
function ServerBee:REMOVEHOST(HOST_KEY:string)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    local HOST = self._Hosting[HOST_KEY];
    if(HOST)then
        HOST.HOST_Servant:Destroy();
        self._Hosting[HOST_KEY] = nil;
    else
        ErrorService.tossWarn(("\"%s\" is not being HOSTED, cannot remove HOST"):format(HOST_KEY));
    end;
end;
--> Remember to remove subscription references when a player leaves
function ServerBee:HOST(HOST_KEY:string,State:any,ClientDepedencies:table?)
    local App = self:_GetAppModule();
    local HOST_Servant = App.new("Servant");
    local ErrorService = App:GetService("ErrorService");
    ErrorService.assert(typeof(HOST_KEY) == "string", ("string expected for HOST_KEY, got %s"):format(typeof(HOST_KEY)));
    ErrorService.assert(validateState(State), ("State expected, got %s"):format(typeof(State)));
    self._Hosting[HOST_KEY] = {
        State = State;
        ClientDepedencies = ClientDepedencies;
        HOST_Servant = HOST_Servant;
        Subscriptions = {
            Client = {};
            Server = {};
        }
    };
    if(ClientDepedencies)then
        local ClientTrigger = Instance.new("RemoteEvent");
        ClientTrigger.Name = HOST_KEY;
        ClientTrigger.Parent = self._Client;
        HOST_Servant:Keep(ClientTrigger);
        -- self._Hosting[HOST_KEY]["ClientTrigger"] = ClientTrigger;
        HOST_Servant:Keep(State:useEffect(function()
            for p:Player,_:boolean in pairs(self._Hosting[HOST_KEY].Subscriptions.Client) do
                ClientTrigger:FireClient(p,HOST_KEY,State())
            end;
        end));

        ClientTrigger.OnServerEvent:Connect(function(Player:Player,TargetHOST_KEY:string)
            ErrorService.assert(typeof(TargetHOST_KEY) == "string", ("string expected for TargetHOST_KEY from client \"%s\", got %s"):format(Player.Name,typeof(HOST_KEY)));
            local objectHost = self._Hosting[TargetHOST_KEY]
            if(objectHost)then
                local Validated = self:ValidateDepedency(Player,objectHost,TargetHOST_KEY);
                if(not Validated)then
                    ErrorService.tossWarn(("\"%s\" denied access to HOST_KEY \"%s\". reason: not valid client depedency"):format(Player.Name,TargetHOST_KEY));
                else
                    objectHost.Subscriptions.Client[Player] = true
                    ClientTrigger:FireClient(Player, HOST_KEY, State());
                end
            else
                ErrorService.tossWarn(("\"%s\" HOST_KEY was not found by the server, \"%s\" made this query"):format(TargetHOST_KEY,Player.Name))
            end;
        end)
    end
end;

function ServerBee:_Render()
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local PHeSS = Engine:FetchServerStorage();
    local PHeRS = Engine:FetchReplicatedStorage();

    local ServerBeeStorage = Instance.new("Folder");
    ServerBeeStorage.Name = "@"..self.ClassName;
    local Clients = Instance.new("Folder",ServerBeeStorage);
    Clients.Name = "@Client";
    local ServerBeeServer = Instance.new("Folder");
    ServerBeeServer.Name = "@"..self.ClassName;
    local Servers = Instance.new("Folder",ServerBeeServer);
    Servers.Name = "@Server";

    ServerBeeStorage.Parent = PHeRS;
    ServerBeeServer.Parent = PHeSS;

    self._Storage = ServerBeeStorage;
    self._Client = Clients;
    self._Server = Servers;
    self._Hosting = {};
    return {};
end

--[=[
    @class ServerBeeClient
]=]
local ServerBeeClient = {
    Name = "ServerBeeClient",
    ClassName = "ServerBee",
}

function ServerBeeClient:_Render()
    self._Subscriptions = {};
    return {};
end;

--[=[
    @client
]=]
function ServerBeeClient:_GetEventItem(Storage:Folder,ItemName:string,TRIES:number?,TRIES_WARN:number?):RemoteEvent
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    TRIES = TRIES or 1;
    TRIES_WARN = TRIES_WARN or 10;
    local Find = Storage:FindFirstChild(ItemName);
    if(not Find)then
        if(TRIES_WARN == TRIES)then
            ErrorService.tossWarn(("Attempted %s tries on GetEventItem \"%s\". Does the HOST support client dependencies?"):format(tostring(TRIES),ItemName))
        end;
        task.wait(TRIES/7)
        return self:_GetEventItem(Storage,ItemName,TRIES+1,TRIES_WARN);
    end;
    return Find;
end

--[=[
    @client
]=]
function ServerBeeClient:SUBSCRIBE(HOST_KEY:string,Handler:any)
    local App = self:_GetAppModule();
    local Subscription = App.new("Servant");
    Subscription.Name = HOST_KEY.."-SubscriptionToken"
    local ErrorService = App:GetService("ErrorService");
    ErrorService.assert(typeof(HOST_KEY) == "string", ("string expected for HOST_KEY, got %s"):format(typeof(HOST_KEY)));
    ErrorService.assert(typeof(Handler) == "function", ("function expected for SUBSCRIBE Handler, got %s"):format(typeof(Handler)));
    local Engine = App:GetGlobal("Engine");    
    local PHeRS = Engine:FetchReplicatedStorage();
    local ServerBeeStorage = PHeRS:WaitForChild("@"..self.ClassName):WaitForChild("@Client");
    local Item = self:_GetEventItem(ServerBeeStorage,HOST_KEY);
    local SubscriptionCleanup;
    Subscription:Keep(Item.OnClientEvent:Connect(function(TargetHOST_KEY:string,State:any)
        if(TargetHOST_KEY == HOST_KEY)then
            SubscriptionCleanup = Handler(State);
        end
    end));
    Item.Destroying:Connect(function()
        if(Subscription and Subscription._dev)then
            Subscription:Destroy();
        end
    end);
    Subscription.Destroying:Connect(function()
        if(SubscriptionCleanup)then
            SubscriptionCleanup();
        end
    end);
    Item:FireServer(HOST_KEY);
    return Subscription;
end;

--[=[
    @client
]=]
function ServerBeeClient:UBSUBSCRIBE(SubscriptionToken:any)
    SubscriptionToken:Destroy();
end

local CustomClassService = require(script.Parent.Parent.Providers.ServiceProvider):LoadServiceAsync("CustomClassService");
return IsClient and CustomClassService:Create(ServerBeeClient) or CustomClassService:Create(ServerBee);
-- return :Create(ServerBee);