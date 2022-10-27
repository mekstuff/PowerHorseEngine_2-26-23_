--[=[
    @class Flags

    List of flags:

    `force-env {game|plugin|misc} -- force the environment that PowerHorseEngine will be built`

]=]

local Flags = {
    _flags = {};
};

--[=[]=]
function Flags:Init()
    local Engine = require(script.Parent.Parent.Engine);
    local PluginService = require(script.Parent.Parent.Core.Providers.ServiceProvider):LoadServiceAsync("PluginService");

    if(PluginService:IsPluginMode())then
        return;
    end
    local Config = Engine:RequestConfig();
    local flags = Config["-flags"] or Config["-lanzo"] or {};

    for _,flag in pairs(flags) do
        local flagname,flagvalue = flag:match("(.*){(.*)}");
        flagname = flagname:gsub(" ",""):gsub("_","-");
        self._flags[flagname] = flagvalue;
    end
end;

--[=[]=]
function Flags:GetFlag(FlagName:string):string
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