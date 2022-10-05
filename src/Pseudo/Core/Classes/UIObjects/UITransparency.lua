local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local UITransparency = {
	Name = "UITransparency";
	ClassName = "UITransparency";
	Transparency = 0;

};
UITransparency.__inherits = {"UIDescendantModule","BaseGui"}


function UITransparency:_Render(App)
	
	
	
	return {
		["*Parent"] = function(Value)
			self:_StoreDescendants(Value:IsA("Instance") and Value or Value:GetRef());
			self:_Listen(Value:IsA("Instance") and Value or Value:GetRef())
		end,
		["Transparency"] = function(Value)
			local desc = (self:_GetDescendants());
			if(desc)then
				for instance,props in pairs(desc)do
					for _,props in pairs(props)do
			
						instance[props] = Value;
						
					end
				end
			end
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return UITransparency
