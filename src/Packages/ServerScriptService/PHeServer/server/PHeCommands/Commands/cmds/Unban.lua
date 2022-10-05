--local consts = require(script.Parent.Parent.Constants)
local BanService = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine")):GetService("BanService");

return {
	cmd = "Unban";
	desc = "Unbans the player";
	req = "Admin";
	args = {
		{var="Player",type="user",req=true,desc="Player to be unbanned",default=nil};
	};
	exe = function(Player,Time,Reason,ModerationNote,Announce)
		BanService:UnbanUserAsync(Player.UserId);
		return {
			message = Player.Name.." was unbanned.";
		};
	end,
}