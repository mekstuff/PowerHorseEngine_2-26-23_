local ContextActionService = game:GetService("ContextActionService");
--[=[
    @class Contextor
    @tag Library

    Currently only a proxy class for [ContextActionService](https://create.roblox.com/docs/reference/engine/classes/ContextActionService), anything available in context action service is available here.
]=]
local Contextor = {};

setmetatable(Contextor, {
    __index = ContextActionService;
});

return Contextor;