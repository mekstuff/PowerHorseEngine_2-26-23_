local RS = game:GetService("ReplicatedStorage");
local PowerHorseEngine = require(RS:WaitForChild("PowerHorseEngine"));
local NotificationService = PowerHorseEngine:GetService("NotificationService");
local NotificationBannerService = PowerHorseEngine:GetService("NotificationBannerService");
local Engine = PowerHorseEngine:GetGlobal("Engine");


--//Notifications
Engine:FetchStorageEvent("NotificationService_SendNotificationAsync").OnClientEvent:Connect(function(TempChannel,...)
	local n,attach1,attach2 = NotificationService:HandleNotificationRequest(...);
	local NotificationMethod = "Default";
	
	local t = {...};t = t[1];
	
	TempChannel.OnClientEvent:Connect(function(action)
		if(action == "dismiss")then
			if(n)then
				if(t.NotificationMethod == "Subtitle")then
					n:Destroy();
				else
					n:Dismiss();
				end
				
			end
		end
	end)
	if(t.NotificationMethod == "Subtitle")then
		n:GetPropertyChangedSignal("Destroying"):Connect(function(...)
			TempChannel:FireServer("dismissed",...);
		end)
	else
		n.Dismissed:Connect(function(...)
			TempChannel:FireServer("dismissed",...);
		end)
	end
	
	if(attach1)then
		attach1.MouseButton1Down:Connect(function()
			TempChannel:FireServer("attachbuttondown",attach1.Text);
		end)
	end;
	if(attach2)then
		attach2.MouseButton1Down:Connect(function()
			TempChannel:FireServer("attachbutton2down",attach2.Text);
		end)
	end
	
end);

--//Notification Header
Engine:FetchStorageEvent("NotificationBannerService_Notify").OnClientEvent:Connect(function(...)
	NotificationBannerService:_handleNotify(...);
end);


--local AlertNotification = PowerHorseEngine:GetService("AlertNotification");

--[[
AlertNotification:Alert({
	Icon = "rbxasset://textures/loading/robloxRedTilt.png";
	Lifetime = 12;
	Body = "Experience enhanced with PowerHorse Engine";
	--Color = Color3.fromRGB(255, 73, 73);
});
]]

--[[
local Notification,_,AttachButton = NotificationService:SendNotificationAsync({
	CanvasImage = "rbxasset://textures/ui/Settings/MenuBarIcons/HelpTab.png";
	Header = "PowerHorseEngine";
	Body = "This experience was enhanced with PowerHorseEngine!";
	--AttachButton = "Get Copy";
	--LifeTime = 10;
	CloseButtonVisible = true;
	BackgroundColor3 = Color3.fromRGB(126, 122, 107);
})


Notification:Notify("copy",{
	CanvasImage = "rbxasset://textures/ui/Settings/MenuBarIcons/HelpTab.png";
	Body = "Get a copy of PowerHorseEngine for free and help improve the development of your own games.";
	AttachButton = "Get Copy";
});

local ProgressFrame = PowerHorseEngine.new("Frame");

ProgressFrame.Size = UDim2.new(0,120,0,60);

local Text = PowerHorseEngine.new("Text",ProgressFrame);
Text.Text = "Installing up...";
Text.Size = UDim2.new(1,-40+5,1);
Text.TextTruncate = Enum.TextTruncate.AtEnd;

local Radial = PowerHorseEngine.new("ProgressRadial",ProgressFrame);
Radial.Size = UDim2.fromOffset(40,40);
Radial.Position = UDim2.new(1,-5,.5,0);
Radial:SetYielding(true);



Notification:SendNotification("progress",ProgressFrame)
]]
--local InstallingComponents = 


