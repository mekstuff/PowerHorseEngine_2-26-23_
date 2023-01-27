local App = require(script.Parent.Parent.Parent);
local Types = require(script.Parent.Parent.Parent.Types);
local ErrorService = App:GetService("ErrorService");
local CustomClassService = App:GetService("CustomClassService");
local RunService = game:GetService("RunService");
local IsClient = RunService:IsClient();

local SillitoBrancher = require(script.SillitoBranch);

local Engine = App:GetGlobal("Engine");
local RSStorage = Engine:FetchReplicatedStorage();

if(not IsClient)then
    local SillitoSharedContainer = Instance.new("Folder");
    SillitoSharedContainer.Name = "Sillito_Workflow:Shared";
    SillitoSharedContainer.Parent = Engine:FetchReplicatedStorage();
    local SharedBranches = Instance.new("Folder",SillitoSharedContainer);
    SharedBranches.Name = "@Branches";
    local SillitoServerContainer = Instance.new("Folder");
    SillitoServerContainer.Name = "Sillito_Workflow:Server";
    SillitoServerContainer.Parent = Engine:FetchServerStorage();
    local ServerBranches = Instance.new("Folder",SillitoServerContainer);
    ServerBranches.Name = "@Branches";
    local SharedServices = Instance.new("Folder");
    SharedServices.Name = "@Shared";
    SharedServices.Parent = SillitoSharedContainer;
end

--[=[
    @class Sillito
]=]

local Sillito = {};
local Branches = {};

--[=[
    @return SillitoBranch

]=]
function Sillito:GetBranch(BranchName:string,tries:number?)
    if(Branches[BranchName])then
        return Branches[BranchName]
    else
        if(tries == nil)then
            tries = 1;
        end;
        task.wait(tries/4);
        if(tries == 5)then
            ErrorService.tossWarn("Possible Infinite Yield On Sillito:GetBranch(\""..BranchName.."\")")
            ErrorService.tossWarn(debug.traceback("Call Stack:",1));
        end
        return self:GetBranch(BranchName,tries+1);
    end;
end;

--[=[
    @return boolean, SillitoBranch?

]=]
function Sillito:HasBranch(BranchName:string)
    local tBranch = Branches[BranchName];
    return tBranch and true or false, Branches[BranchName];
end
--[=[
    A branch is a wrapper for services and modulars. By default you use the 'main' branch which should be enough.
    But in some cases, a thirdparty may need to use this library, and to prevent naming errors mismatch, we added branches

    @return SillitoBranch
]=]
function Sillito:CreateBranch(BranchName:string)
    ErrorService.assert(typeof(BranchName) == "string", ("string expected for BranchName, got %s"):format(typeof(BranchName)));
    if(Branches[BranchName])then
        return ErrorService.tossError("Branch \""..BranchName.."\" is already a Sillito Branch")
    end;
    local Branch = CustomClassService:Create(SillitoBrancher, nil, {
        BranchName = BranchName;
    });
    Branches[BranchName] = Branch;
    return Branch;
end;


local mainBranch = Sillito:CreateBranch("main") --> Main branch
--> metatable so we can call :CreateBranch from the import, or use the main branch.
return setmetatable(Sillito, {
    __index = mainBranch;
});