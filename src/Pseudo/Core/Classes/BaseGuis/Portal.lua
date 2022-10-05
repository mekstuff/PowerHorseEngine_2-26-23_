local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Portal = {
	Name = "Portal";
	ClassName = "Portal";
	ZIndex = 1;
	Visible = true;
	IgnoreGuiInset = false;
	ResetOnSpawn = false;
};
Portal.__inherits = {"BaseGui"}


function Portal:_Render(App)
	local PluginService = App:GetService("PluginService");
	-- print(PluginService:IsPluginMode(), "Hello");  
	
	local PortalObject = not PluginService:IsPluginMode() and Instance.new("ScreenGui",self:GetRef()) or nil; 

	local _Mapping = PortalObject and {
		[PortalObject] = {
			"IgnoreGuiInset","ResetOnSpawn";
		}
	} or {}
	return {
		["ZIndex"] = function(Value)
			if(PortalObject)then
				PortalObject.DisplayOrder = Value+300;
			end; 
		end,
		["Visible"] = function(Value)
			if(PortalObject)then
				PortalObject.Enabled=Value;
			end;
		end,

		_Components = {
			FatherComponent = PortalObject or self:GetRef();	
		};
		_Mapping = _Mapping;
	};
end;


return Portal
