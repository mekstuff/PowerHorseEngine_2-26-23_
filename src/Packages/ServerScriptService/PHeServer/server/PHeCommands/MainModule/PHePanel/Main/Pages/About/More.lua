local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local pColor = Color3.fromRGB(85, 170, 255);

return {
	Name = "";
	Icon = "ico-mdi@action/thumb_up_off_alt";
	Func = function()
		local Frame = App.new("Frame");
		
		local Text = App.new("Text",Frame);
		Text.Text = "Thank you for supporting us! Give us a like on the ROBLOX join our group :)\n\nhttps://www.roblox.com/groups/7473132/";
		Text.Size = UDim2.fromScale(1,1) ;
		Text.TextWrapped = true;
		Text.TextSize = 16;
		Text.BackgroundTransparency = 1;
		
		return Frame;
	end,
}