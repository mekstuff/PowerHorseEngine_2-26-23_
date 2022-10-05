local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local PHeSignal = {
	Name = "PHeSignal";
	ClassName = "PHeSignal";
	_REPLICATEDTOCLIENTS = false;
};

function PHeSignal:Fire(...)	
	self._dev._argData = {...}
	self._dev._argCount = select("#", ...)
	self._dev._bindableEvent:Fire()
	self._dev._argData = nil
	self._dev._argCount = nil;
end

function PHeSignal:Connect(handler)
	if not (type(handler) == "function") then
		error(("connect(%s)"):format(typeof(handler)), 2)
	end;

	return self._dev._bindableEvent.Event:Connect(function()
		handler(unpack(self._dev._argData, 1, self._dev._argCount))
	end)
end

function PHeSignal:Wait()
	self._dev._bindableEvent.Event:Wait()
	assert(self._dev._argData, "Missing arg data, likely due to :TweenSize/Position corrupting threadrefs.")
	return unpack(self._dev._argData, 1, self._dev._argCount)
end


function PHeSignal:_Render(App)
	self._dev._bindableEvent = Instance.new("BindableEvent");
	self._dev._argData = nil
	self._dev._argCount = nil	
	return {};
end;


return PHeSignal
