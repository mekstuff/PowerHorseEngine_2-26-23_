--local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
--local Enumeration = PowerHorseEngine.Enumeration;
--local DatastoreService = PowerHorseEngine:GetService("DataStoreService");

--[[
local DataStoreService = require(script.Parent.DataStoreService);
local BanServiceDataStore = DataStoreService:GetDataStore("PHe_BanService_DataStore");
local UserIdService = require(script.Parent.UserIdService);
local ErrorService = require(script.Parent.ErrorService);
local NotificationService = require(script.Parent.NotificationService);

local module = {}


function module:GetUserBannedAsync(Player)
	local id = UserIdService.getUserId(Player);
	local DataSearch = BanServiceDataStore:GetAsync(id);
	--//We should double check if the ban expired, if it did, remove it and return false
	return DataSearch and true or false, DataSearch;
end;

--//
function module:UnbanUserAsync(Player)
	local id = UserIdService.getUserId(Player);
	if(not id)then
		ErrorService.tossWarn("Failed To Unban User "..tostring(Player).." Because Their UserId Couldn't Be Retrieved");
		return;
	end;
	BanServiceDataStore:RemoveAsync(id);
end;



--//
function module:BanUserAsync(Player,Days,Reason,Moderator,ModerationNote,Announce)
	local id = UserIdService.getUserId(Player);
	if(not id)then
		ErrorService.tossWarn("Failed To Ban User "..tostring(Player).." Because Their UserId Couldn't Be Retrieved");
		return;
	end
	Days = Days or 1;
	Reason = Reason or "unknown reasons";
	Moderator = Moderator or "Unknown Moderator";
	ModerationNote = "No Moderation Note";
	BanServiceDataStore:SetAsync(id,{
		TimeOfBan = os.time(),
		--BanEnds = os.time()+3600*24*Days,
		Reason = Reason,
		Moderator = Moderator,
		ModerationNote = ModerationNote,
		Days = Days;
	}, true);
	--module:BankickPlayer()
	if(Announce)then
		NotificationService:SendNotificationToAllPlayers({
			Body = UserIdService.getUsername(Player).." was banned for "..tostring(Reason);
			CloseButtonVisible = true;
			LifeTime = 7;
		});
	end;
	
end;

return module

]]

return {};