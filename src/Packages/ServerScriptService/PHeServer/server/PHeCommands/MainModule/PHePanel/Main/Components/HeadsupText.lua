local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

return function(t,p)
	local HeadsupText = App.new("Text",p);
	HeadsupText.Text = t;
	HeadsupText.Position = UDim2.fromScale(.5,.5);
	HeadsupText.AnchorPoint = Vector2.new(.5,.5)
	HeadsupText.TextSize = 12;
	HeadsupText.TextWrapped = true;
	HeadsupText.Size = UDim2.new(1,-10,1,-10);
	return HeadsupText
end