local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Radio = {
	Name = "Radio";
	ClassName = "Radio";
    RadioId = "**any";
    Selected = false;
};
Radio.__inherits = {}


function Radio:_Render(App)

	
	return {
		["Selected"] = function(Value)
		
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return Radio
