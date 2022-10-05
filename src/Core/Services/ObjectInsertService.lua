local module = {}
local RunService = game:GetService("RunService");
local IsRunning = RunService:IsRunning();
local IsStudio = RunService:IsStudio();

local SerializationService = require(script.Parent.SerializationService);

local SettingName = "ObjectInsertService_Objects";

local Objects = {};

local function count(x)
	local i = 0;
	for _,_ in pairs(x)do
		i+=1;
	end;
	return i;
end

function module:UpdatePluginSetting(plugin,settingKey,Key,Value)
	local Before = plugin:GetSetting(settingKey);
	if(not Before)then Before = {};end;
	Before[Key]=Value;
	plugin:SetSetting(settingKey,Before);
	if(count(plugin:GetSetting(settingKey)) <= 0)then
		plugin:SetSetting(SettingName,nil);
	end;
end;

function module:AddObject(Class,Parent)
	
	local plugin = getfenv(0).plugin;
	
	assert(plugin, "AddObject can only be called from plugins");
	assert( IsStudio or IsRunning, "AddObject() cannot create Pseudo's while running or outside studio." );
	
	
	local new = require(script.Parent.Parent.Parent).new(Class,Parent);
	local id = new._dev.__id;
	
	
	module:UpdatePluginSetting(plugin,SettingName,id,new:SerializePropsAsync());
	
	new:GetPropertyChangedSignal():Connect(function(p,v)
		module:UpdatePluginSetting(plugin,SettingName,id,new:SerializePropsAsync());
	end)
	
	
	new._onDestroyed = function()
		--print(plugin:GetSetting(SettingName)[id])
		print("Removing ", id);
		module:UpdatePluginSetting(plugin,SettingName,id,nil)
		--plugin:GetSetting(SettingName)[id]=nil;
		new=nil;
		id=nil;		
	end;
	
	return new;
end;

--//
function module:_GetObjectsToInsert()
	return Objects;
end

return module
