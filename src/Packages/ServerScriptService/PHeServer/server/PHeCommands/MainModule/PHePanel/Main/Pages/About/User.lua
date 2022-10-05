local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Players = game:GetService("Players");
local Player = Players.LocalPlayer;


return {
	Name = "User";
	Icon = "ico-mdi@action/account_circle";
	Func = function()
		local Frame = App.new("Frame");
		
		local ProfileSection = App.new("Frame",Frame);
		ProfileSection.Size = UDim2.new(1,0,0,60);
		ProfileSection.BackgroundTransparency = 1;
		ProfileSection.StrokeTransparency = 1;
		local ProfileImage = App.new("Image",ProfileSection);
		ProfileImage.Image = Players:GetUserThumbnailAsync(Player.UserId,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size420x420);
		ProfileImage.Position = UDim2.new(0,5,0,0);
		ProfileImage.Size = UDim2.fromOffset(ProfileSection:GetAbsoluteSize().Y,ProfileSection:GetAbsoluteSize().Y);
		ProfileImage.BackgroundTransparency = 1;
		local ProfileName = App.new("Text",ProfileSection);
		--ProfileName.Text = "<b>Hello, "..Player.Name.."</b>";
		ProfileName.Text = "Hello, "..Player.Name;
		ProfileName.Font = Enum.Font.GothamBold;
		--ProfileName.RichText = true;
		ProfileName.Size = UDim2.new(1,0,0,ProfileSection:GetAbsoluteSize().Y/2);
		ProfileName.BackgroundTransparency = 1;
		local ProfileRank = App.new("Text",ProfileSection);
		ProfileRank.Text = "Rank "..script.Parent.Parent.Parent.Parent.rank.Value;
		ProfileRank.RichText = true;
		ProfileRank.Font = Enum.Font.Gotham;
		ProfileRank.Size = UDim2.new(1,0,0,ProfileSection:GetAbsoluteSize().Y/2);
		ProfileRank.BackgroundTransparency = 1;
		ProfileRank.Position = UDim2.fromScale(0,1);
		ProfileRank.AnchorPoint = Vector2.new(0,1);
		
		local InfoText = App.new("Text",Frame);
		InfoText.Position = UDim2.new(0,0,.5);
		InfoText.AnchorPoint = Vector2.new(0,.5);
		InfoText.Size = UDim2.new(1,0,0,60);
		InfoText.BackgroundTransparency = 1;
		InfoText.TextScaled = true;
		InfoText.Text = "This game was enhanced using PowerHorseEngine, A free framework that redefines developing on ROBLOX! Want to enhance your own experiences?";
		
		local GetButton = App.new("Button", Frame);
		
		GetButton.Position = UDim2.new(.5,0,1,-5);
		GetButton.Text = "Get For Free";
		GetButton.AnchorPoint = Vector2.new(.5,1)
		
		return Frame;		
	end,
	
}