--[=[
    @class ClientService
    @tag Service
]=]

local ClientService = {};
local CustomClassService = require(script.Parent.Parent.Providers.ServiceProvider):LoadServiceAsync("CustomClassService");
local ClientBackpackService = require(script.ClientBackpackService)

--[=[
    @prop Backpack ClientBackpackService
    @within ClientService
]=]
ClientService.Backpack = CustomClassService:Create(ClientBackpackService)

return ClientService;