local App = require(script.Parent.Parent.Parent);
local CustomClassService = App:GetService("CustomClassService");
-- local State = require(script.Parent.State);

--[=[
    @class StateManagerClass
]=]
local StateManagerClass = {
    Name = "StateManager";
    ClassName = "StateManager";
}
function StateManagerClass:_Render(App)
    local Servant = App.new("Servant");

    self._dev.StateManager = Servant;
    return{};
end;

--[=[
    @return (StateLibrary.State,StateLibrary.StateSetterFunc)
]=]
function StateManagerClass:new(...:any)
    local State = self:_GetAppModule():Import("State");
    local x,s = State(...);
    self._dev.StateManager:Keep(x);
    return x,s;
end

--[=[
    @class StateManager
]=]
local StateManager = {};

--[=[
    @return StateManagerClass
]=]
function StateManager.new()
    return CustomClassService:Create(StateManagerClass);

end

return StateManager;