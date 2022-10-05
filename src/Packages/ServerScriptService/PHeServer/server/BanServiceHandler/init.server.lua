--[[
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Enumeration = PowerHorseEngine.Enumeration;
local BanService = PowerHorseEngine:GetService("BanService");
local PromptService = PowerHorseEngine:GetService("PromptService");
local SerializationService = PowerHorseEngine:GetService("SerializationService");


local AccountSuspendedScript = script.Accountsuspended;
local function accSuspended(Plr,Data)
	local c = AccountSuspendedScript:Clone();
	c.Parent = Plr:WaitForChild("PlayerGui"):WaitForChild("PHeGui"):WaitForChild("Misc");
	local dataSerialized = SerializationService:SerializeTable(Data);
	local BanData = Instance.new("StringValue");
	BanData.Name = "info.serial";
	BanData.Value = dataSerialized;
	
	--wait(12);
	BanData.Parent = c;
	
end;

--print("Remember Ban Service")

local function PlayerAdded(Plr)
	local Banned, BanData = BanService:GetUserBannedAsync(Plr.UserId);
	if(Banned)then
		accSuspended(Plr,BanData)
	end;
end

for _,v in pairs(game.Players:GetPlayers())do PlayerAdded(v);end;
game:GetService("Players").PlayerAdded:Connect(PlayerAdded);
]]