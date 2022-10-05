local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));


return {
	Name = "";
	Icon = "rbxasset://textures/ui/PlayerList/SelectOn@3x.png";
	Func = function()
		local Frame = App.new("Frame");

		return Frame;
	end,
}