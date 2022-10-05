local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Transition = {
	__PseudoBlocked = true;
	Name = "Transition";
	ClassName = "Transition";
	Logo = "";
	--ShowIndicator = false;
};
Transition.__inherits = {}

function Transition:CreateTransitionPortal(parent)
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
