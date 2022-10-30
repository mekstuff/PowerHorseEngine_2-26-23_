-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Friday, September 23 2022 @ 08:15:03

local Player = game.Players.LocalPlayer;

local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
--script.Parent.Parent = Player:WaitForChild("PlayerGui"):WaitForChild("PHeGui"):WaitForChild("Misc");
local Manifest = require(game:GetService("ReplicatedStorage").PowerHorseEngine["Manifest"]);
local UIS = game:GetService("UserInputService");
local MainModule = require(script.MainModule);
local Widget,TabGroup = MainModule.CreateWidget();
local CoreGuiService = App:GetService("CoreGuiService");
pcall(function()CoreGuiService.RemoveObject("PHePanel");end);
CoreGuiService.ShareObject("PHePanel",MainModule)
local WidgetOpen=false;

local Config = App:GetConfig();

Widget.Parent = script.Parent;

local Keybind = "RightControl"

local CommandOutput = require(script.Components.CommandOutput);
_G.cmd_CommandOutput = CommandOutput;

print("Running");

function OpenWidget()
	WidgetOpen=true;
	Widget.Enabled = true;
end;function CloseWidget()
	WidgetOpen=false;
	Widget.Enabled = false;
	
end

UIS.InputBegan:Connect(function(Input)
	if(Input.KeyCode.Name == Keybind)then
		if(WidgetOpen)then CloseWidget();else OpenWidget();end;
	end
end)

local Pages = script.Pages;

local function AddPageChildren(Loop,Group)
	for _,v in pairs(Loop)do
		local page = require(v);
		assert(typeof(page) == "table", ("table Expected from Page, got %s"):format(typeof(page)));
		assert(typeof(page.Func) == "function", ("function expected from Page.Func, got %s"):format(typeof(page.Func)))
		local Tab = page.Func(Group, Widget);
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
	Pages.Home;
	Pages.About;
	Pages.Settings;
  	#Pages.CustomPages:GetChildren() > 0 and Pages.CustomPages or nil; --//Don't display custom pages unless there is
}

require(script.Commands) --> Initiates local commands

AddPageChildren(PagesInOrder, TabGroup)

CommandOutput("~"..Manifest.Name.." version "..Manifest.Upd.Version)

--[[
n,attachbtn = App:GetService("NotificationService"):SendNotification({
	Header = script.Parent.Name.." Available";
	Body = "You are a \""..script.Parent.rank.Value.."\" in this game, Use "..Keybind.." to open/close panel.";
	Pinned = true;
	BackgroundColor3 = Color3.fromRGB(61, 80, 255);
	CloseButtonVisible = true;
	Lifetime = 30;
	AttachButton = "Launch Panel";
	--AttachButton2 = "Close";
	Priority = App:GetGlobal("Enumeration").NotificationPriority.High;
});


attachbtn.MouseButton1Down:Connect(function()
	OpenWidget();
	n:Dismiss();
end)
]]

Widget.OnWindowCloseRequest:Connect(function()
	CloseWidget();
end)

--//
App:GetGlobal("Engine"):FetchStorageEvent("PHe_PanelRemover").OnClientEvent:Connect(function()
	Widget:Destroy();
	script.Parent:Destroy();
end);

--//
MainModule.SetTheme("Default");

--//
Player.Chatted:Connect(function(message,r)
	if(not Config.PHePanel.ExecuteCommandsFromChat)then return end;
	if(not r)then
		local cmd = message:match("^"..Config.PHePanel.ChatPrefixSyntax.."%s?(.+)");
		if(cmd)then
			MainModule.exe(cmd);
		end
	end
end)

