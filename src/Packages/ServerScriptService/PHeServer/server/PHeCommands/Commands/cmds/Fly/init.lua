--local consts = require(script.Parent.Parent.Constants)

return {
	cmd = "Fly";
	desc = "";
	req = 0;
	args = {
		{var="Player",type="player",req=true,desc="",default=nil};
	};
	exe = function(Player)
		local PlayerGui = Player:WaitForChild("PlayerGui");
		if(not PlayerGui:FindFirstChild("flySrc_PHe"))then
			local s = script.flySrc_PHe:Clone();
			s.Parent = PlayerGui;
		else
			return {
				message = Player.Name.." already has the fly GUI. use Unfly command to remove";
			}
		end;
	end,
}