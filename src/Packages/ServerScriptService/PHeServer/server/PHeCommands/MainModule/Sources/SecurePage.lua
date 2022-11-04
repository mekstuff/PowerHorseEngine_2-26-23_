local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

return {
	Name = "";
	Icon = "ico-mdi@content/block";
	Func = function()
		local Frame = App.new("Frame");
		local HeadsupImage = App.new("Image",Frame);
		HeadsupImage.Position = UDim2.fromScale(.5,.4);
		HeadsupImage.AnchorPoint = Vector2.new(.5,.5);
		HeadsupImage.Image = "ico-lock_outline";
		HeadsupImage.BackgroundTransparency = 1;
		local HeadsupText = App.new("Text",Frame);
		HeadsupText.Text = "You do not have permission to view this page";
		HeadsupText.Position = UDim2.fromScale(.5,.6);
		HeadsupText.AnchorPoint = Vector2.new(.5,.5)
		--HeadsupText.TextSize = 14;
		HeadsupText.TextWrapped = true;
		HeadsupText.Size = UDim2.new(1,-10,1,-10);
		return Frame;
	end,
}