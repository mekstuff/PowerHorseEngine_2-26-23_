
--[=[
	@tag Provider
	Provides services
	@class SignalProvider
]=]
local SignalProvider = {};

--[=[
	@class PHeSignal
]=]
local PHeSignal = {};

--[=[
	Fires the bindable event
]=]
function PHeSignal:Fire(...:any)
	self._dev._argData = {...}
	self._dev._bindableEvent:Fire()
	self._dev._argData = nil
end
--[=[
	Destroys self and bindable event
]=]
function PHeSignal:Destroy()
	self._dev._bindableEvent:Destroy();
	setmetatable(self,{});
	self=nil;
end
--[=[
	Connects to the bindable event
]=]
function PHeSignal:Connect(handler:any):RBXScriptConnection
	assert(type(handler) == "function", ("function expected as handler, got %s"):format(typeof(handler)));
	return self._dev._bindableEvent.Event:Connect(function()
		handler(unpack(self._dev._argData, 1, #self._dev._argData));
	end)
end
--[=[
	Yields until the bindable event is fired
	@yields
]=]
function PHeSignal:Wait():any
	self._dev._bindableEvent.Event:Wait()
	return unpack(self._dev._argData, 1, self._dev._argCount)
end
--[=[
	Constructor for creating a new signal

	@return PHeSignal
]=]
function SignalProvider.new(Name:string?)
	local x = {};
	x._dev = {};
	x._dev._bindableEvent = Instance.new("BindableEvent");
	x._dev._argData = nil;
	return setmetatable(x,{
		__index = PHeSignal;	
	});
end;
--[=[]=]
function PHeSignal:IsA(Query:string):boolean
	if(Query == "PHeSignal" or Query == "Pseudo")then
		return true;
	end;
	return false;
end



return SignalProvider;

