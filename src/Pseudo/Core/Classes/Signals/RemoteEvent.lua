local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local RemoteEvent = {
	Name = "RemoteEvent";
	ClassName = "RemoteEvent";

};
RemoteEvent.__inherits = {}

function RemoteEvent:FireClient(Client,...)
	if(IsClient)then
		self:_GetAppModule():GetService("ErrorService").tossError(":FireClient() can only be called from the server.")
	end;
	
	
end;

function RemoteEvent:_Render(App)
	
	local rem = Instance.new("RemoteEvent");
	self._dev.remote = rem;
	
	return {
		--["Property"] = function(Value)
			
		--end,
		--_Components = {};
		--_Mapping = {};
	};
end;


return RemoteEvent
