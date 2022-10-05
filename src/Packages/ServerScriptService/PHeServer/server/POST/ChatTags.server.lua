--local ServerScriptService = game:GetService("ServerScriptService");
--local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"));

local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local ChatTagService = PowerHorseEngine:GetService("ChatTagService");
local UserIdService = PowerHorseEngine:GetService("UserIdService");

local UniqueTags = {
	--[[
	["MightTea"] = {
		TagText = "PHe Developer";
		TagColor = Color3.fromRGB(31, 31, 31)
	};
	]]
};

local function giveTags(Plr)
	local s = UniqueTags[Plr.Name] or UniqueTags[Plr.UserId];
	if(s)then
		--giveTags(Player,s);
		ChatTagService:AddChatTag(Plr,s);
	end
	;
end;

for _,v in pairs(game:GetService("Players"):GetPlayers())do
	giveTags(v);
end;
--[[
for uniqueId,tagInfo in pairs(UniqueTags) do
	--local s = game:GetService("Players"):FindFirstChild(uniq)
	--[[
	local Username = UserIdService:getUsername(uniqueId);
	if(Username)then
		local PlayerInGame = game:GetService("Players"):FindFirstChild(Username);
		if(PlayerInGame)then
			giveTags(PlayerInGame,tagInfo);
			break;
		end
	end
	
	--if(game.Players:FindFirstChild())
end;
]]
game.Players.PlayerAdded:Connect(function(Player)
	giveTags(Player)
	--local Username = UserIdService:getUsername(uniqueId); 
end);