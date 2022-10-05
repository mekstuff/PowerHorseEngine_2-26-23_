-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Friday, September 23 2022 @ 08:15:22

local module = {}

local RS = game:GetService("ReplicatedStorage");
local PHeModule = RS:WaitForChild("PowerHorseEngine");
local PowerHorseEngine = require(PHeModule);
local Engine = PowerHorseEngine:GetGlobal("Engine");
local PHeCMDSConfig = Engine:RequestConfig().PHePanel
-- local NotificationService = PowerHorseEngine:GetService("NotificationService");
local UserIdService = PowerHorseEngine:GetService("UserIdService");
local ErrorService = PowerHorseEngine:GetService("ErrorService");

local _rank = Instance.new("StringValue");
_rank.Name = "rank";
local _rankNum = Instance.new("IntValue");
_rankNum.Name = "rank#"
_rank.Parent = script.PHePanel;
_rankNum.Parent = script.PHePanel;

--//
local RankCache = {};

--//

local function fetchRank(UserId)
	--if(game.CreatorId == UserId)then return ;end;
	for _,v in pairs(PHeCMDSConfig.Ranks)do
		local rankNumber, rankName, rankContents = v[1],v[2],v[3];
		if(table.find(rankContents, UserId))then
			return{
				name = rankName;
				number = rankNumber;
			}
		end
	end;
	local lowestRank = PHeCMDSConfig.Ranks[#PHeCMDSConfig.Ranks];
	return {
		number = lowestRank[1];
		name = lowestRank[2];
	}
end
--//
function module.getRank(rank)
	for _,v in pairs(PHeCMDSConfig.Ranks)do
		if(rank == v[1] or rank == v[2])then
			return  {
				number = v[1],
				name = v[2],
			},v;
		end
	end
end
--//
function module.getUserRank(User)
	local UserId = UserIdService.getUserId(User);
	if(UserId)then
		if(RankCache[UserId])then return RankCache[UserId];end;
		local rank = fetchRank(UserId)	;
		RankCache[UserId] = rank;
		return rank;
	end;
	--return 0;
end;
--//
function module.updateUserRank(User,Rank)
	local Player = game:GetService("Players"):FindFirstChild(User);
	if(not Player)then ErrorService.tossError(User.." is not a valid player");end;
	local UserId = UserIdService.getUserId(User);
	if(UserId)then
		local TargetRank = module.getRank(Rank);
		if(not TargetRank)then 
			ErrorService.tossError(Rank.." is not a valid rank")
		end;
			--module.removeCommands(use)
		--module.removeCommands(Player)
		RankCache[UserId]=TargetRank;
		module.giveCommands(Player,TargetRank);
	end;
end
--//
function module.removeCommands(Player)
	
	local PlayerGui = Player:WaitForChild("PlayerGui");
	local Cmds = PlayerGui:FindFirstChild("PHePanel");
	if(Cmds)then	
		PowerHorseEngine:GetGlobal("Engine"):FetchStorageEvent("PHe_PanelRemover"):FireClient(Player)
	end;
end;
--//
local ClientCommandModule;

module.SecurePages = {
	["DataStoreEditor"] = 3,
	["DataStore"] = 3,
	["DatastoreKey"] = 3,
	["Players"] = 2,
	["AdminSettings"] = 2,
	["ModSettings"] = 1,
	["SecuredPage_Owner"] = 3,
	["SecuredPage_Admin"] = 2,
	["SecuredPage_Mod"] = 1,
}

local SecurePage = script.Sources.SecurePage;

--//
local RankAdminCommandsCache = {};

--//
function module.giveCommands(Player,Rank)
	module.removeCommands(Player);
	local PHeAdminCommands;
	
	if(RankAdminCommandsCache[Rank.name])then
		PHeAdminCommands = RankAdminCommandsCache[Rank.name]:Clone();
	else
		PHeAdminCommands = script.PHePanel:Clone();
		PHeAdminCommands.rank.Value = Rank.name;
		PHeAdminCommands["rank#"].Value = Rank.number;
		for pageName,v in pairs(module.SecurePages) do
			if(v > Rank.number)then
				local FileObject = PHeAdminCommands:FindFirstChild(pageName,true);
				if(FileObject)then
					local SecuredPage = SecurePage:Clone();
					SecuredPage.Name = pageName;
					SecuredPage.Parent = FileObject.Parent;
					FileObject:Destroy();
				end
			end
		end
		RankAdminCommandsCache[Rank.name] = PHeAdminCommands:Clone();
	end	
	-- disabled for now
	PHeAdminCommands.Parent = Player:WaitForChild("PlayerGui");

end;

return module
