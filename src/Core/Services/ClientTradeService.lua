local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);


local module = {}
module.TradeStarted = SignalProvider.new("TradeStarted");
module.TradeEnded = SignalProvider.new("TradeEnded");


return module
