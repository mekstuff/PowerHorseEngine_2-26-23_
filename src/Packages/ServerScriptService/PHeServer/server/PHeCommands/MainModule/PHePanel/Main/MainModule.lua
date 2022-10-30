-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Friday, September 23 2022 @ 08:15:32

local module = {}
local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local CommandService = App:GetService("CommandService");
local NotificationService = App:GetService("NotificationService");
local AlertNotification = App:GetService("AlertNotification");
local Theme = App:GetGlobal("Theme").getCurrentTheme();

local Components = script.Parent.Components;
local CommandOutput = require(Components.CommandOutput);

local wx,tp;

function module.CreateWidget()
	
	if(wx)then return wx;end;
	
	local Widget = App.new("Widget");

	Widget.Name = "PHe Panel";
	Widget.MinimumSize = Vector2.new(550,350);
	Widget.Roundness = UDim.new(0,5);
	Widget.BackgroundTransparency = .05;

	local TabGroup = App.new("TabGroup",Widget);
	TabGroup.Size = UDim2.fromScale(1,1);
	Widget.Enabled = false;
	wx = Widget;

	
	return wx,TabGroup;
	
end;

module.Colors = {
	Primary = Theme.Primary;
	Secondary = Theme.Primary;
	Text = Theme.Text;
	Background = Theme.Background;
	SmoothRed = Color3.fromRGB(255, 41, 41);
	HotPink = Color3.fromRGB(255, 56, 176);
};

module.Themes = {
	{
		name = "Default";
		c = {
			TextColor3 = module.Colors.Text;
			BackgroundColor3 = module.Colors.Background;
			Secondary = module.Colors.Secondary;
			Primary = module.Colors.Primary;
		}
	};
	{
		name = "Light";
		c = {
			TextColor3 = module.Colors.Background;
			BackgroundColor3 = module.Colors.Text;
			Secondary = module.Colors.Secondary;
			Primary = module.Colors.Primary;
		}
	};
	{
		name = "Dark";
		c = {
			TextColor3 = module.Colors.Text;
			BackgroundColor3 = module.Colors.Background;
			Secondary = module.Colors.Secondary;
			Primary = Color3.fromRGB(module.Colors.Background.r+20,module.Colors.Background.g+20,module.Colors.Background.b+20);
		}
	};
	{
		name = "Smooth Red";
		c = {
			TextColor3 = module.Colors.Text;
			BackgroundColor3 = module.Colors.Background;
			Secondary = module.Colors.SmoothRed;
			Primary = module.Colors.SmoothRed;
		}
	};
	{
		name = "Hot Pink";
		c = {
			TextColor3 = module.Colors.Text;
			BackgroundColor3 = module.Colors.Background;
			Secondary = module.Colors.HotPink;
			Primary = module.Colors.HotPink;
		}
	};
	{
		name = "Blinding Lights";
		c = {
			TextColor3 = module.Colors.Text;
			BackgroundColor3 = Color3.fromRGB(module.Colors.Text.r-50,module.Colors.Text.g-50,module.Colors.Text.b-50);
			Secondary = module.Colors.Secondary;
			Primary = Color3.fromRGB(module.Colors.Text.r-20,module.Colors.Text.g-20,module.Colors.Text.b-20);
		}
	};
}



function module.SetTheme(Theme)
	if(tp)then
		local targetTheme;
		for _,x in pairs(module.Themes)do
			if(x.name == Theme)then targetTheme = x.c;break;end;
		end
		if(targetTheme)then
			for a,b in pairs(targetTheme) do
				tp[a]=b;
			end
		end;
		module.Console.log("Changed Panel Theme To: "..Theme, targetTheme.Primary);
	end
end;

--//
module.Console = {}
function module.Console.log(...)
	return CommandOutput(...);
end;

function module.Console.clear()
	for _,v in pairs(module.Console._commandlineoutput:GetGUIRef():GetChildren())do
		if not (v:IsA("UIListLayout")) then
			v:Destroy();
		end
	end
end;

function module.exe(cmd)
	return CommandService:ExecuteCmdFromStr(cmd);
end



return module
