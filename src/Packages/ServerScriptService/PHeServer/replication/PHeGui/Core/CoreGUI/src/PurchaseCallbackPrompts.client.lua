local RS = game:GetService("ReplicatedStorage");
local PowerHorseEngine = require(RS:WaitForChild("PowerHorseEngine"));
local CoreGuiService = PowerHorseEngine:GetService("CoreGuiService");

local GuiFolder = script.Parent.Parent.gui;

local MarketPlaceService = game:GetService("MarketplaceService");

MarketPlaceService.PromptPurchaseFinished:Connect(function(plr,assetid,purchased)
	if(CoreGuiService:GetCoreGuiEnabled("PurchaseCallbackPrompts"))then
		local Prompt = PowerHorseEngine.new("Prompt",nil,true);
		local e = purchased and "Completed" or "Failed";
		Prompt.Header = "Purchase "..e
		Prompt.Body = purchased and "Your purchase was successful! Thank you for the support" or "Your purchase couldn't be completed, Rewards wouldn't be recieved.";
		Prompt.Parent = GuiFolder;
		Prompt:AddButton("Okay");
		Prompt.ButtonClicked:Connect(function()
			Prompt:Destroy();
		end)
	end;
end)

