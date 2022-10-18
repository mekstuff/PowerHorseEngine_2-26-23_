local RobloxTweenService = game:GetService("TweenService");
local CustomClassService = require(script.Parent.CustomClassService);

--[=[
	@class TweenService

	Class Similar To ROBLOX's TweenService
]=]
local TweenService = {};

local ProxyConvert = {
	["number"] = "NumberValue",
	["boolean"] = "BoolValue",
	["string"] = "StringValue",
	["CFrame"] = "CFrameValue",
	["Color3"] = "Color3Value",
	["Vector3"] = "Vector3Value",
	["BrickColor"] = "BrickColorValue",
	-- ["Vector3"] = "Vector3Value",
	-- ["Vector2"] = "Vector2Value",
	-- ["Vector2"] = "Vector2Value",
}

local ProxyConvertUnsupported = {
	["UDim2"] = "Vector3Value",
	["UDim"] = "Vector3Value",
	["Vector2"] = "Vector3Value",
}

--[=[
	@class Tween
]=]
local Tween = {
	Name = "Tween";
	ClassName = "Tween";
};

local ActiveTweens = {};

function Tween:_Render()
	return {};
end;

--[=[]=]
function Tween:Play()
	local others = (ActiveTweens[self._dev.args.instance]);
	if(others)then
		for _,x in pairs(others) do
			if(x ~= self)then
				x:Pause();
				-- print("paused old tween");
			end
		end
	end
	for _,v in pairs(self._dev.args.proxies) do
		v:Play();
	end;
end;

function Tween:Pause()
	for _,v in pairs(self._dev.args.proxies) do
		v:Pause();
	end;
end;

function Tween:Stop()
	for _,v in pairs(self._dev.args.proxies) do
		v:Stop();
	end;
end;

function Tween:Destroy()
	ActiveTweens[self._dev.args.instance]=nil;
	for _,v in pairs(self._dev.args.proxies) do
		v:Destroy();
	end;
	for _,v in pairs(self._dev.args.instances) do
		v:Destroy();
	end;
	self._dev.args = nil;
	self:GetRef():Destroy();
end;


local handleTweenType = {
	["string"] = {
		createDataType = {"StringValue"},
		handler = function(signal, stringValue)
			signal:Fire("Hello world");
		end;
	},
};

--[=[
	If `Instance` IsA `Instance` and not a `Pseudo`, It will call Native TweenService:Create
	@return Tween
]=]
function TweenService:Create(instance:Instance, tweenInfo:TweenInfo, propertyTable:table)

	if(typeof(instance) == "Instance")then
		--//Native support
		return RobloxTweenService:Create(instance,tweenInfo,propertyTable)
	end

	local Proxies = {
		proxy = {}, instances = {}
	};

	local proxyEvents;
	-- local defaultContainer = 0;
	for a,b in pairs(propertyTable) do
		local asProxy = ProxyConvert[typeof(b)];
		local asUnsupportedType;
		if(not asProxy)then
			asUnsupportedType = ProxyConvertUnsupported[typeof(b)];
			-- print(asUnsupportedType);
		end;

		local instanceProxy = Instance.new(asProxy or asUnsupportedType);
		if(not asProxy)then
			instanceProxy.Name = "--prox@"..asUnsupportedType.."="..typeof(b);
			-- b = tostring(b);
		end
		-- instanceProxy.Name = "TweenProxy-"..a;
		-- instanceProxy.Parent = workspace;
		local function useValue(v,toOriginal)
			if(asProxy)then return v;end;
			local proxy = instanceProxy.Name:match("%-%-prox@%w+=(%w+)");

			if(proxy == "Vector2")then
				return toOriginal and Vector2.new(v.x,v.y) or Vector3.new(v.x,v.y);
			elseif(proxy == "UDim")then
				return toOriginal and UDim.new(v.x,v.y) or Vector3.new(v.Scale,v.Offset);
			elseif(proxy == "UDim2")then
				-- return toOriginal and UDim2.new(v.Origin.x,v.Origin.y,v.Origin.z,v.Direction.x) or Ray.new(Vector3.new(v.X.Scale,v.X.Offset,v.Y.Scale),Vector3.new(v.Y.Offset))
			end
		end;
		local proxyTween = RobloxTweenService:Create(instanceProxy,tweenInfo,{
			
			-- print(instanceProxy.Name);
			Value = useValue(b);
		});
	
		instanceProxy.Value = useValue(instance[a]);
		instanceProxy:GetPropertyChangedSignal("Value"):Connect(function()
			instance[a]=useValue(instanceProxy.Value,true)
		end);
		if(not proxyEvents)then proxyEvents=proxyTween;end;
		Proxies.instances[a]=instanceProxy;
		Proxies.proxy[a]=proxyTween;
	end;


	local cc = CustomClassService:Create(Tween,nil,
	{
		proxies = Proxies.proxy,
		instances = Proxies.instances,
		instance = instance;
	});
	
	cc:AddEventListener("Completed",true,proxyEvents.Completed);
	proxyEvents = nil;

	if(ActiveTweens[instance])then
		table.insert(ActiveTweens[instance], cc);
	else
		ActiveTweens[instance]={cc};
	end;

	if(typeof(instance) == "table" and instance.IsA and instance:IsA("Pseudo"))then
		cc._tweenDestroyingConnection = instance:GetPropertyChangedSignal("Destroying"):Connect(function()
			if(cc and cc.Destroy)then cc:Destroy();end;
		end)
	end

	return cc;
end;


return TweenService;