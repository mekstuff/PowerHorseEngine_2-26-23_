local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");
local Enumeration = PowerHorseEngine.Enumeration;
local MainModule = require(script.MainModule);
local InGamePurchaseService = PowerHorseEngine:GetService("InGamePurchaseService");
local InGamePurchaseRemoteEvent = Engine:FetchStorageEvent("InGamePurchaseService");
local CoreGuiService = PowerHorseEngine:GetService("CoreGuiService");
--local GameActivityUI = CoreGuiService:WaitFor("GameActivityUI");

local function PromptMessage(Header,Body,Icon)
	--print(Header,Body,Icon)
	--print("S")
	if(not Header and not Body and not Icon)then return end;
	local Prompt = PowerHorseEngine.new("PHePrompt");
	Prompt.StartPosition = UDim2.fromScale(.5,-.5);
	Prompt.StartAnchorPoint = Vector2.new(.5,1);
	Prompt.Header = Header or "Message";
	Prompt.Blurred = true;
	Prompt.Highlighted = true;
	Prompt.Level = 2;
	Prompt.DestroyOnOverride = true;

	local CloseButton = Prompt:AddButton("Close");


	local Toast = PowerHorseEngine.new("Toast", Prompt);
	Toast.xMax = Prompt.ModalSize.X;
	Toast.BackgroundTransparency = 1;
	Toast.Name = "PromptToast";
	Toast.Header = "";
	Toast.Body = Body or "";
	Toast.CanvasImage = Icon or "";
	
	Prompt.ButtonClicked:Connect(function()
	
		Prompt:Destroy();
	end);
	
	Prompt.Parent = PowerHorseEngine:GetService("CoreGuiService").GetCoreGuiRepository();
end;

InGamePurchaseRemoteEvent.OnClientEvent:Connect(function(State,...)
	if(State == "Prompt")then
		MainModule.Prompt(...);
	elseif(State == "Purchase-Completed")then
		--print("Recieved")
		local x ={...};
		x = x[4];
		InGamePurchaseService.PurchaseCompleted:Fire(x);
		PromptMessage(...);
		
		--GameActivityUI:SetActive(false);
	elseif(State == "Purchase-Failed")then
		PromptMessage(...);
		--GameActivityUI:SetActive(false);
	end;
end)
