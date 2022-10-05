--local consts = require(script.Parent.Parent.Constants)
local BanService = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine")):GetService("BanService");

return {
	cmd = "Ban";
	desc = "Temporarily bans the player";
	req = "Admin";
	args = {
		{var="Player",type="user",req=true,desc="Player to be banned",default=nil};
		{var="Time",type="number",req=false,desc="How long the ban will last (in days)",default=1};
		{var="Reason",type="string",req=false,desc="Reason for banning the player",default="Not sure..."};
		{var="Moderation Note",type="string",req=false,desc="More information...",default=nil};
		{var="Announce",type="boolean",req=false,desc="Announce to the server that the player was banned",default=false};
	};
	exe = function(Player,Time,Reason,ModerationNote,Announce)
		BanService:BanUserAsync(Player.UserId,Time,Reason,nil,ModerationNote,Announce)
		return {
			message = Player.Name.." was banned.";
		};
	end,
}