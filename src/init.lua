--[[
MIT License

Copyright (c) 2022 Olanzo James

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]] 

local Engine = require(script:WaitForChild("Engine"));
local RunService = game:GetService("RunService");

if(RunService:IsRunning())then
	if(RunService:IsServer())then
		Engine:InitServer();
	else
		Engine:InitClient();
	end
else
	Engine:InitPlugin(getfenv(0).plugin or script:FindFirstAncestorWhichIsA("Plugin"));
end;

--//Consts
local Providers = (script.Core.Providers);
local ServiceProvider = require(Providers.ServiceProvider);
local LibraryProvider = require(Providers.LibraryProvider);

--//Consts
local CoreEngine = script.Core;
local CoreServices = CoreEngine.Services;
local CoreGlobals = CoreEngine.Globals;
local CoreProviders = CoreEngine.Providers;

local ModuleFetcher = require(CoreProviders.Constants.ModuleFetcher);
--local CoreLibs = CoreEngine.Librarys;

--//Consts
local Pseudo = require(script.Pseudo);
local Enumeration = require(script.Enumeration);
local Manifest = require(script["Manifest"]);

--[=[
	Main Module

	@class PowerHorseEngine
]=]

local PowerHorseEngine = {};
--PowerHorseEngine.Pseudo = Pseudo;
PowerHorseEngine.Enumeration = Enumeration;
PowerHorseEngine.Manifest = Manifest;
_G.App = PowerHorseEngine;

--[=[
	Uses [LibraryProvider.loadLibrary] to import the library
]=]
function PowerHorseEngine:Import(libraryName:string)
	return LibraryProvider.LoadLibrary(libraryName);
end

--[=[
	Uses [ModuleFetcher] to get the global
]=]
function PowerHorseEngine:GetGlobal(GlobalName:string)
	return ModuleFetcher(GlobalName, CoreGlobals, GlobalName.." is not a valid Global Name");
	--return require(CoreGlobals:FindFirstChild(GlobalName));
end;

--[=[
	Uses [ServiceProvider:LoadServiceAsync] to load the service
]=]
function PowerHorseEngine:GetService(ServiceName:string)
	return ServiceProvider:LoadServiceAsync(ServiceName)
	--return fetchModule(ServiceName,CoreServices, ServiceName.." Is Not A Valid Service Name");
end;

--[=[
	Uses [ModuleFetcher] to get the provider
]=]
function PowerHorseEngine:GetProvider(Provider:string)
	return ModuleFetcher(Provider, CoreProviders, Provider.." is not a valid Provider Name");
	--return require(Providers:FindFirstChild(Provider));
end;

--//Whiplash Library Support
PowerHorseEngine.New = PowerHorseEngine:Import("Whiplash").New;
PowerHorseEngine.OnWhiplashEvent = PowerHorseEngine:Import("Whiplash").OnEvent;
PowerHorseEngine.OnWhiplashChange = PowerHorseEngine:Import("Whiplash").OnChange;
PowerHorseEngine.WhiplashForEach = PowerHorseEngine:Import("Whiplash").ForEach;
PowerHorseEngine.WhiplashExecute = PowerHorseEngine:Import("Whiplash").Execute;

--[=[
	Uses [CustomClassService:CreateClassAsync] to create a custom class
]=]
function PowerHorseEngine.Create(...:any)
	return ServiceProvider:LoadServiceAsync("CustomClassService"):CreateClassAsync(...);
end
--[=[
	Uses [Pseudo.new] to create a Pseudo component
]=]
function PowerHorseEngine.new(...:any)
	return Pseudo.new(...);
end;

function PowerHorseEngine.GetPseudoFromInstance(ins:any)
	local obj = typeof(ins) == "table" and ins:GetRef() or ins;
	local PseudoID = obj:FindFirstChild("_pseudoid")
	assert(PseudoID, obj.Name.." does not have a pseudo id. could not find");
	return Pseudo.getPseudo(PseudoID.Value);
end;

local _config;
function PowerHorseEngine:GetConfig()
	return Engine:RequestConfig()
	-- if(_config)then return _config;end;
	-- _config = require(script.Content:WaitForChild("Config"));return _config;
end;

--[[
local nilFold = Instance.new("Folder");
nilFold.Name = "nilFold";
local PHeNilFolder = script.PHeNilFolderPlaceHolder;
PHeNilFolder.Parent = nilFold;
local bypass = {"Replicator","Content","Packages","Engine","Enumeration"}
for _,v in pairs(script:GetChildren()) do
	if not (table.find(bypass, v.Name))then v.Parent=PHeNilFolder;end;
end
]]

return PowerHorseEngine
