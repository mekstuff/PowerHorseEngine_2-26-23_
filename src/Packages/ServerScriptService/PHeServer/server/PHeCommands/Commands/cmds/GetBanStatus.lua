--local consts = require(script.Parent.Parent.Constants)
local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local BanService = App:GetService("BanService");
local Format = App:GetGlobal("Format");

return {
	cmd = "GetBanStatus";
	desc = "Gets ban information about the player";
	req = "Admin";
	args = {
		{var="Player",type="user",req=true,desc="",default=nil};
	};
	exe = function(Player)
		local Banned,BanData = BanService:GetUserBannedAsync(Player.UserId);
		if(not Banned)then
			return {
				mColor = Color3.fromRGB(255, 210, 210);
				--success = true;
				message = "~~~~~Ban Status Results\n'"..Player.Name.."' is not currently banned. ("..tostring(Player.UserId)..")".."\n~~~~~";
			}
		else
			
			local Diff = Format(os.time(),BanData.TimeOfBan):toTimeDifference();
			local nt = tostring(Diff.days).." day(s) "..tostring(Diff.hours).." hours(s) "..tostring(Diff.minutes).." minute(s) and "..tostring(Diff.seconds).." second(s)";
			return {
				mColor = Color3.fromRGB(255, 210, 210);
				message = '~~~~~Ban Status Results\nQuery: '..Player.Name..'\nUserId: '..tostring(Player.UserId)..'\nDays: '..tostring(BanData.Days)..'\nReason: '..BanData.Reason..'\nModerator: '..BanData.Moderator..'\nModerator Note: '..BanData.ModerationNote..'\nTime left: '..nt.."\n~~~~~";
			}
		end
	end,
}