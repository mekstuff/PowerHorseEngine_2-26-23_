local module = {}

function module:RigCharacter(Character)
	local pr = Character.PrimaryPart or Character:GetChildren()[1];
	if(pr:FindFirstChild("CharacterRig%Ragdoll%identifier"))then print("Character already rigged") return;end;

	local RigIdentifier = Instance.new("Attachment", pr);
	RigIdentifier.Name = "CharacterRig%Ragdoll%identifier";
	
	--Character.Head.CanCollide = true;
	--Character.Humanoid.PlatformStand = true;
	--Character.Humanoid.Sit = true;
	
	for i,v in pairs(Character:GetDescendants()) do
		if v:IsA("Motor6D") and v.Parent.Name ~= "HumanoidRootPart" then
			local Socket = Instance.new("BallSocketConstraint")
			local a1 = Instance.new("Attachment")
			local a2 = Instance.new("Attachment")
			a1.Parent = v.Part0
			a2.Parent = v.Part1
			Socket.Parent = v.Parent
			Socket.Attachment0 = a1
			Socket.Attachment1 = a2
			a1.CFrame = v.C0
			a2.CFrame = v.C1
			Socket.LimitsEnabled = true
			Socket.TwistLimitsEnabled = true
			Socket.MaxFrictionTorque = 15;
			v.Enabled = false;
		end
	end;
	Character.HumanoidRootPart.CanCollide = false;
	Character.Head.CanCollide = true;
	
	Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, false);
	--wait(.1);
	Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	--workspace.e.RemoteEvent:FireAllClients();
	--print(Character.HumanoidRootPart.CanCollide);
	
	
		--Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics);

	--Character.Humanoid.RequiresNeck = false
	--Character.Humanoid.Sit = true
	

end

return module
