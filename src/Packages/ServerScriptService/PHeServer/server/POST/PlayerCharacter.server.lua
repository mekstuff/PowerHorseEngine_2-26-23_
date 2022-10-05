local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

local function onCharacterAdded(Character)
	task.wait(.2);-->For effective serialization
	local CharacterRig = PowerHorseEngine.new("CharacterRig",Character);
	--CharacterRig.Name = Character.Name.."'s CharacterRig"
end;

local function onPlayerAdded(Player)
	--onCharacterAdded(Player.Character or Player.CharacterAdded:Wait());
	Player.CharacterAdded:Connect(onCharacterAdded);
end;

-- for _,v in pairs(game.Players:GetPlayers())do onPlayerAdded(v);end;
-- game.Players.PlayerAdded:Connect(onPlayerAdded);
