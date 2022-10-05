local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

return function(t,p)
	local f = Instance.new("Frame",p)
	f.Size = UDim2.new(1,0,0,35);
	f.BackgroundTransparency = 1;
	local Text = App.new("Text",f);
	Text.Size = UDim2.fromScale(1,1)
	Text.TextXAlignment = Enum.TextXAlignment.Left;
	Text.BackgroundTransparency = 1;
	Text.TextSize = 12;
	Text.Text = t;
	Text.Font = Enum.Font.Gotham;
	return f,Text;
end;