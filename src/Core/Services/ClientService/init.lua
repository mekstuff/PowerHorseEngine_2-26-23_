--[=[
    @class ClientService
    @tag Service
]=]

local ClientService = {};
local UIS = game:GetService("UserInputService");
local ServiceProvider = require(script.Parent.Parent.Providers.ServiceProvider);
local LibraryProvider = require(script.Parent.Parent.Providers.LibraryProvider);
local State = LibraryProvider.LoadLibrary("State");
local CustomClassService = ServiceProvider:LoadServiceAsync("CustomClassService");
local ErrorService = ServiceProvider:LoadServiceAsync("ErrorService");
local IsClient = game:GetService("RunService"):IsClient();

local ClientBackpackService = require(script.ClientBackpackService);


--[=[
    @yields
]=]
function ClientService:_DetermineUserDeviceAsync()
    return "pc";
end
--[=[
    @return State
]=]
function ClientService:GetClientDeviceType()
    ErrorService.assert(IsClient, "GetClientDeviceType can only be called by the client")
    if(self._Device)then
        return self._Device;
    end
    local Device,setDevice = State(self:_DetermineUserDeviceAsync());
    self._Device = Device;
    self._setDevice = setDevice;
    return Device;
end;

--[=[]=]
function ClientService:SetClientDeviceType(DeviceType:"pc"|"mobile"|"xbox")
    ErrorService.assert(DeviceType == "pc" or DeviceType == "mobile" or DeviceType == "xbox", ("pc,mobile or xbox expected as DeviceType, got %s"):format(tostring(DeviceType)));
    if(self._setDevice)then
        self._setDevice(DeviceType);
    else
        self:GetClientDeviceType();
        self._setDevice(DeviceType);
    end
end;

--[=[
    @return State
]=]
function ClientService:GetIsGamePadConnected()
    if(self._IsGamePadConnected)then
        return self._IsGamePadConnected;
    end;
    local IsGamePadConnected,setIsGamePadConnected = State(UIS.GamepadEnabled);
    UIS.GamepadConnected:Connect(function()
        setIsGamePadConnected(true);
    end);
    UIS.GamepadDisconnected:Connect(function()
        setIsGamePadConnected(false);
    end);
    self._IsGamePadConnected = IsGamePadConnected;
    return IsGamePadConnected;
end

--[=[
    @prop Backpack ClientBackpackService
    @within ClientService
]=]
ClientService.Backpack = CustomClassService:Create(ClientBackpackService)

--[=[
    @prop Ping PingReader
    @within ClientService
    @client

    Uses PingService to read ping, only initiated whenever the .Ping is read
]=]
--[=[
    @prop Device string
    @within ClientService
    @client

    Calls :GetClientDeviceType
]=]
--[=[
    @prop GamepadConnected string
    @within ClientService
    @client

    Calls :IsGamePadConnected
]=]
local handlers = {
    ["Ping"] = function()
        return ServiceProvider:LoadServiceAsync("PingService"):RequestUserPingAsync();
    end,
    ["Device"] = function()
        return ClientService:GetClientDeviceType();
    end;
    ["GamepadConnected"] = function()
        return ClientService:GetIsGamePadConnected();
    end;
}


return setmetatable(ClientService, {
    __index = function(self:{[any]:any},key:string)
        if(handlers[key])then
            return handlers[key]();
        end
    end
});