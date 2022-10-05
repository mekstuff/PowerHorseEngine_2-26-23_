
local RInstance = {
	Name = "RInstance";
	ClassName = "RInstance";
    Instance = "";
};

RInstance.__inherits = {}

--[=[
	@class RInstance

	RInstances, short for ROBLOX Instances are proxy Pseudo's for ROBLOX instances.
	You can construct RInstance from the .new constructor

	```lua
	local ProxyPart = PowerHorseEngine.new("RInstance@Part");
	local ProxyParticleEmitter = PowerHorseEngine.new("RInstance@ParticleEmitter");

	ProxyPart.Size = Vector3.new(0);
	```

	Trying to create a nonexisting Instance will throw an error

	```lua
	local MagicWand = PowerHorseEngine.new("RInstance@MagicWand"); --> "Error: RInstance failed to cast to instance : errorreason "
	```
]=]


function RInstance:_Render(App)
	
	local s,r = pcall(function()
		self._InstanceObject = Instance.new(self._dev.args, self:GetRef());
		-- self._InstanceObject.Name = self._dev.args;
		-- self._InstanceObject.Name = self.Name;
		-- self._Components.Instance = self._InstanceObject
		-- print("Appender added", self.Name);
		-- self._Components._Appender = self._InstanceObject;
		-- self._Components.FatherComponent = self._InstanceObject;
		-- self._InstanceObject.Parent = self:GetRef();
	end);
	if(not s)then
		App:GetService("ErrorService").tossError("RInstance failed to cast to instance : "..r);
	end

	return {
		-- ["*Parent"] = function(v)
		-- 	if(self._InstanceObject)then
		-- 		self._InstanceObject.Parent = self.Parent;
		-- 	end
		-- end,
		["*Name"] = function(v)
			if(self._InstanceObject)then
				self._InstanceObject.Name = v;
			end
		end,
		_Components = {
			_Appender = self._InstanceObject;
			Instance = self._InstanceObject;
		}
	};
end;


return RInstance
