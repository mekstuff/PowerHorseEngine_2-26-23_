local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));

return function(t, object, objectval)
	local GridRespect = Instance.new("Frame");
	GridRespect.Size = UDim2.new(1,0,0,45);
	GridRespect.BackgroundTransparency = 1;

	local ContentLeft = App.new("Frame",GridRespect);
	ContentLeft.Size = UDim2.new(.7,0,1,0);
	ContentLeft.BackgroundTransparency = 1;
	
	local Text = App.new("Text",ContentLeft);
	Text.Text = t or "?";
	Text.TextSize = 16;
	Text.AnchorPoint = Vector2.new(0,.5);
	Text.Position = UDim2.new(0,5,.5,0);
	Text.Size = UDim2.new(1,0,.95,0);
	Text.TextXAlignment = Enum.TextXAlignment.Left;
	Text.BackgroundColor3 = Color3.fromRGB(0);
	Text.BackgroundTransparency = 1;
	
	local ContentRight = App.new("Frame",GridRespect);
	ContentRight.Size = UDim2.new(.35,0,1,0);
	ContentRight.Position = UDim2.new(1);
	ContentRight.AnchorPoint = Vector2.new(1);
	ContentRight.BackgroundTransparency = 1;
	
	if(object)then
		local n = App.new(object,ContentRight);
		n.Position = UDim2.fromScale(.5,.5);
		n.AnchorPoint = Vector2.new(.5,.5);
		if(objectval)then for a,b in pairs(objectval)do n[a]=b;end;end;
		object = n;
	end
	
	return GridRespect, ContentRight, object;
	
end