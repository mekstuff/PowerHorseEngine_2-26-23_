local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");


local Backpack_EquipCall = Engine:FetchStorageEvent("Backpack_EquipCall");

Backpack_EquipCall.OnServerEvent:Connect(function(Player,Tool)
	local Char = Player.Character or Player.CharacterAdded:Wait();
	local Backpack = Player:WaitForChild("Backpack");
	
	for _,v in pairs(Char:GetChildren()) do
		if(v == Tool)then
			return;
		end
	end;
	Char:WaitForChild("Humanoid"):UnequipTools();
	Char:WaitForChild("Humanoid"):EquipTool(Tool);
--[[
	local x;
	for _,v in pairs(Backpack:GetChildren()) do
		if(v == Tool)then
			x=true;
			v.Parent = Char;break
		end
	end;
	if(x)then return end;
	for _,v in pairs(Char:GetChildren()) do
		if(v == Tool)then
			v.Parent = Backpack;break
		end
	end
]]
end)