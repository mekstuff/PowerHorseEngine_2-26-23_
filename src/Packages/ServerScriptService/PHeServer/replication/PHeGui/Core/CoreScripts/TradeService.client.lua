local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");
local TradeCommunicator = Engine:FetchStorageEvent("TradeCommunicator");
local TradeService = PowerHorseEngine:GetService("TradeService");
local CustomClassService = PowerHorseEngine:GetService("CustomClassService");

local ActiveTrade = {
	Name = "ActiveClientTrade";
	ClassName = "ActiveTrade";	
	Sender = "**Instance";
	Reciever = "**Instance";
	--TradeChannel = "**Instance";
	IAmSender = false;
	TradeId = "";
	Target = "**Instance";
};

--[=[
	@prop Target Instance
	@client
	@within ActiveTrade
	Refers to the target of the trade, client 1 target will be client 2 whereas client 2's target will be client 1.
]=]

function ActiveTrade:_Render()
	return{};
end;
--[=[
	@client
]=]
function ActiveTrade:AddContent(Content:any,ContentId:string)
	self._TradeChannel:FireServer("add-content",Content,ContentId)
end;
--[=[
	@client
]=]
function ActiveTrade:RemoveContent(ContentId:string)
	self._TradeChannel:FireServer("remove-content",ContentId)
end;
--[=[
	@client
]=]
function ActiveTrade:SendChannelMessage(...:any)
	self._TradeChannel:FireServer("channel-message",...);
end;
--[=[
	@client
	@private
]=]
function ActiveTrade:___destroy(...:any)
	self:GetEventListener("Ended"):Fire(...);
	self:GetRef():Destroy();
end;

function ActiveTrade:Destroy()
	self:_GetAppModule():GetService("ErrorService").tossWarn(self.ClassName.."'s cannot be destroyed locally. Only the server can end a trade");
end

TradeCommunicator.OnClientEvent:Connect(function(state,...)
	local args = {...};
	if(state == "new-trade")then
		local TradeInfo = args[1];
		local Trade = CustomClassService:CreateClassAsync(ActiveTrade);
		Trade.Reciever = TradeInfo.Reciever;
		Trade.Sender = TradeInfo.Sender;
		Trade.IAmSender = TradeInfo._IAMSENDER;
		Trade.Target = Trade.IAmSender and TradeInfo.Reciever or TradeInfo.Sender;
		Trade.TradeId = TradeInfo.TradeId;
		Trade._TradeChannel = TradeInfo.TradeChannel;
		--[=[
			@prop ContentAdded PHeSignal
			@within ActiveTrade
			@client
		]=]
		local caE = Trade:AddEventListener("ContentAdded",true);
		--[=[
			@prop ContentRemoved PHeSignal
			@within ActiveTrade
			@client
		]=]
		local crE = Trade:AddEventListener("ContentRemoved",true);
		--[=[
			@prop Ended PHeSignal
			@within ActiveTrade
			@client
		]=]
		Trade:AddEventListener("Ended",true);
		
		Trade._TradeChannel.OnClientEvent:Connect(function(ChannelState,...)
			local ChannelArgs = {...};
			if(ChannelState == "add-content")then
				local PlayerToAddContentTo = ChannelArgs[1];
				local Content = ChannelArgs[2];
				local ContentId = ChannelArgs[3];
				caE:Fire(PlayerToAddContentTo,Content,ContentId);
			elseif(ChannelState == "remove-content")then
				local PlayerToAddContentTo = ChannelArgs[1];
				local ContentId = ChannelArgs[2];
				crE:Fire(PlayerToAddContentTo,ContentId);
			elseif(ChannelState == "end-trade")then
				Trade:___destroy(...);
			end
		end)
		
		TradeService.TradeStarted:Fire(Trade);
		Trade.Ended:Connect(function(...)
			TradeService.TradeEnded:Fire(Trade,...);
		end);
	end;
end);

--PowerHorseEngine:GetService("TradeService");