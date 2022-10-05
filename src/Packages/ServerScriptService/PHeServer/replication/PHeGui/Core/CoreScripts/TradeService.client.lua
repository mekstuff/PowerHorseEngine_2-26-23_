local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");
local TradeCommunicator = Engine:FetchStorageEvent("TradeCommunicator");
local TradeService = PowerHorseEngine:GetService("TradeService");
local CustomClassService = PowerHorseEngine:GetService("CustomClassService");

local TradeClass = {
	Name = "Trade";
	ClassName = "ClientTrade";	
	Sender = "**Instance";
	Reciever = "**Instance";
	--TradeChannel = "**Instance";
	IAmSender = false;
	TradeId = "";
	Target = "**Instance";
};

function TradeClass:_Render()
	return{};
end;
--//
function TradeClass:AddContent(Content,ContentId)
	self._TradeChannel:FireServer("add-content",Content,ContentId)
end;
--//
function TradeClass:RemoveContent(ContentId)
	self._TradeChannel:FireServer("remove-content",ContentId)
end;
--//
function TradeClass:SendChannelMessage(...)
	self._TradeChannel:FireServer("channel-message",...);
end;
--//
function TradeClass:___destroy(...)
	self:GetEventListener("Ended"):Fire(...);
	self:GetRef():Destroy();
end;
function TradeClass:Destroy()
	self:_GetAppModule():GetService("ErrorService").tossWarn(self.ClassName.."'s cannot be destroyed locally. Only the server can end a trade");
end


TradeCommunicator.OnClientEvent:Connect(function(state,...)
	local args = {...};
	if(state == "new-trade")then
		local TradeInfo = args[1];
		local Trade = CustomClassService:CreateClassAsync(TradeClass);
		Trade.Reciever = TradeInfo.Reciever;
		Trade.Sender = TradeInfo.Sender;
		Trade.IAmSender = TradeInfo._IAMSENDER;
		Trade.Target = Trade.IAmSender and TradeInfo.Reciever or TradeInfo.Sender;
		Trade.TradeId = TradeInfo.TradeId;
		Trade._TradeChannel = TradeInfo.TradeChannel;
		
		local caE = Trade:AddEventListener("ContentAdded",true);
		local crE = Trade:AddEventListener("ContentRemoved",true);
		
		Trade:AddEventListener("Ended",true);
		
		Trade._TradeChannel.OnClientEvent:Connect(function(ChannelState,...)
			local ChannelArgs = {...};
			if(ChannelState == "add-content")then
				local PlayerToAddContentTo = ChannelArgs[1];
				local Content = ChannelArgs[2];
				caE:Fire(PlayerToAddContentTo,Content);
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