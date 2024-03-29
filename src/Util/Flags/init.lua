--[=[
    @class Flags

    To use add flags, in your Config module add ["-flags"] = {
        ...
    }

    List of flags:

    `force-env {game|plugin|misc} -- force the environment that PowerHorseEngine will be built`
    `pseudo-replication {true|false} -- will pseudo's created on the server be replicated to the client? (default true) CustomClasses need to call :Replicate to replicate."
    `["thirdparty-topbarplus"] = path  -- The path to TopbarPlus Icon inside the datamodel, e.g "ReplicatedStorage.Icon"|"ReplicatedStorage.Modules.Icon"`

]=]

local Flags = {
    _flags = {
        ["force-env"] = nil;
        ["thirdparty-topbarplus"] = nil;
        ["pseudo-replication"] = true;
    };
};

--[=[]=]
function Flags:Init()
    local Engine = require(script.Parent.Parent.Engine);
    local PluginService = require(script.Parent.Parent.Core.Providers.ServiceProvider):LoadServiceAsync("PluginService");

    if(PluginService:IsPluginMode())then
        return;
    end
    local Config = Engine:RequestConfig(true);
    if(not Config)then
        return;
    end;
    local flags = Config["-flags"] or Config["-lanzo"] or {};
    for targetname:string?,flag in pairs(flags) do
        if(targetname)then
            self._flags[targetname] = flag;
        else
            local flagname,flagvalue = flag:match("(.*){(.*)}");
            flagname = flagname:gsub(" ",""):gsub("_","-");
            self._flags[flagname] = flagvalue;
        end;
    end
end;

--[=[]=]
function Flags:GetFlag(FlagName:string):any
    return Flags._flags[FlagName];
end;

--[=[]=]
function Flags:SetFlag(FlagName:string,Value:string,Notice:boolean):nil
    if Notice then 
        if self._flags[FlagName] then
            warn(("Flag already exists %s, but will override previous value"):format(FlagName));
        end;
    end;
    self._flags[FlagName] = Value;
end

return Flags;