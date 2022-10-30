local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));


return {
	Name = "";
	Icon = "ico-mdi@navigation/more_horiz";
	Func = function()
		local Frame = App.new("Frame");
		return Frame;
	end,
}