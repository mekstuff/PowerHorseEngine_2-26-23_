local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local UserIdService = App:GetService("UserIdService");
local Players = game:GetService("Players");

local PlayerEditCache = {};


local function fetchPlayerInfo(UserId)
	local Username = UserIdService.getUsername(UserId);
	local PlayerInstance = game:GetService("Players"):FindFirstChild(Username)
	local PlayerInServer = false;
	if(PlayerInstance)then PlayerInServer=true;end;
	return {
		Username = Username;
		UserId = UserId;
		Player = PlayerInstance;
		PlayerInServer = PlayerInServer;
		Character = PlayerInServer and (PlayerInstance.Character or PlayerInstance.CharacterAdded:Wait());
	}
	
end

return function(UserId)
	if(PlayerEditCache[UserId])then
		
		return PlayerEditCache[UserId];
	end;
	local Widget = App.new("Widget",script.Parent.Parent.content);
	PlayerEditCache[UserId]=Widget;
	
	local pinfo = fetchPlayerInfo(UserId)

	
	local ProfileSection = App.new("Frame",Widget);
	ProfileSection.Size = UDim2.new(1,0,0,50);
	ProfileSection.BackgroundTransparency = 1;
	ProfileSection.StrokeTransparency = 1;
	local ProfileImage = App.new("Image",ProfileSection);
	ProfileImage.Image = Players:GetUserThumbnailAsync(UserId,Enum.ThumbnailType.AvatarBust,Enum.ThumbnailSize.Size420x420);
	ProfileImage.Position = UDim2.new(0,5,0,0);
	ProfileImage.Size = UDim2.fromOffset(ProfileSection:GetAbsoluteSize().Y,ProfileSection:GetAbsoluteSize().Y);
	ProfileImage.BackgroundTransparency = 1;
	local ProfileName = App.new("Text",ProfileSection);
	ProfileName.Text = pinfo.Username;
	ProfileName.Font = Enum.Font.GothamBold;
	ProfileName.Position = UDim2.new(0,ProfileImage.Size.X.Offset+15);
	ProfileName.Size = UDim2.new(1,0,0,ProfileSection:GetAbsoluteSize().Y/2);
	ProfileName.BackgroundTransparency = 1;
	ProfileName.TextXAlignment = Enum.TextXAlignment.Left;
	local ProfileRank = App.new("Text",ProfileSection);
	ProfileRank.Text = "Rank <b>Unknown</b>"
	ProfileRank.RichText = true;
	ProfileRank.Font = Enum.Font.Gotham;
	ProfileRank.Size = UDim2.new(1,0,0,ProfileSection:GetAbsoluteSize().Y/2);
	ProfileRank.BackgroundTransparency = 1;
	ProfileRank.Position = UDim2.new(0,ProfileName.Position.X.Offset,1);
	ProfileRank.TextXAlignment = Enum.TextXAlignment.Left;
	ProfileRank.AnchorPoint = Vector2.new(0,1);
	
	local TabGroup = App.new("TabGroup",Widget)
	TabGroup.Position = UDim2.new(0,0,0,ProfileSection.Size.Y.Offset);
	TabGroup.Size = UDim2.new(1,0,1,-TabGroup.Position.Y.Offset);

	local Pages = script.Pages;
	
	local function AddPageChildren(Loop,Group)
		for _,v in pairs(Loop)do
			local page = require(v);
			assert(typeof(page) == "table", ("table Expected from Page, got %s"):format(typeof(page)));
			assert(typeof(page.Func) == "function", ("function expected from Page.Func, got %s"):format(typeof(page.Func)))
			local Tab = page.Func(Group, pinfo);
			assert(Tab and typeof(Tab) == "table" and Tab:IsA("Frame"), ("Expected Pseudo Frame from Page.Func return got %s"):format(tostring(Tab)));
			Tab.Size = UDim2.fromScale(1,1);
			Tab.BackgroundTransparency = 1;
			Tab.StrokeTransparency = 1;
			Group:AddTab(Tab,page.Name,page.Icon,v.Name);
			if(#v:GetChildren() > 0)then
				local newTabGroup = App.new("TabGroup",Tab);
				newTabGroup.Name = "SubTabGroup";
				newTabGroup.Size = UDim2.fromScale(1,1);
				AddPageChildren(v:GetChildren(), newTabGroup)
			end
		end
	end

	local PagesInOrder = {
		Pages.Statistics;
		Pages.Character;
		Pages.Other;
	}


	AddPageChildren(PagesInOrder, TabGroup)
	
	Widget.OnWindowCloseRequest:Connect(function()
		--//If player is in game, then do not remove them from cache, else remove widget from cache after given time
		Widget.Enabled = false;	
	end)
	return Widget;
end