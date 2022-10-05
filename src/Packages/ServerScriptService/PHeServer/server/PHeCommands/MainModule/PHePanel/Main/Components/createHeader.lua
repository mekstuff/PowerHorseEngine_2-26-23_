local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

return function(t,p)
	local f = Instance.new("Frame",p);
	f.Size = UDim2.new(1,0,0,35);
	f.BackgroundTransparency = 1;
	local Text = App.new("Text",f);
	Text.Size = UDim2.new(1,-5,1)
	Text.Position = UDim2.new(0,5);
	Text.TextXAlignment = Enum.TextXAlignment.Left;
	Text.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
	Text.TextSize = 14;
	Text.Font = Enum.Font.GothamBold
	Text.Text = t;
	Text.BackgroundTransparency = .3;
	return f,Text;
end;