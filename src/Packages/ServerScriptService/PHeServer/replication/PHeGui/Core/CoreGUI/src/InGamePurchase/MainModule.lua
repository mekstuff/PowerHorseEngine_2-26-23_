local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Enumeration = PowerHorseEngine:GetGlobal("Enumeration");
local InGamePurchaseService = PowerHorseEngine:GetService("InGamePurchaseService");
local Engine = PowerHorseEngine:GetGlobal("Engine");
local InGamePurchaseRemoteEvent = Engine:FetchStorageEvent("InGamePurchaseService");
local CoreGuiService = PowerHorseEngine:GetService("CoreGuiService");
local CanAcceptPrompts = true;
local module = {}

if(game:GetService("RunService"):IsClient())then
	PowerHorseEngine:GetService("CoreGuiService").ShareObject("InGamePurchasePromptModule",module);
end

local function failPurchase(Reason)
	local Prompt = PowerHorseEngine.new("PHePrompt");
	local CloseButton = Prompt:AddButton("Dismiss");
	Prompt.StartPosition = UDim2.fromScale(.5,-.5);
	Prompt.StartAnchorPoint = Vector2.new(.5,1);
	Prompt.Header = "In-Game Purchase Failed";
	Prompt.Blurred = true;
	Prompt.Highlighted = true;
	Prompt.Level = 100;
	Prompt.DestroyOnOverride = true;
	Prompt.Body = Reason or "Your purchase failed because of unknown reasons";
	Prompt.Parent = PowerHorseEngine:GetService("CoreGuiService").GetCoreGuiRepository();
	
	Prompt.ButtonClicked:Connect(function()
		Prompt:Destroy();
	end)
	--CloseButton._dev._AAAA = CloseButton.Button1Down:Connect(function() Prompt:Destroy(); end);
end;

--//
--function module.PromptMess

--//

function module.Prompt(Text,Icon,ProductId,ActionText)
	if(not CanAcceptPrompts)then return end;
	CanAcceptPrompts = false;
	local Prompt = PowerHorseEngine.new("PHePrompt");
	Prompt.StartPosition = UDim2.fromScale(.5,-.5);
	Prompt.StartAnchorPoint = Vector2.new(.5,1);
	Prompt.Header = "In-Game Purchase";
	Prompt.Blurred = true;
	Prompt.Highlighted = true;
	Prompt.Level = 100;
	Prompt.DestroyOnOverride = true;

	local PurchaseButton = Prompt:AddButton(ActionText);
	local CancelButton = Prompt:AddButton("Cancel");


	local Toast = PowerHorseEngine.new("Toast", Prompt);
	Toast.xMax = Prompt.ModalSize.X;
	Toast.BackgroundTransparency = 1;
	Toast.Name = "PromptToast";
	Toast.Header = "";
	Toast.Body = Text;
	Toast.CanvasImage = Icon;
	
	local Stale = false;
	local PurchasedState = Enumeration.ProductPurchaseState.Declined;
	
	local function ProcessReceipt()
		--if(InGamePurchaseService.ProcessReceipt)then
		--	InGamePurchaseService.ProcessReceipt(game:GetService("Players").LocalPlayer,ProductId,PurchasedState)
		--end;
		CanAcceptPrompts = true;
		if(PurchasedState ~= Enumeration.ProductPurchaseState.Declined)then
			InGamePurchaseRemoteEvent:FireServer(ProductId);
		end;
		if(Prompt)then
			Prompt:Destroy();
		end
	end
	
	--
	
	PurchaseButton.MouseButton1Down:Connect(function()
		if(Stale)then return end;
		Stale = true;
		--PurchaseButton.Loading = true;
		--print(ProductId)
		--if(not ProductId)then
		--	failPurchase("No Product ID was provided.");
		--	ProcessReceipt();
		--else
		PurchasedState = Enumeration.ProductPurchaseState.Purchased;
		ProcessReceipt();
		local GameActivityUI = CoreGuiService:WaitFor("GameActivityUI");
		GameActivityUI:SetActive(true);
		--end
	end);
	CancelButton.MouseButton1Down:Connect(function()
		if(Stale)then return end;
		Stale = true;
		--Prompt:Destroy();
		ProcessReceipt();
	end)
	
	Prompt.Parent = PowerHorseEngine:GetService("CoreGuiService").GetCoreGuiRepository();
end;

return module

