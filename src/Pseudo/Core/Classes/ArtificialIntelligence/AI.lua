local AI = {
	__PseudoBlocked = true;
	Name = "AI";
	ClassName = "AI";
	Target = "**Instance";
	TargetOffset = Vector3.new(0,0,0);
	RelativeOffset = true;
	--FaceTargetDirection = Enumeration.FaceTargetDirection.Relative;
	--AIType = Enumeration.AI.Human;
};

AI.__inherits = {}

function AI:GetTargetPosition()
	if(not self.Target)then return Vector3.new(0,0,0);end;
	return self.RelativeOffset and self.Target.CFrame:PointToWorldSpace(self.TargetOffset) or self.Target.Position + self.TargetOffset;
end

function AI:_Render(App)
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return AI
