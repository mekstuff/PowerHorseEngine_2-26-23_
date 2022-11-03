local App = require(script.Parent.Parent.Parent);
local ErrorService = App:GetService("ErrorService");

--[=[
    @class ReClasser
    @tag Library
]=]

local ReClasser = {};

--[=[
    @param Original Instance | Pseudo
    @param TargetClass string -- $PseudoClass or ROBLOXCLASS
    @param DontDestroy? boolean | function -- if function, it will be treated as the 'runOnBuild' argument
    @param runOnBuild? function -- whenever the item was converted this function will run
    @return Instance | Pseudo
]=]
function ReClasser:ToClass(Original:Instance,TargetClass:string,DontDestroy:boolean?,runOnBuild:any?):Instance
    ErrorService.assert(Original, "[ReClasser] Missing Instance Arg 1")
    ErrorService.assert(TargetClass, "[ReClasser] Missing TargetClass Arg 2");
    if(typeof(DontDestroy) == "function")then
        runOnBuild = DontDestroy;
        DontDestroy = runOnBuild;
    end
    local newObject = App.New (TargetClass) {};
    for _,x in pairs(Original:GetChildren()) do
        x:Clone().Parent = newObject;
    end;
    if(not DontDestroy)then
        Original:Destroy();
    end;
    newObject.Name = Original.Name;
    if(runOnBuild)then
        runOnBuild(newObject);
    end
    return newObject;
end;

return ReClasser;