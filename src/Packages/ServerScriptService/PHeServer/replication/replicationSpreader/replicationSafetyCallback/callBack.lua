local PHeGui = game:GetService("ReplicatedFirst"):WaitForChild("PHe_POST"):FindFirstChild("PHeGui") or script.Parent.Parent.Parent.PHeGui;
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Enumeration = PowerHorseEngine:GetGlobal("Enumeration");
local NotificationService = PowerHorseEngine:GetService("NotificationService");
local PromptService = PowerHorseEngine:GetService("PromptService");
local ReplicationService = PowerHorseEngine:GetService("ReplicationService");
local PlayersExecuted = {};

return function(Player)
	if(not PlayersExecuted[Player.UserId])then
		local PGui = Player:WaitForChild("PlayerGui");
		if(PGui:FindFirstChild("PHeGui"))then return end;
		PlayersExecuted[Player.UserId]=true;
		local new = PHeGui:Clone();
		new.Parent = PGui;
		--print("Given late");
		--[[
		NotificationService:SendNotificationAsync(Player, {
			Header = "Delayed PowerHorseEngine Client";
			Body = "Your client recieved the PowerHorse Engine client later than usual, any crucial functions called before this time may have failed to execute. So, if you discover any possible bugs that could've been generated by this delay, Please rejoin the server. (this can happen due to server delay OR studio testing)";
			CloseButtonVisible = true;	
			BackgroundColor3 = Color3.fromRGB(255, 56, 56);
			Priority = Enumeration.NotificationPriority.Critical;
		});
		]]
		--ReplicationService
		wait(15);
		PlayersExecuted[Player.UserId]=nil;
	end;
end