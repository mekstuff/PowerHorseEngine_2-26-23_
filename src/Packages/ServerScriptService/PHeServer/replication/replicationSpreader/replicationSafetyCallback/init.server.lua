--local PHeGui = script.Parent.Parent.PHeGui;
local PHeGui = game:GetService("ReplicatedFirst"):WaitForChild("PHe_POST"):WaitForChild("PHeGui",60);
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local NotificationService = PowerHorseEngine:GetService("NotificationService");
local cb = require(script.callBack)
local PlayersExecuted = {};

local callback = PowerHorseEngine:GetGlobal("Engine"):FetchStorageEvent("replicationSafetyCallback").OnServerEvent:Connect(function(Player)
	cb(Player);
end);