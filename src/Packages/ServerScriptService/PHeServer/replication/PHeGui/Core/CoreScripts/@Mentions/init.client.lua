--//Prompts user with a notification whenever their name is mentioned in chat --> @MightTea Hello!

local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local PingService = PowerHorseEngine:GetService("PingService");
local PingReader = PingService:RequestUserPingAsync();
local Enumeration = PowerHorseEngine:GetGlobal("Enumeration");
local NotificationService = PowerHorseEngine:GetService("NotificationService");
local ChatDataFetcher = require(script.ChatDataFetcher);

local Players = game:GetService("Players");
local LocalPlayer = Players.LocalPlayer;

local function Chat(sender,message)
	if(message:match("@"..LocalPlayer.Name))then
		message = "This should be filtered first";
		local bodyShorten = message:gsub("^@"..LocalPlayer.Name,"");
		bodyShorten = #bodyShorten > 60 and bodyShorten:sub(1,60).."..." or bodyShorten;
		local n,t,a1,a2 = NotificationService:SendNotificationAsync({
			Header = sender.Name.." mentioned you";
			Body = bodyShorten;
			--Body = "This body needs to be filtered first"
			BackgroundColor3 = ChatDataFetcher.GetUsernameColor(sender.Name);
			--BackgroundColor3 = BrickColor.random().Color;
			CloseButtonVisible = true;
			AttachButton = "View";
			AttachButton2 = "Reply";
		});
		local _x = true;
		a1.MouseButton1Down:Connect(function()
			if(_x)then
				a1.Text = "Collapse";
				t.Body = message;
				_x=false;
			else
				a1.Text = "View";
				t.Body = bodyShorten;
				_x=true;
			end
		end);
		
		a2.MouseButton1Down:Connect(function()
			local s,r = pcall(function()
				local tBox = LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar;
				tBox.Text = "@"..sender.Name;
				tBox:CaptureFocus();
			end)if(not s)then warn(r);end;
		end)
	
	end
end

Players.PlayerAdded:Connect(function(Player)
	Player.Chatted:Connect(function(...)
		Chat(Player,...);
	end);
end);
LocalPlayer.Chatted:Connect(function(...)
	Chat(LocalPlayer,...);
end)