local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");

local PingService_RequestUserPing_Event = Engine:FetchStorageEvent("PingService_RequestUserPing_Event","RemoteFunctions");
local PingService = PowerHorseEngine:GetService("PingService");

PingService_RequestUserPing_Event.OnServerInvoke = PingService.Invoke;
