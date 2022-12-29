--[=[
    @class ClientService
    @tag Service
]=]

local ClientService = {};
local ServiceProvider = require(script.Parent.Parent.Providers.ServiceProvider)
local CustomClassService = ServiceProvider:LoadServiceAsync("CustomClassService");
local ErrorService = ServiceProvider:LoadServiceAsync("ErrorService");
local IsClient = game:GetService("RunService"):IsClient();

local ClientBackpackService = require(script.ClientBackpackService);

function ClientService:GetClientDeviceType()
    ErrorService.assert(IsClient, "GetClientDeviceType can only be called by the client")
end;

--[=[
    @prop Backpack ClientBackpackService
    @within ClientService
]=]
ClientService.Backpack = CustomClassService:Create(ClientBackpackService)

--[=[
    @prop Device string
    @within ClientService
    @client

    Calls :GetClientDeviceType on init
]=]
if(IsClient)then
    ClientService.Device = ClientService:GetClientDeviceType();
end;

--[=[
    @prop Ping PingReader
    @within ClientService
    @client

    Uses PingService to read ping, only initiated whenever the .Ping is read
]=]
local handlers = {
    ["Ping"] = function()
        return ServiceProvider:LoadServiceAsync("PingService"):RequestUserPingAsync();
    end
}


return setmetatable(ClientService, {
    __index = function(self:{[any]:any},key:string)
        if(handlers[key])then
            handlers[key]();
        end
    end
});