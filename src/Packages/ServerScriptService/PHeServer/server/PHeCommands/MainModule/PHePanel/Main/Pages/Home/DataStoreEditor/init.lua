local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local HeadsupText = require(script.Parent.Parent.Parent.Components.HeadsupText);

return {
	Name = "";
	Icon = "ico-mdi@file/cloud";
	Func = function()
		local Frame = App.new("Frame");
			
		return Frame;
	end,
}