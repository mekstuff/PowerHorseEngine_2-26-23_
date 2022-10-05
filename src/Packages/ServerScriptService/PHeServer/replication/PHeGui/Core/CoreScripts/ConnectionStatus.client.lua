local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local PingService = PowerHorseEngine:GetService("PingService");
local PingReader = PingService:RequestUserPingAsync();
local Enumeration = PowerHorseEngine:GetGlobal("Enumeration");
local NotificationService = PowerHorseEngine:GetService("NotificationService");
local Modules = script.Parent.Parent.Parent.Modules;
local PingReaderStatus = require(Modules.PingReaderStatus)

PingReader:GetPropertyChangedSignal("ConnectionStatus"):Connect(function()
	if(PingReader.ConnectionStatus == Enumeration.ConnectionStatus.Awful)then
		local notification,a1 = NotificationService:SendNotificationAsync({
			--CanvasImage = "rbxasset://textures/StudioSharedUI/alert_warning@2x.png";
			Header = "Poor Connection";
			Body = "Your ping exceeded "..Enumeration.ConnectionStatus.Awful.n.." ms, You may experience significant delay of content from the server. Please check your internet connection";
			BackgroundColor3 = Color3.fromRGB(255, 75, 75);
			Priority = Enumeration.NotificationPriority.Medium;
			CloseButtonVisible = true;
			AttachButton = "More Info"
		});
		a1.MouseButton1Down:Connect(function()
			local n = PingReaderStatus();
			a1.Disabled = true;
			notification.Dismissed:Connect(function()
				n:Destroy();
			end)
		end)
		
	end;

end);