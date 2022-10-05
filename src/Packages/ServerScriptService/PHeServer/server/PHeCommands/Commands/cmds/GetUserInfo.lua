--local consts = require(script.Parent.Parent.Constants)
local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local BanService = App:GetService("BanService");
local Format = App:GetGlobal("Format");

return {
	cmd = "GetUserInfo";
	desc = "Gets information about the player";
	req = "Admin";
	args = {
		{var="Player",type="user",req=true,desc="",default=nil};
	};
	exe = function(Player)
			return {
				mColor = Color3.fromRGB(255, 210, 210);
				--success = true;
				message = "~~~~~User information\nQuery: '"..Player.Name.."'\nUserId: ("..tostring(Player.UserId)..")".."\n~~~~~";
			};
	end,
}