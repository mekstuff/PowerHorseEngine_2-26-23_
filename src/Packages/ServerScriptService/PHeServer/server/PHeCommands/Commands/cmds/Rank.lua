--local consts = require(script.Parent.Parent.Constants)

local MainModule = require(script.Parent.Parent.Parent.MainModule);

return {
	cmd = "Rank";
	desc = "Gives the player the rank for the current session (will lose rank when they rejoin or join a new server)";
	req = "Player";
	--alias = {"rank","giverank","GiveRank"};
	args = {
		{var="Player",type="player",req=true,desc="",default=nil};
		{var="Rank",type="string",req=true,desc="",default=nil};
	};
	exe = function(Player,Rank)
		MainModule.updateUserRank(Player.Name,Rank)
	end,
}