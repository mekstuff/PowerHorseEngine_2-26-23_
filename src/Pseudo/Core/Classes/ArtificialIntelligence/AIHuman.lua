local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local module = {
	Name = "AIHuman";
	ClassName = "AIHuman";
	IdleAnimation = "";
	WalkAnimation = "";
	RunAnimation = "";
	JumpAnimation = "";
	Health = 100;
};
module.__inherits = {"AI"}

local function tossWarnParentMessage(Parent,self,ErrorService)
	ErrorService.tossWarn(Parent.Name.." is not a valid AIHuman 'Adornee'. Try pareting "..self.Name.." to a model which contains a humanoid and a humanoidRootPart.");
end

function module:_DetermineIsValidAIHumanModel(Parent)
	local App = self:_GetAppModule();
	local ErrorService = App:GetService("ErrorService");
	if(Parent:IsA("Model"))then
		local RootPart = Parent:FindFirstChild("HumanoidRootPart");
		local Human = Parent:FindFirstChild("Humanoid");
		if(not RootPart)then tossWarnParentMessage(Parent,self,ErrorService);return;end;
		if(not Human)then tossWarnParentMessage(Parent,self,ErrorService);return;end;
	else
			tossWarnParentMessage(Parent,self,ErrorService)
		return;
	end
end;


function module:_Render(App)
	
	
	return {
		["*Parent"] = function(Value)
			if(Value)then
				if(self:_DetermineIsValidAIHumanModel(Value))then
					
				else
					
				end
			end
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return module
