local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local DoorRig = {
	__PseudoBlocked = true;
	Name = "DoorRig";
	ClassName = "DoorRig";
	ActivationKey = Enumeration.KeyCode.E;
	ActivationType = Enumeration.DoorActivationType.Prompt;
	ActivationDistance = 30;
	ActivationCoolDown = .5;
	Locked = false;
	Activated = false;
	Disabled = false;
	Team = "";
	CloseAutomatically = true;
	AnimationSpeed = .4;
	RequiresDirectInteraction = false;
};

function DoorRig:_InitDoorRig()

	print("Initiating A Door Rig...");
	local App = self:_GetAppModule();
	
	--//Server Script 
	if(not IsClient)then	
		local ProximityPrompt = App.new("ProximityPrompt",self.Parent);
		ProximityPrompt.ActionText = "";
		local ActivationCoolDown = false;

		ProximityPrompt.TriggerEnded:Connect(function(Player)
			if(ActivationCoolDown)then return end;
			if(self.Locked)then
				ActivationCoolDown = true;
				local rev = ProximityPrompt.ActionText;
				ProximityPrompt.ActionText = "This door is locked.";
				wait(1);
				ProximityPrompt.ActionText = rev;
				ActivationCoolDown = false;
				return;
			end;
			ActivationCoolDown = true;
			--self._PlayerWhoActivated = Player;
			self.Activated = not self.Activated;

			wait(self.ActivationCoolDown);
			ActivationCoolDown = false;
		end);
		
		
		self:GetPropertyChangedSignal("Parent"):Connect(function()
			local Value = self.Parent;
			--determineIsHingedDoor(Value);
			local QuickWeldService = App:GetService("QuickWeldService");
			QuickWeldService:WeldAll(Value, Value.PrimaryPart);
			QuickWeldService:UnAnchorAll(Value, {"Hinge"});

			ProximityPrompt.Parent = Value;
		end)
		
		self:GetPropertyChangedSignal("ActivationKey"):Connect(function()
			local Value = self.ActivationKey;
			ProximityPrompt.KeyCode = Value;
		end);
		self:GetPropertyChangedSignal("ActivationDistance"):Connect(function()
			local Value = self.ActivationDistance;
			ProximityPrompt.MaxActivationDistance = Value;
		end);
		self:GetPropertyChangedSignal("Disabled"):Connect(function()
			local Value = self.Disabled;
			ProximityPrompt.Hidden = Value;
		end)
		self:GetPropertyChangedSignal("RequiresDirectInteraction"):Connect(function()
			local Value = self.RequiresDirectInteraction;
			ProximityPrompt.RequiresDirectInteraction = Value;
		end)
		
	end;
end


return DoorRig
