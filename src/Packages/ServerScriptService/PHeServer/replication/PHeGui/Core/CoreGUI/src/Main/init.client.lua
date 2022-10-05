local RS = game:GetService("ReplicatedStorage");
local PowerHorseEngine = require(RS:WaitForChild("PowerHorseEngine"));
local CoreGuiService = PowerHorseEngine:GetService("CoreGuiService");
local TweenService = game:GetService("TweenService");


local CoreGUIs = script.Parent.Parent.gui;
local Lifetime = 20;


local CoreNotificationGroup = PowerHorseEngine.new("NotificationGroup",CoreGUIs);
CoreNotificationGroup:RenderInPortal();
CoreGuiService.ShareObject("NotificationGroup",CoreNotificationGroup);

-- local CoreNotificationBanner = PowerHorseEngine.new("NotificationBanner",CoreGUIs);
-- CoreNotificationBanner.Visible = false;
-- CoreGuiService.ShareObject("NotificationBanner",CoreNotificationBanner);

local SubtitlePortal = PowerHorseEngine.new("Portal", CoreGUIs)
SubtitlePortal.Name = "SubtitlePortal"
local CoreSubtitle = PowerHorseEngine.new("Subtitle",SubtitlePortal);
CoreGuiService.ShareObject("Subtitle",CoreSubtitle);

script.executable.Disabled=false;

--//
local NotificationService = PowerHorseEngine:GetService("NotificationService");
local _LocalNotifications = {};
local NotificationsShowing = true;
local delayWaiting=false;
--//
local function HideNotifications()
	if(not NotificationsShowing)then return end;
	NotificationsShowing=false;
	for _,v in pairs(_LocalNotifications)do
		v:FadeOut();
	end
end;
--//
local function ShowNotifications(Time)
	--if(NotificationsShowing)then return end;
	
	if(not NotificationsShowing)then
		NotificationsShowing=true;
		for _,v in pairs(_LocalNotifications)do
			v:FadeIn();
		end;
	end;
	if(Time and not delayWaiting)then
		delayWaiting=true;
		delay(Time, function()
			delayWaiting=false;
			HideNotifications();
		end)
	end
end;

--[[
NotificationService.OnNotification:Connect(function(notification)	
	local id = math.random(1,1000);
	ShowNotifications(Lifetime);
	_LocalNotifications[id]=notification;
	notification.Dismissed:Connect(function()
		_LocalNotifications[id]=nil;
	end);
end);
]]

local GUIREF = CoreNotificationGroup:GetGUIRef();
--[[
GUIREF.MouseEnter:Connect(function()	
	ShowNotifications();
end);

GUIREF.MouseLeave:Connect(function()	
	ShowNotifications(Lifetime);
end);
]]
