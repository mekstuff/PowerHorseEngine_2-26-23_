local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Enumeration = PowerHorseEngine:GetGlobal("Enumeration");
local Engine = PowerHorseEngine:GetGlobal("Engine");
local InGamePurchaseRemoteEvent = Engine:FetchStorageEvent("InGamePurchaseService");
local InGamePurchaseService = PowerHorseEngine:GetService("InGamePurchaseService");


InGamePurchaseRemoteEvent.OnServerEvent:Connect(function(Plr,id,state)
	if(InGamePurchaseService.ProcessReceipt)then
		state = Enumeration.ProductPurchaseState[state];
		local results = InGamePurchaseService.ProcessReceipt(Plr,id,state);
		if(results)then
			if(results.Completed or results.Purchased)then
				InGamePurchaseRemoteEvent:FireClient(Plr, "Purchase-Completed",results.Header,results.Body,results.Icon,results.props);
			else
				InGamePurchaseRemoteEvent:FireClient(Plr, "Purchase-Failed",results.Header,results.Body,results.Icon);
			end
		else
			InGamePurchaseRemoteEvent:FireClient(Plr, "Purchase-Failed", "Purchase Failed", "No information was returned");
		end
	else
		InGamePurchaseRemoteEvent:FireClient(Plr, "Purchase-Failed", "Purchase Failed", "Something went wrong on the server's side, Please try again later.");
	end
end)