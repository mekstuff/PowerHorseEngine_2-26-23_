local App = require(script.Parent.Parent.Parent);
local Types = require(script.Parent.Parent.Parent.Types);
local ErrorService = App:GetService("ErrorService");
local CustomClassService = App:GetService("CustomClassService");
local RunService = game:GetService("RunService");
local IsClient = RunService:IsClient();

local FrameworkBrancher = require(script.FrameworkBranch);

local Engine = App:GetGlobal("Engine");
local RSStorage = Engine:FetchReplicatedStorage();

if(not IsClient)then
    local FrameworkSharedContainer = Instance.new("Folder");
    FrameworkSharedContainer.Name = "Framework_Workflow:Shared";
    FrameworkSharedContainer.Parent = Engine:FetchReplicatedStorage();
    local SharedBranches = Instance.new("Folder",FrameworkSharedContainer);
    SharedBranches.Name = "@Branches";
    local FrameworkServerContainer = Instance.new("Folder");
    FrameworkServerContainer.Name = "Framework_Workflow:Server";
    FrameworkServerContainer.Parent = Engine:FetchServerStorage();
    local ServerBranches = Instance.new("Folder",FrameworkServerContainer);
    ServerBranches.Name = "@Branches";
    local SharedServices = Instance.new("Folder");
    SharedServices.Name = "@Shared";
    SharedServices.Parent = FrameworkSharedContainer;
end

--[=[
    @class Framework
]=]

local Framework = {};
local Branches = {};

--[=[]=]
function Framework:GetBranch(BranchName:string,tries:number?):Types.FrameworkBranch?
    if(Branches[BranchName])then
        return Branches[BranchName]
    else
        if(tries == nil)then
            tries = 1;
        end;
        task.wait(tries/4);
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Framework:GetBranch(\""..BranchName.."\")")
            ErrorService.tossWarn(debug.traceback("Call Stack:",1));
        end
        return self:GetBranch(BranchName,tries+1);
    end;
end;

--[=[]=]
function Framework:HasBranch(BranchName:string)
    local tBranch = Branches[BranchName];
    print(tBranch)
    return tBranch and true or false, Branches[BranchName];
end
--[=[
    A branch is a wrapper for services and modulars. By default you use the 'main' branch which should be enough.
    But in some cases, a thirdparty may need to use this library, and to prevent naming errors mismatch, we added branches
]=]
function Framework:CreateBranch(BranchName:string):Types.FrameworkBranch
    ErrorService.assert(typeof(BranchName) == "string", ("string expected for BranchName, got %s"):format(typeof(BranchName)));
    if(Branches[BranchName])then
        return ErrorService.tossError("Branch \""..BranchName.."\" is already a Framework Branch")
    end;
    local Branch = CustomClassService:Create(FrameworkBrancher, nil, {
        BranchName = BranchName;
    });
    Branches[BranchName] = Branch;
    return Branch;
end;


local mainBranch = Framework:CreateBranch("main") --> Main branch
--> metatable so we can call :CreateBranch from the import, or use the main branch.
return setmetatable(Framework, {
    __index = mainBranch;
});


-- if(IsClient)then
--     return require(script.FrameworkClient);
-- else
--     return require(script.FrameworkServer);
-- end