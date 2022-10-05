local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));


local function getParent()
	local f = _G.cmdLineOUTPUT_PHE_Client;
	if(not f)then
		wait(.1)
		return getParent()
	end;
	return f:GetGUIRef();
end;

local c = {
	["warn"] = Color3.fromRGB(255, 229, 76);
	["error"] = Color3.fromRGB(255, 70, 70);
	["message"] = Color3.fromRGB(85, 170, 255);
}

return function(t,tCol,focusOutput)
	local RespectGrid = Instance.new("Frame", getParent());
	RespectGrid.BackgroundTransparency = 1;
	RespectGrid.AutomaticSize = Enum.AutomaticSize.Y;
	RespectGrid.Size = UDim2.new(1);
	
	if(t)then
		local Text = App.new("Text",RespectGrid);
		Text.Size = UDim2.new(1);
		Text.AutomaticSize = Enum.AutomaticSize.Y;
		Text.Text = t;
		Text.TextXAlignment = Enum.TextXAlignment.Left;
		Text.TextWrapped = true;
		if(typeof(tCol) == "string")then tCol = c[tCol];end;
		if(tCol)then
			Text.TextColor3 = tCol;
		end;
	end;
	
	if(focusOutput)then
		local p = getParent();
		local l = p:FindFirstChildWhichIsA("UIListLayout");
		
		p.CanvasPosition = Vector2.new(0,l.AbsoluteContentSize.Y);
		
	end
	
	return RespectGrid;
end