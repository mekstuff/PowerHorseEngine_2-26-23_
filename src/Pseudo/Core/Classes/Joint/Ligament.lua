local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
--local QuickWeldService = 

local Ligament = {
	Name = "Ligament";
	ClassName = "Ligament";
	Type = Enumeration.LigamentType.Constraint;
	BindDescendants = true;
	Part0 = "**Instance";
};
Ligament.__inherits = {}
--//
local function clearLigaments(lig)
	for _,v in pairs(lig)do
		v:Destroy();
	end
end
--//

function Ligament:_Render(App)
	local QuickWeldService = App:GetService("QuickWeldService");

	--local Ligaments;
	
	return {
		["*Parent"] = function(Value)
			if(Value)then
				if(self._dev._Ligaments)then
					clearLigaments(self._dev._Ligaments)
				end;
				self._dev._Ligaments = QuickWeldService:WeldAll(Value,self.Part0,not self.BindDescendants);
			end
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return Ligament
