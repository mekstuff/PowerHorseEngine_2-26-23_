local module = {};

local App;
local GlobalAppName = "PHePluginService_SyncFile_PluginSync";

function module._IsInitiated()
    return _G[GlobalAppName] and true or false;
end

function module.uninit()
    local App = _G[GlobalAppName];
    if(not App)then return end;
    _G[GlobalAppName]=nil;
    App:GetService("ErrorService").tossMessage("[PluginService] Sync file removed, plugins no longer synced");
    local SyncData = App.PluginSyncData;
    if(SyncData)then
        local Container = SyncData.UIContainer;
        if(Container)then Container:Destroy();end;
        -- local NotificationGroup = SyncData.NotificationGroup;
        -- if(Container)then NotificationGroup:Destroy();end;
    end;
App = nil;
end

function module.init(_,appToken)
    if(_G[GlobalAppName])then warn("Tried to .init while plugins are already synced. use .uninit") return end;
    local App = appToken;
    -- local App = require(game:GetService("ServerStorage"):WaitForChild("PHE_PORT")):RequestPHE(true,"PluginService Sync File");
    local PluginService = appToken:GetService("PluginService");
    PluginService:__ForceSync("ForceSyncKey",appToken,true) 
    local CoreGui = game:GetService("CoreGui");
    if(CoreGui:FindFirstChild("PHe_SyncCore"))then
        CoreGui.PHe_SyncCore:Destroy();
    end
    local UIContainer = Instance.new("ScreenGui",CoreGui);
    UIContainer.Name = "PHe_SyncCore";
    local NotificationGroup = App.new("NotificationGroup",UIContainer);
    NotificationGroup.Name = "Notifications_Synced";

    _G[GlobalAppName] = App;
    _G[GlobalAppName]["PluginSyncData"] = {
        UIContainer = UIContainer;
        NotificationGroup = NotificationGroup;
    };

    local _,btn = NotificationGroup:Notify({
        Body = "Un-inits the .init";
        AttachButton = "un-init";
        Priortiy = App:GetGlobal("Enumeration").NotificationPriority.Critical;
    });
    btn.MouseButton1Down:Connect(function()
        module.uninit();
    end);
    App:GetService("ErrorService").tossMessage("[PluginService] Sync file initiated successfully");
--]]

end;

function module:Notify(...)
    assert(_G[GlobalAppName], "Run .init first");
    _G[GlobalAppName]["PluginSyncData"]["NotificationGroup"]:Notify(...)
end

return module