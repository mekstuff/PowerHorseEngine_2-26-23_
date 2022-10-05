local App = require(script.Parent.Parent.Parent);
local CustomClassService = App:GetService("CustomClassService");
-- local State = require(script.Parent.State);

local StateManagerClass = {
    Name = "StateManager";
    ClassName = "StateManager";
}
function StateManagerClass:_Render(App)
    local Servant = App.new("Servant");

    self._dev.StateManager = Servant;
    return{};
end;

function StateManagerClass:new(...:any)
    local State = self:_GetAppModule():Import("State");
    local x,s = State(...);
    self._dev.StateManager:Keep(x);
    return x,s;
end

local StateManager = {};

function StateManager.new()
    return CustomClassService:Create(StateManagerClass);

end

return StateManager;