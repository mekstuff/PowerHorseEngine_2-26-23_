local CollectionService = game:GetService("CollectionService");
local ServiceProvider = require(script.Parent.Parent.Providers.ServiceProvider)
local CustomClassService = ServiceProvider:LoadServiceAsync("CustomClassService");
local PseudoService = ServiceProvider:LoadServiceAsync("PseudoService");
local SerializationService = ServiceProvider:LoadServiceAsync("SerializationService");
local IsClient = game.Players.LocalPlayer and true;

--TOOD: Optimize how we send data from server->client, so it does not serialize and deserialize entire tables every entry.

--[=[
    @class Collector
]=]


local TagProps = {};

local function filterTagPropsForClientRequest() --TODO: optimize maybe
    if(not IsClient)then
        local t = {};
        local found = false;
        for instance,x in pairs(TagProps) do
            for tagname,tagprops in pairs(x) do
                if(tagprops._scope ~= "server")then
                    if(not t[instance])then
                        t[instance] = {};
                    end;
                    found = true;
                    t[instance][tagname] = tagprops;
                end
            end
        end;
        local res = found and SerializationService:SerializeAsync(t) or t;
        return res;
    end
end;

--[[
local CollectorServerCommunicator;
if(not IsClient)then
    CollectorServerCommunicator = Instance.new("RemoteEvent");
    CollectorServerCommunicator.Name = "CollectorServerCommunicator";
    CollectorServerCommunicator.Parent = require(script.Parent.Parent.Parent):GetGlobal("Engine"):FetchReplicatedStorage();
    local cacheInitRequests = {};
    CollectorServerCommunicator.OnServerEvent:Connect(function(player)
        if(cacheInitRequests[player])then
            warn("Already sent to them");
            return;
        end;
        cacheInitRequests[player] = true;
        CollectorServerCommunicator:FireClient(player,filterTagPropsForClientRequest())
    end);
    game.Players.PlayerRemoving:Connect(function(player)
        cacheInitRequests[player] = nil;
    end)
end
]]

local Collector = {
    Name = "Collector",
    ClassName = "Collector",
};

function Collector:_GetPseudoFromInstance(instance:any)
    return PseudoService:GetPseudoFromId(instance);
end;

function Collector:_GetTagInstanceObject(instance:any)
    if(instance:IsA("Pseudo"))then
        instance = instance:GetRef();
    end
    return instance;
end

--[=[
    @private
]=]
function Collector:_SaveTagProps(instance:any,tagname:any,tagprops:any)
    if(instance)then
        if(not TagProps[instance])then
            TagProps[instance] = {};
        end;
        TagProps[instance][tagname] = tagprops;
    end;
    --[[
    if(not IsClient)then
        print("Fired all clients")
        CollectorServerCommunicator:FireAllClients(filterTagPropsForClientRequest())
    end
    ]]
end;

local ServerSentReplicatedTagProps;

--[=[
    @private
]=]
function Collector:_getCollectorServerCommunicator()
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local RSStorage = Engine:FetchReplicatedStorage();
    local Event = RSStorage:FindFirstChild("CollectorServerCommunicator");
    --TODO: Need to wait if not found
    return Event;
end;
--[=[]=]
function Collector:_connectToCommunicator()
    if(not ServerSentReplicatedTagProps)then
        local Event = self:_getCollectorServerCommunicator();
        Event:FireServer();
        local initialRequest = Event.OnClientEvent:Wait();
        if(not initialRequest)then
            return;
        end;
        if(typeof(initialRequest) == "table")then
            --> Means that the server has an empty array, so no need to deserialize anything
            initialRequest = nil;
        end
        ServerSentReplicatedTagProps = initialRequest and SerializationService:DeserializeAsync(initialRequest) or {};
        self._dev._serverCommunicatorConnection = Event.OnClientEvent:Connect(function(serial:string)
            local deserial = SerializationService:DeserializeAsync(serial);
            print("Set item");
            ServerSentReplicatedTagProps = deserial;
            -- ServerSentReplicatedTagProps = SerializationService:DeserializeAsync(...);
        end);
    end
end
--[=[
    @private
]=]
function Collector:_GetSavedTagProps(instance:any,tagname:any,yieldForProps)
    if(TagProps[instance])then
        local t = TagProps[instance][tagname];
        if(t)then
            return t;
        end;
    end;
    if(IsClient)then
        --[[
        if(not ServerSentReplicatedTagProps)then
            self:_connectToCommunicator();
        end;
        ]]
        return ServerSentReplicatedTagProps and ServerSentReplicatedTagProps[instance] and ServerSentReplicatedTagProps[instance][tagname];
    end
end


--[=[
    @private
]=]
function Collector:_Tag(instance:any,tagname:string,tagprops:{[any]:any}?):nil
    instance = self:_GetTagInstanceObject(instance);
    self:_SaveTagProps(instance,tagname,tagprops);
    CollectionService:AddTag(instance,tagname);
end;

--[=[
    @private
]=]
function Collector:_RemoveTag(instance:any,tagname:string):nil
    instance = self:_GetTagInstanceObject(instance);
    CollectionService:RemoveTag(instance,tagname);
end;
--[=[]=]
function Collector:GetTagged(tag:string)
    local tags = CollectionService:GetTagged(tag);
    local t = {};
    for _,x in pairs(tags) do
        table.insert(t, self:_GetPseudoFromInstance(x) or x);
    end;
    return t;
end
--[=[
    @param instance Pseudo | Instance
]=]
function Collector:HasTag(instance:any,tagname:string):boolean
    instance = self:_GetTagInstanceObject(instance);
    return CollectionService:HasTag(instance,tagname)
end;
--[=[
    @param instances table | Pseudo | Instance
]=]
function Collector:Tag(instances:table|Instance,tagname:string,tagprops:{[any]:any}?):nil
    if(typeof(instances) == "table" and not instances.IsA)then
        for _,x in pairs(instances) do
            self:_Tag(x,tagname,tagprops);
        end;
    else
        self:_Tag(instances,tagname,tagprops);
    end;
end;
--[=[]=]
function Collector:AddTag(...:any)
    return self:Tag(...);
end;
--[=[
    @param instances table | Instance | Pseudo
]=]
function Collector:RemoveTag(instances:table|Instance,tagname:string):nil
    if(typeof(instances) == "table")then
        for _,x in pairs(instances) do
            self:_RemoveTag(x,tagname);
        end;
    else
        self:_RemoveTag(instances,tagname);
    end;
end;
--[=[
    @return Servant
]=]
function Collector:Bind(Tag:string,Callback:any,yieldForProps:boolean?)
    local App = self:_GetAppModule();
    local BindID = tostring(Callback);
    local BindServant = App.new("Servant");
    BindServant.Name = "CollectorBinder-"..BindID:gsub("function: ","");
    BindServant._dev.Cleanup = {};

    self._dev.Servants[Callback] = BindServant;

    local function handleCallback(x)
        coroutine.wrap(function()
            -- local cleanup = Callback(x);
            local cleanup = Callback(x,self:_GetSavedTagProps(x,Tag,yieldForProps));
            if(cleanup)then
                BindServant._dev.Cleanup[x] = cleanup;
            end
        end)();
    end;

    BindServant:Connect(CollectionService:GetInstanceAddedSignal(Tag), function(instance)
        if(instance:FindFirstChild("_pseudoid"))then
            instance = PseudoService:GetPseudoFromId(instance);
        end;
        handleCallback(instance);
    end);
    BindServant:Connect(CollectionService:GetInstanceRemovedSignal(Tag), function(instance)
        if(instance:FindFirstChild("_pseudoid"))then
            instance = PseudoService:GetPseudoFromId(instance);
        end;
        if(BindServant._dev.Cleanup[instance])then
            BindServant._dev.Cleanup[instance]();
            BindServant._dev.Cleanup[instance]=nil;
        end
    end);
    for _,v in pairs(CollectionService:GetTagged(Tag)) do
        if(v:FindFirstChild("_pseudoid"))then
            v = PseudoService:GetPseudoFromId(v) or v;
        end;
        handleCallback(v);
    end;
    self._dev.MainServant:Keep(BindServant);
    return BindServant;
end;

--[=[
    @param Binded Servant
]=]
function Collector:Unbind(Binded):nil
    Binded:Destroy();
end

function Collector:_Render(App)
    local MainServant = App.new("Servant");
    self._dev.MainServant = MainServant;
    self._dev.Servants = {};
    return {};
end;

return CustomClassService:Create(Collector);