`ico` is expected to be a folder that contains modules that link to icons.

## ico-mdi

Some CoreScripts use `ico-mdi` which is Material Design Icons. To implement create a new `ModuleScript` inside your `ico` folder named `mdi` and paste the follow source:

```lua
-- Written by Olanzo James @ Lanzo, Inc.
-- Saturday, September 24 2022 @ 08:50:06
-- Credit to Google Inc and Qweery
-- Core icons uses mdi, removing this from your experience will make some icons not be shown.
-- Cached.

local mdipackage = 11024471495;
local InsertService = game:GetService("InsertService");
local package;
local RunService = game:GetService("RunService");
local IsRunning,IsClient = RunService:IsRunning(),RunService:IsClient();


--> loads from external source to lower Engine's size (only use the package when needed, sorta better
    local s,r = pcall(function()
        if(IsRunning and IsClient)then 
            return nil;
        end;
        return InsertService:LoadAsset(mdipackage):GetChildren()[1];
    end);
    if(not s)then
        warn("mdi FATAL ERROR: ",r);
        return {} --> icons will not load, you will get warnings like: (could not find ico path ico-mdi@communication/list_alt failed @ communication)
    end;
    if(IsRunning)then
        if(IsClient)then
            --> this module should not exist/replicate onto clients. if so then your icons will fail until the proper module is loaded
            script.Parent = nil;
            script:Destroy();
            -- print("Destroyed",script.Parent)
            return "$wait";
        end
        --> In game, we load the actual module, this way it is replicated to clients. A corescript does this for us on start.
        local icons = r.Icons;
        icons.Name = script.Name;
        icons.Parent = script.Parent;
        script:Destroy();
        return require(icons);
    end;
    package = require(r.Icons);
return package;

```