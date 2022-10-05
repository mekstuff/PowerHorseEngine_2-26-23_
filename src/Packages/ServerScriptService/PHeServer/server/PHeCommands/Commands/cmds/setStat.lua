local consts = require(script.Parent.Parent.Constants)

return{
	cmd = "setStat";
	desc = "sets the stat of the player";
	req = "Admin";
	args = {
		{var = "Player", type = "player", req=true};
		{var = "Stat", type = "string", req=true};
		{var = "Value", type = "string", req=true};
	};
	exe = function(Player, Stat, Value)
		local leaderstats = Player:FindFirstChild("leaderstats");
		if(not leaderstats)then return {error = "no leaderstats found for player ["..Player.Name.."]"};end;
		local stat = leaderstats:FindFirstChild(Stat)
		if(not stat)then return {error =  stat.." is not a valid statistic for player ["..Player.Name.."]"};end;
		
		
		if(stat:IsA("BoolValue"))then
			stat.Value = Value:lower() == "true" and true or false;
		elseif(stat:IsA("NumberValue") or stat:IsA("IntValue"))then
			stat.Value = tonumber(Value);
		end;
		
		
	end,
};