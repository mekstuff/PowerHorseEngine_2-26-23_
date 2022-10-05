local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local module = {
	__PseudoBlocked = true;
	Name = "AI";
	ClassName = "AI";
	Target = "**Instance";
	TargetOffset = Vector3.new(0,0,0);
	RelativeOffset = true;
	--FaceTargetDirection = Enumeration.FaceTargetDirection.Relative;
	--AIType = Enumeration.AI.Human;
};

module.__inherits = {}

function module:GetTargetPosition()
	if(not self.Target)then return Vector3.new(0,0,0);end;
	return self.RelativeOffset and self.Target.CFrame:PointToWorldSpace(self.TargetOffset) or self.Target.Position + self.TargetOffset;
end

function module:_Render(App)
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return module
