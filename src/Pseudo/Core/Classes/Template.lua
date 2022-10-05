
local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Template = {
	Name = "Name";
	ClassName = "ClassName";

};
Template.__inherits = {}


function Template:_Render(App)
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return Template
