local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local UserIdService = App:GetService("UserIdService");
--local ActionMenu;

return function(UserId)
	
	local n = UserIdService.getUsername(UserId);
	
	local GridRespect = Instance.new("Frame");
	GridRespect.Size = UDim2.new(1,0,0,50);
	GridRespect.Name = "RespectGrid";
	
	local Frame = App.new("Frame",GridRespect);
	Frame.Size = UDim2.fromScale(1,1);
	Frame.StrokeTransparency = 1;
	Frame.Name = "PlayerFrame";
	
	local ActionButton = Instance.new("TextButton");
	ActionButton.Text = "";
	ActionButton.Name = "ActionButton";
	ActionButton.Size = UDim2.fromScale(1,1);
	ActionButton.BackgroundTransparency = 1;
	ActionButton.Parent = Frame:GetGUIRef();
	
	local UserImage = App.new("Image",Frame);
	UserImage.AnchorPoint = Vector2.new(0,.5)
	UserImage.Position = UDim2.new(0,5,.5,0);
	UserImage.Size = UDim2.new(0,Frame:GetAbsoluteSize().Y-5,1,-5);
	--UserImage.Roundness = 30;
	UserImage.Image = game:GetService("Players"):GetUserThumbnailAsync(UserId, Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size420x420);
	
	local Username = App.new("Text",Frame);
	Username.Position = UDim2.new(0,UserImage:GetAbsoluteSize().X+UserImage.Position.X.Offset+5,0,2);
	Username.Text = n;
	Username.Size = UDim2.new(.45,0,0,25);
	Username.TextSize = 20;
	Username.TextXAlignment = Enum.TextXAlignment.Left;
	Username.BackgroundTransparency = 1;
	
--[[
	local Rank = App.new("Text",Frame);
	Rank.Position = UDim2.new(0,Username.Position.X.Offset,0,Username.Size.Y.Offset+Username.Position.Y.Offset+2);
	Rank.Text = "Editing";
	Rank.Size = UDim2.new(.45,0,0,18);
	Rank.TextSize = 16;
	Rank.TextXAlignment = Enum.TextXAlignment.Left;
	Rank.BackgroundTransparency = 1;
	]]
	
	local BottomRightContent = App.new("Frame",Frame);
	BottomRightContent.Position = UDim2.new(1,-5,1,-2);
	BottomRightContent.AnchorPoint = Vector2.new(1,1);
	BottomRightContent.Size = UDim2.new(0,60,0,22);
	BottomRightContent.BackgroundTransparency = 1;
	
	local Grid = Instance.new("UIListLayout",BottomRightContent:GetGUIRef())
	Grid.FillDirection = Enum.FillDirection.Horizontal;
	Grid.VerticalAlignment = Enum.VerticalAlignment.Center;
	Grid.HorizontalAlignment = Enum.HorizontalAlignment.Right;
	
	
	local RespectGridA = Instance.new("Frame",BottomRightContent:GetGUIRef());
	RespectGridA.AutomaticSize = Enum.AutomaticSize.XY;
	RespectGridA.Name = "RespectGridA";
	RespectGridA.BackgroundTransparency = 1;
	local DeviceIcon = App.new("Image",RespectGridA);
	DeviceIcon.Size = UDim2.fromOffset(BottomRightContent.Size.Y.Offset,BottomRightContent.Size.Y.Offset);
	DeviceIcon.Image = "ico-laptop";
	DeviceIcon.BackgroundTransparency = 1;
	
	return GridRespect,Frame,ActionButton
	
end;