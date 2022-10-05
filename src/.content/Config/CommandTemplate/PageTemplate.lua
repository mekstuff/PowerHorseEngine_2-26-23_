local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
--//Delete this page template if you do not want to display custom pages. (do not destroy the PHeCmdsPage folder)

return {
	Name = "";
	Icon = "ico-help_outline";
	RankRequired = "Player"; -->What rank is required to view this page? 
	Func = function()
		-->Contents of the page goes inside this frame, YOU MUST RETURN THIS FRAME
		local Frame = App.new("Frame");
			local HeadsupText = App.new("Text",Frame);
			HeadsupText.Text = "This is a demonstration of a custom page! Edit it inside the PHeCmdsPage folder inside the installer config.";
			HeadsupText.Position = UDim2.fromScale(.5,.5);
			HeadsupText.AnchorPoint = Vector2.new(.5,.5)
			HeadsupText.TextSize = 14;
			HeadsupText.TextWrapped = true;
			HeadsupText.Size = UDim2.new(1,-10,1,-10);
		return Frame;
	end,
}