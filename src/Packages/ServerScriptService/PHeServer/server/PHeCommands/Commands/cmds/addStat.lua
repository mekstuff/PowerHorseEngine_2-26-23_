local consts = require(script.Parent.Parent.Constants)

return{
	cmd = "addStat";
	desc = "adds to the existing int or float value";
	req = "Admin";
	args = {
		{var = "Player", type = "player", req=true};
		{var = "Stat", type = "string", req=true};
		{var = "Value Increase", type = "number", req=true};
	};
	exe = function(Player, Stat, ValueIncrease)
		local leaderstats = Player:FindFirstChild("leaderstats");
		if(not leaderstats)then return {error = "no leaderstats found for player ["..Player.Name.."]"};end;
		local stat = leaderstats:FindFirstChild(Stat)
		if(not stat)then return {error =  stat.." is not a valid statistic for player ["..Player.Name.."]"};end;

		if(stat.ClassName == "IntValue" or stat.ClassName == "NumberValue")then
			stat.Value = stat.Value + (ValueIncrease);
		else
			return {
				error = "You can only add stat to int and float values";
			}
		end
		return {
			message = "Incraesed "..Player.Name.."'s "..stat.Name.." by "..tostring(ValueIncrease).."\n"..tostring(stat.Value - (ValueIncrease)).." -> "..tostring(stat.Value);
		}
	end,
};