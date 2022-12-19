--[=[
	@class InGamePurchaseService
	@tag Service
]=]

local InGamePurchaseService = {}

local Globals = script.Parent.Parent.Globals;

local Engine = require(Globals.Engine);
local format = require(Globals.Format); -- require(script.Parent.Parent.Globals.format);
local CoreGuiService = require(script.Parent.CoreGuiService);
local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);
local InGamePurchaseRemoteEvent = Engine:FetchStorageEvent("InGamePurchaseService");
local IsServer = game:GetService("RunService"):IsServer();

if(not IsServer)then
	--[=[
		@prop PurchaseCompleted PHeSignal
		@within InGamePurchaseService
		@client
		@server
		Fired whenever a purchase is completed
	]=]
	InGamePurchaseService.PurchaseCompleted = SignalProvider.new("InGamePurchaseCompleted");
end

local function combineString(strings)
	--local PriceShorten = format(strings.Price)
	local PriceStringed = format(strings.Price):toNumberCommas():concat(" "):End();
	return format(strings.Text):concat(" "):concat(strings.Name):concat(" for "):concat("$"):concat(PriceStringed):concat(strings.Currency):concat("? "):concat(strings.AssuranceText):End();
end

--[=[
	@client
	@server
]=]
function InGamePurchaseService:PromptPurchase(Plr:Player,ProductId:number,Props:{[string]:any}?)

	assert(Plr and game:GetService("Players"):FindFirstChild(Plr.Name), "PromptPurchase() First Argument Must Be A Player Instance");
	
	Props = Props or {};
	Props.Name = Props.Name or "Unknown Product";
	Props.Price = Props.Price or 0;
	Props.Currency = Props.Currency or "";
	--Props.CurrencyIcon = Props.CurrencyIcon or "";
	Props.Text = Props.Text or "Do you really wish to purchase";
	Props.AssuranceText = Props.AssuranceText or "";
	Props.Icon = Props.Icon or "";
	Props.Body = Props.Body or "";
	Props.ActionText = Props.ActionText or "Purchase";

	local PromptText = Props.Body == "" and combineString(Props) or Props.Body;
	
	if(IsServer)then
		InGamePurchaseRemoteEvent:FireClient(Plr,"Prompt",PromptText,Props.Icon,ProductId,Props.ActionText)
	else
		CoreGuiService:GetCoreGui("InGamePurchasePromptModule").Prompt(PromptText,Props.Icon,ProductId,Props.ActionText);
	end
	
end;

return InGamePurchaseService
