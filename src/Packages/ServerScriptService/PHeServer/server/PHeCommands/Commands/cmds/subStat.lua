local consts = require(script.Parent.Parent.Constants)

return{
	cmd = "subStat";
	desc = "subtracts to the existing int or float value";
	req = "Admin";
	args = {
		{var = "Player", type = "player", req=true};
		{var = "Stat", type = "string", req=true};
		{var = "Value Decrease", type = "number", req=true};
	};
	exe = function(Player, Stat, ValueDecrease)
		local leaderstats = Player:FindFirstChild("leaderstats");
		if(not leaderstats)then return {error = "no leaderstats found for player ["..Player.Name.."]"};end;
		local stat = leaderstats:FindFirstChild(Stat)
		if(not stat)then return {error =  stat.." is not a valid statistic for player ["..Player.Name.."]"};end;

		if(stat.ClassName == "IntValue" or stat.ClassName == "NumberValue")then
			stat.Value = stat.Value - (ValueDecrease);
		else
			return {
				error = "You can only sub stat from int and float values";
			}
		end
		return {
			message = "Decreased "..Player.Name.."'s "..stat.Name.." by "..tostring(ValueDecrease).."\n"..tostring(stat.Value + (ValueDecrease)).." -> "..tostring(stat.Value);
		}
	end,
};