local PluginService = {};
local ClientIsPluginMode = false;
local currentApp,currentPlugin;

local PluginService_SyncFile = require(script.PluginService_SyncFile);
local PHeAppHandler = require(script.PHeAppHandler);
local SyncFileInitiated = false;

function PluginService:BuildAsPHeApp(pluginApp,toolbar,plugin)
	if(not plugin)then plugin = self:ReadSync().currentPlugin;end;
	assert(pluginApp and plugin,("PluginApp file or plugin is missing when trying to :BuildAsPHeApp. You passed %s as your app and %s as your plugin."):format(tostring(pluginApp),tostring(plugin)))
	if(not toolbar)then
		local CoreGui = game:GetService("CoreGui");
		local sharedBar = CoreGui:FindFirstChild("PowerHorseEngine_SharedStudioToolbar");
			if(not sharedBar)then
				sharedBar = plugin:CreateToolbar("PowerHorseEngine");
				sharedBar.Name = "PowerHorseEngine_SharedStudioToolbar";
				sharedBar.Parent = CoreGui;
			end;
		toolbar = sharedBar;
	end;

	PHeAppHandler.CreatePHeLibraryObject(pluginApp,toolbar,plugin);
	-- if(not toolbar)then
	-- 	local CoreGui = game:GetService("CoreGui");
	-- 	-- local sharedToolbar = 
	-- 	-- local ModulesFolder = PHeAppHandler.getModulesfolder();
	-- 	local SharedToolbarContainer = CoreGui:FindFirstChild("$PHeApp:SharedToolbar");
	-- 	if(not SharedToolbarContainer)then
	-- 		SharedToolbarContainer = Instance.new("ObjectValue");
	-- 		SharedToolbarContainer.Name = "$PHeApp:SharedToolbar";
	-- 		SharedToolbarContainer.Parent = CoreGui;
			
	-- 		local sharedTb = plugin:CreateToolbar("PowerHorseEngine");
	-- 		sharedTb.Parent = SharedToolbarContainer;
	-- 		SharedToolbarContainer.Value = sharedTb;
	-- 		-- print(SharedToolbarContainer.Value.Parent, "Original");
	-- 	end;
	-- 	-- print(SharedToolbarContainer.Value);
	-- 	-- return;
	-- 	-- print(SharedToolbarContainer.Value.Parent);
	-- 	toolbar = SharedToolbarContainer.Value;
	-- end
	-- PHeAppHandler.CreatePHeLibraryObject(pluginApp,toolbar,plugin)
	-- PHeAppHandler
end;

function PluginService:IsPluginMode()
	return ClientIsPluginMode;
end

function PluginService:ReadSync()
	return currentPlugin and {
		app = currentApp;
		currentPlugin = currentPlugin
	} or nil;
end

function PluginService:__ForceSync(key,app,plugin)
    if(key)then
        currentApp = app;
        currentPlugin = plugin;
    end;
end;

local SyncedPluginClass = {
    Name = "SyncedPlugin";
    ClassName = "SyncedPlugin";
};
function SyncedPluginClass:_Render() return {};end;

local function ControlSynced()
    assert(PluginService_SyncFile._IsInitiated(), "Sync file not initiated with .init");
    -- assert(typeof(PluginService_SyncFile) == "table", "Sync file not initiated with .init");
end


function SyncedPluginClass:SendNotification(...)
    ControlSynced();
    PluginService_SyncFile:Notify(...);
end;

function PluginService:GetUserId()
	return game:GetService("StudioService"):GetUserId();
end;


function PluginService:Sync(plugin,appToken)
	-- appToken = require()
--[[
	assert(typeof(plugin)=="Instance" and plugin.ClassName == "Plugin", ("Plugin expected when syncing with PluginService, got %s"):format(typeof(plugin)));
	assert(typeof(appToken)=="table", ("Expected PowerHorseEngine Module Token When Syncing With Plugin Service, Got %s"):format(typeof(appToken)));
	if(not PluginService_SyncFile._IsInitiated())then
        PluginService_SyncFile.init(plugin, appToken);
    end
]]
    currentPlugin = plugin;
    currentApp = appToken;
	ClientIsPluginMode = true;
--[[
    local CustomClassService = appToken:GetService("CustomClassService");
    local SyncedClass = CustomClassService:Create(SyncedPluginClass);

    return SyncedClass;
]]
end;

return PluginService;

--[[
local module = {}
local PluginMode=false;
--local IsRunning = game:GetService("RunService"):IsRunning();
local sharedplugin;
local CustomClassService = require(script.Parent.CustomClassService);

local currentApp,currentPlugin;

local SyncedClass = {
	Name = "PluginServiceSync";
	ClassName = "PluginServiceSync";
	
}

function SyncedClass:Notify(...)
	return self:GET("MainNotificationGroup"):Notify(...);
end

function SyncedClass:_Render()
	local CoreGui = game:GetService("CoreGui");
	local f = (CoreGui:FindFirstChild("PHe-PluginService"));if(f)then f:Destroy();end;
	local UI = Instance.new("ScreenGui",CoreGui);
	UI.Name = "PHe-PluginService"
	
	local App = self:_GetAppModule();
	
	local MainNotificationGroup = App.new("NotificationGroup",UI);
	
	return {
		_Components = {
			MainNotificationGroup = MainNotificationGroup;
		}
	}
end

function module:Sync(plugin,app)
	-- currentApp = app;currentPlugin=plugin;
	-- require(script.Parent.Parent.Parent.Pseudo.Core.Vanilla).Mouse = plugin:GetMouse();
	
	local c = CustomClassService:Create(SyncedClass);
	PluginMode = true;
	--c.Parent = workspace;
	return c;
end;

function module:ReadSync()
	-- return currentPlugin and {
	-- 	app = currentApp;
	-- 	currentPlugin = currentPlugin
	-- } or nil;
end

function module:IsPluginMode()
	return PluginMode
end

function module:Share(plugin)
	if(plugin)then
	
		local App = script.Parent.Parent.Parent;
		local Vanilla_Core = require(App.Pseudo.Core.Vanilla);
		Vanilla_Core.Mouse = plugin:GetMouse();
		PluginMode=true;
		sharedplugin=plugin;
		
		--plugin.Unloading:Connect(function()
		--	print("Losing Connection");
		--end)
		return true
		
	end;
	return false;
end

return module
]]
