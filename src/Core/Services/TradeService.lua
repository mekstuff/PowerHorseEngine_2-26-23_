
--[=[
	@interface TradeConstructorResults
	@within TradeService
	.success boolean -- whether the trade was accepted or declined/failed
	.response string? -- response from the trade. accepted,declined,failed
	.error string? -- if declined or failed, reason will be shown here

]=]

if(game.Players.LocalPlayer)then
	return require(script.Parent.ClientTradeService);
end;

local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);
--[=[
	@class TradeService
	@tag Service
]=]
local TradeService = {}
--[=[
	@prop TradeRequest PHeSignal
	@server
	@within TradeService
]=]
TradeService.TradeRequest = SignalProvider.new("TradeRequest");
--[=[
	@prop TradeStarted PHeSignal
	@server
	@within TradeService
	On the server, every trade started will be caught but on the client, only trades pertaining that client will be caught.

	Argument 1: [ActiveTrade]
]=]
TradeService.TradeStarted = SignalProvider.new("TradeStarted");
--[=[
	@prop TradeEnded PHeSignal
	@server
	@within TradeService
	On the server, every trade ended will be caught but on the client, only trades pertaining that client will be caught.

	Argument 1: [ActiveTrade]
]=]
TradeService.TradeEnded = SignalProvider.new("TradeEnded");

local PromptService = require(script.Parent.PromptService);
local CustomClassService = require(script.Parent.CustomClassService);
local Engine = require(script.Parent.Parent.Parent.Engine);
local TradeCommunicator = Engine:FetchStorageEvent("TradeCommunicator");


local Trades = {};

--[=[
	@class ActiveTrade
]=]
local ActiveTrade = {
	Name = "ActiveTrade";
	ClassName = "ActiveTrade";
	Sender = "**Instance";
	Reciever = "**Instance";
	TradeId = "0";	
	MaximumContent = 15;
};

--[=[
	@prop Sender Player
	@within ActiveTrade
]=]
--[=[
	@prop Reciever Player
	@within ActiveTrade
]=]
--[=[
	@prop TradeId string
	@within ActiveTrade
]=]
--[=[
	@prop MaximumContent number --defaults to 15
	@within ActiveTrade
]=]

function ActiveTrade:_Render()
	return {};
end
--//
local function len(x)
	local i=0;
	for _,_ in pairs(x) do
		i+=1;
	end;
	return i;
end
--[=[
	@server
]=]
function ActiveTrade:AddContent(ToUser:Player,Content:any,ContentId:string,IgnoreMaximumLimit:boolean?)
	ContentId = ContentId or tostring(math.random());
	print("Adding Content To ", ToUser);
	local Target = ToUser == self.Sender and "Sender" or "Reciever";
	if(len(self._Content[Target]) > self.MaximumContent and not IgnoreMaximumLimit)then
		return;
	end
	self._Content[Target][ContentId]=Content;
	self:GetEventListener("ContentAdded"):Fire(ToUser,Content);
	self._sendInformationToClients("add-content",ToUser,Content);
	
	return ContentId;
end;
--[=[
	@server
]=]
function ActiveTrade:RemoveContent(fromUser:Player,ContentId:string)
	print("Removing Content To ", fromUser);
	local Target = fromUser == self.Sender and "Sender" or "Reciever";
	self._Content[Target][ContentId]=nil;
	self:GetEventListener("ContentRemoved"):Fire(fromUser,ContentId);
	self._sendInformationToClients("remove-content",fromUser,ContentId);
end;
--[=[
	@server
]=]
function ActiveTrade:GetContents(fromUser:Player)
	if(fromUser)then
		local Target = fromUser == self.Sender and "Sender" or "Reciever";
		return self._Content[Target];
	end
	return self._Content
end;
--//
function ActiveTrade:Destroy(...)
	self:GetEventListener("Ended"):Fire(...);
	self._sendInformationToClients("end-trade",...);
	Trades[self.TradeId] = nil;
	self:GetRef():Destroy();
end;
--[=[
	@server
]=]
function ActiveTrade:End(Reasons:any)
	self:Destroy(Reasons);
end;

local function fetchIsRecSen(a,b)
	if(b.Sender == a or b.Reciever == a)then
		return true;
	end;
	return false;
end
--[=[
	@server
]=]
function TradeService:GetTradeActive(Player1:Player,Player2:Player?):Player|boolean
	for _,v in pairs(Trades) do
		local p1,p2 = fetchIsRecSen(Player1,v),fetchIsRecSen(Player2,v);
		if(p1)then return Player1;end;
		if(p2)then return Player2;end;
	end
	return false;
end

--[=[
	@server
	A handler for sending out trade requests, by default it will use prompt service and prompt the reciever, it will then
	use the reponse from the reciever to either send back "accept" or "decline".

	To add your own TradeRequestOutBound, overwrite the function at the top of your source. You will need to also handle how the client
	precieves this request, by either using remote events or PromptService:PromptUserAsync

	@return PHeSignal
	:::warning
	You must return a [PHeSignal]/[BindableEvent] within your function
	:::
	You don't have to worry about if either players are in an active trade because the constructor handles that for you.
]=]
function TradeService.TradeRequestOutBound(Sender:Player,Reciever:Player,Header:string?,Body:string?,Blurred:boolean?,Button1:string?,Button2:string?)
	Header = Header or "Trade Inbound";
	Body = Body or Sender.Name.." requested to trade with you.";
	return PromptService:PromptUserAsync(Reciever,{Header=Header;Body=Body;Blurred=Blurred}, {
		{Text = Button1 or "Trade", Id="accept"};
		{Text = Button2 or "Decline", Id="decline"};
	}).Response;
end

--[=[
	@return TradeConstructorResults
	@server
]=]
function TradeService.new(Sender:Player,Reciever:Player,Header:string?,Body:string?,Blurred:boolean?,Button1:string?,Button2:string?):table
	local inActiveTradeSearch_Initial = TradeService:GetTradeActive(Sender,Reciever)
	if(inActiveTradeSearch_Initial)then
		local x = {
			success = false;
			response = "failed";
			error = inActiveTradeSearch_Initial.Name.." is already on an active trade channel";
		}
		TradeService.TradeRequest:Fire(Sender,Reciever,x);
		return x;
	end

	local TradeOutBoundResponse = TradeService.TradeRequestOutBound(Sender,Reciever,Header,Body,Blurred,Button1,Button2);

	assert(TradeOutBoundResponse and (typeof(TradeOutBoundResponse) == "table" and TradeOutBoundResponse:IsA("PHeSignal")) or (typeof(TradeOutBoundResponse) == "Instance") and TradeOutBoundResponse:IsA("BindableEvent"), ("PHeSignal or BindableEvent expected from TradeOutBoundResponse, got %s"):format(tostring(TradeOutBoundResponse)));
	
	local ResponseID = TradeOutBoundResponse:Wait();
	local inActiveTradeSearch = TradeService:GetTradeActive(Sender,Reciever)
	if(inActiveTradeSearch)then
		local x = {
			success = false;
			response = "failed";
			error = inActiveTradeSearch.Name.." is already on an active trade channel";
		}
		TradeService.TradeRequest:Fire(Sender,Reciever,x);
		return x;
	end
	
	local Content;
	
	if(ResponseID == "accept")then
		local newTrade = CustomClassService:CreateClassAsync(ActiveTrade);
		newTrade.TradeId = Sender.Name.."-"..Reciever.Name.."(PHeTrade)";
		newTrade.Sender = Sender;
		newTrade.Reciever = Reciever;
		newTrade._Content = {
			["Sender"] = {};
			["Reciever"] = {};
		};
		--[=[
			@prop ContentAdded PHeSignal
			@within ActiveTrade
			@server
		]=]
		newTrade:AddEventListener("ContentAdded",true);
		--[=[
			@prop ContentRemoved PHeSignal
			@within ActiveTrade
			@server
		]=]
		newTrade:AddEventListener("ContentRemoved",true);
		--[=[
			@prop Ended PHeSignal
			@within ActiveTrade
			@server
		]=]
		newTrade:AddEventListener("Ended",true);
		--[=[
			@prop ChannelMessage PHeSignal
			@within ActiveTrade
			@server
		]=]
		local ChannelMessage = newTrade:AddEventListener("ChannelMessage",true)
		
		local TradeChannel = Instance.new("RemoteEvent",workspace);
		TradeChannel.Name = newTrade.TradeId;
		newTrade._channel = TradeChannel;
		
		newTrade._sendInformationToClients = function(...)
			newTrade._channel:FireClient(newTrade.Sender,...);
			--newTrade._channel:FireClient(newTrade.Reciever,...);
		end;
		
		TradeCommunicator:FireClient(Sender,"new-trade",{
			TradeChannel = TradeChannel;
			Sender = Sender;
			Reciever = Reciever;
			TradeId = newTrade.TradeId;
			_IAMSENDER = true;
		});
		--//Send To Reciever
		
		TradeService.TradeStarted:Fire(newTrade);
		newTrade.Ended:Connect(function(...)
			TradeService.TradeEnded:Fire(newTrade,...);
		end);
		TradeChannel.OnServerEvent:Connect(function(Player,State,...)
			local Args = {...};
			if(State == "add-content")then
				local ContentInfo = Args[1];
				local ContentId = Args[2];
				local TradeSearch = Trades[newTrade.TradeId];
				if(TradeService.ValidateContentAdded)then
					TradeService.ValidateContentAdded(TradeSearch,Player,ContentInfo);
				else
					TradeSearch:AddContent(Player,ContentInfo,ContentId);
				end
			elseif(State == "remove-content")then
				local ContentId = Args[1];
				local TradeSearch = Trades[newTrade.TradeId];
				if(TradeService.ValidateContentAdded)then
					TradeService.ValidateContentRemoved(TradeSearch,Player,ContentId);
				else
					TradeSearch:RemoveContent(Player,ContentId);
				end;
			elseif(State == "channel-message")then
				ChannelMessage:Fire(Player,...);
			end;
			
		end)
		Trades[newTrade.TradeId]=newTrade;
		Content = {
			success=true;
			trade = newTrade;
			response = "accepted";
		}
	else
		Content = {
			success=false;
			error = "Reciever declined trade request";
			response = "declined";
		}
	end;
	TradeService.TradeRequest:Fire(Sender,Reciever,Content);
	return Content;
end

return TradeService
