local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

--[=[
	@class Transition
]=]
local Transition = {
	__PseudoBlocked = true;
	Name = "Transition";
	ClassName = "Transition";
	Logo = "";
	--ShowIndicator = false;
};
Transition.__inherits = {}

--[=[
	@return Portal
]=]
function Transition:CreateTransitionPortal(parent:Instance)
	local App = self:_GetAppModule();
	local Portal = App.new("Portal");
	Portal.ZIndex = 999;
	Portal.Parent = parent;
	return Portal;
end



function Transition:_Render(App)
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return Transition
