

if(game.Players.LocalPlayer)then
	return require(script.Parent.ClientTradeService);
end;

local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);
local module = {}
module.TradeRequest = SignalProvider.new("TradeRequest");
module.TradeStarted = SignalProvider.new("TradeStarted");
module.TradeEnded = SignalProvider.new("TradeEnded");
local PromptService = require(script.Parent.PromptService);
local CustomClassService = require(script.Parent.CustomClassService);
local Engine = require(script.Parent.Parent.Parent.Engine);
local TradeCommunicator = Engine:FetchStorageEvent("TradeCommunicator");


local Trades = {};

local TradeClass = {
	Name = "Trade";
	ClassName = "Trade";
	Sender = "**Instance";
	Reciever = "**Instance";
	TradeId = "0";	
	MaximumContent = 15;
};
function TradeClass:_Render()
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
--//
function TradeClass:AddContent(ToUser,Content,ContentId,IgnoreMaximumLimit)
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
--//
function TradeClass:RemoveContent(fromUser,ContentId)
	print("Removing Content To ", fromUser);
	local Target = fromUser == self.Sender and "Sender" or "Reciever";
	self._Content[Target][ContentId]=nil;
	self:GetEventListener("ContentRemoved"):Fire(fromUser,ContentId);
	self._sendInformationToClients("remove-content",fromUser,ContentId);
end;
--//
function TradeClass:GetContents(fromUser)
	if(fromUser)then
		local Target = fromUser == self.Sender and "Sender" or "Reciever";
		return self._Content[Target];
	end
	return self._Content
end;
--//
function TradeClass:Destroy(...)
	self:GetEventListener("Ended"):Fire(...);
	self._sendInformationToClients("end-trade",...);
	Trades[self.TradeId] = nil;
	self:GetRef():Destroy();
end;
--//
function TradeClass:End(Reasons)
	self:Destroy(Reasons);
end;

local function fetchIsRecSen(a,b)
	if(b.Sender == a or b.Reciever == a)then
		return true;
	end;
	return false;
end
--//
function module:GetTradeActive(TradeId,Player2)
	if(not Player2)then
		return true or false;
	end
	local Player1 = TradeId;
	
	for _,v in pairs(Trades) do
		local p1,p2 = fetchIsRecSen(Player1,v),fetchIsRecSen(Player2,v);
		if(p1)then return Player1;end;
		if(p2)then return Player2;end;
	end
	return false;
end
--//
function module.new(Sender,Reciever,Header,Body,Blurred,Button1,Button2)
	
	local inActiveTradeSearch = module:GetTradeActive(Sender,Reciever)
	if(inActiveTradeSearch)then
		local x = {
			success = false;
			response = "failed";
			error = inActiveTradeSearch.Name.." is already on an active trade channel";
		}
		module.TradeRequest:Fire(Sender,Reciever,x);
		return x;
	end
	
	Header = Header or "Trade Inbound";
	Body = Body or Sender.Name.." requested to trade with you.";
	local TradeInboundRequest = PromptService:PromptUserAsync(Reciever,{Header=Header;Body=Body;Blurred=Blurred}, {
		{Text = Button1 or "Trade", Id="accept"};
		{Text = Button2 or "Decline", Id="decline"};
	});
	
	local ResponseID = TradeInboundRequest.Response:Wait();
	
	local inActiveTradeSearch = module:GetTradeActive(Sender,Reciever)
	if(inActiveTradeSearch)then
		local x = {
			success = false;
			response = "failed";
			error = inActiveTradeSearch.Name.." is already on an active trade channel";
		}
		module.TradeRequest:Fire(Sender,Reciever,x);
		return x;
	end
	
	local Content;
	
	
	if(ResponseID == "accept")then
		local newTrade = CustomClassService:CreateClassAsync(TradeClass);
		newTrade.TradeId = Sender.Name.."-"..Reciever.Name.."(PHeTrade)";
		newTrade.Sender = Sender;
		newTrade.Reciever = Reciever;
		newTrade._Content = {
			["Sender"] = {};
			["Reciever"] = {};
		};
		newTrade:AddEventListener("ContentAdded",true);
		newTrade:AddEventListener("ContentRemoved",true);
		newTrade:AddEventListener("Ended",true);
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
		
		module.TradeStarted:Fire(newTrade);
		newTrade.Ended:Connect(function(...)
			module.TradeEnded:Fire(newTrade,...);
		end);
		TradeChannel.OnServerEvent:Connect(function(Player,State,...)
			local Args = {...};
			if(State == "add-content")then
				local ContentInfo = Args[1];
				local ContentId = Args[2];
				local TradeSearch = Trades[newTrade.TradeId];
				if(module.ValidateContentAdded)then
					module.ValidateContentAdded(TradeSearch,Player,ContentInfo);
				else
					TradeSearch:AddContent(Player,ContentInfo,ContentId);
				end
			elseif(State == "remove-content")then
				local ContentId = Args[1];
				local TradeSearch = Trades[newTrade.TradeId];
				if(module.ValidateContentAdded)then
					module.ValidateContentRemoved(TradeSearch,Player,ContentId);
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
	end
	
	module.TradeRequest:Fire(Sender,Reciever,Content);
	return Content;
	
	
end

return module
