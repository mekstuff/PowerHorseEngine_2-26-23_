local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local pColor = Color3.fromRGB(85, 170, 255);

return {
	Name = "Settings";
	Icon = "ico-mdi@action/settings";
	Func = function(TabGroup)
		local Frame = App.new("Frame");
		return Frame;
	end,
}