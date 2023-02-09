--[=[
    @class CatalogEditor
    CatalogEditor must be imported on the server for it to work properly
]=]

local LibraryProvider = require(script.Parent.Parent.Providers:WaitForChild("LibraryProvider"));
local Sillito:SillitoLibrary = LibraryProvider.LoadLibrary("Sillito");

local BranchName = "PHeCatalogEditorLibrary"
local Branch = Sillito:CreateBranch(BranchName);

local IsClient = game:GetService("RunService"):IsClient();

if(IsClient)then
    Branch:PortModulars(script:WaitForChild("Client"));
else
    Branch:PortServices(script:WaitForChild("Server"));
end;

Branch:Start():WhenThen(function()
    return {}
end):Catch(function(err)
    warn("CatalogEditor Library Failed To Initiate: "..err)
end);

-- local CatalogEditor = {};


return IsClient and Branch:GetModular("Main") or Branch:GetService("Main");