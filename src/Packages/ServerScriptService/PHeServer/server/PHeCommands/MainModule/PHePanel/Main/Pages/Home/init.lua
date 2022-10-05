local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local pColor = Color3.fromRGB(85, 170, 255);

return {
	Name = "Home";
	Icon = "ico-mdi@places/house";
	Func = function()
		local Frame = App.new("Frame");		
		return Frame;
	end,
}