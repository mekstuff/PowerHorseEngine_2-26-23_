local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));


return {
	Name = "About";
	Icon = "ico-mdi@action/info";
	Func = function()
		local Frame = App.new("Frame");
		return Frame;		
	end,
	
}