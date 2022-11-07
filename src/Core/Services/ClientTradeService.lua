local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);


local ClientTradeService = {}
ClientTradeService.TradeStarted = SignalProvider.new("TradeStarted");
ClientTradeService.TradeEnded = SignalProvider.new("TradeEnded");

--[=[
    @prop TradeStarted PHeSignal
    @within TradeService
    @client
    
    Only trades pertaining the client will be caught.
]=]
--[=[
    @prop TradeEnded PHeSignal
    @within TradeService
    @client

    Only trades pertaining the client will be caught.
]=]

return ClientTradeService
