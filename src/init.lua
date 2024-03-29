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

local Engine:any = require(script:WaitForChild("Engine"));
local RunService = game:GetService("RunService");

local Flags = require(script:WaitForChild("Util"):WaitForChild("Flags"));
Flags:Init();

local _forceenv = (Flags:GetFlag("force-env"));
if _forceenv then
	if _forceenv == "plugin" then
		Engine:InitPlugin(getfenv(0).plugin or script:FindFirstAncestorWhichIsA("Plugin"));
	elseif _forceenv == "game" then
		Engine:InitServer(true);
	end
else
	if RunService:IsRunning() then
		if RunService:IsServer() then
			Engine:InitServer();
		else
			Engine:InitClient();
		end
	else
		Engine:InitPlugin(getfenv(0).plugin or script:FindFirstAncestorWhichIsA("Plugin"));
	end;
end

--//Consts
local CoreEngine = script:WaitForChild("Core");

local Providers = CoreEngine:WaitForChild("Providers");
local ServiceProvider = require(Providers:WaitForChild("ServiceProvider"));
local LibraryProvider = require(Providers:WaitForChild("LibraryProvider"));

--//Consts
local CoreGlobals = CoreEngine:WaitForChild("Globals");
local CoreProviders = CoreEngine:WaitForChild("Providers");

local ModuleFetcher = require(CoreProviders:WaitForChild("Constants"):WaitForChild("ModuleFetcher"));
--local CoreLibs = CoreEngine.Librarys;

--//Consts
local Pseudo = require(script:WaitForChild("Pseudo"));
local Enumeration = require(script:WaitForChild("Enumeration"));
local Manifest = require(script:WaitForChild("Manifest"));

--[=[
	Main Module

	@class PowerHorseEngine
]=]

local PowerHorseEngine = {};
local Types = require(script.Types)
PowerHorseEngine.Types = Types

--[=[
	Uses [Pseudo.new] to create a Pseudo component
	@return Pseudo
]=]
function PowerHorseEngine.new(PseudoName:string,...:any):Types.Pseudo
	return Pseudo.new(PseudoName,...);
end;
--[=[
	@prop Manifest table
	@readonly
	@within PowerHorseEngine
]=]
PowerHorseEngine.Manifest = Manifest;
--[=[
	@prop Enumeration table
	@readonly
	@within PowerHorseEngine
]=]
PowerHorseEngine.Enumeration = Enumeration;
--[=[
	@prop Enum table -- Shorthand for Enumeration.
	@readonly
	@within PowerHorseEngine
]=]
PowerHorseEngine.Enum = Enumeration;

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
	Uses ServiceProvider:LoadServiceAsync
]=]

function PowerHorseEngine:GetService(ServiceName:string)
	return ServiceProvider:LoadServiceAsync(ServiceName)
end;

--[=[
	Uses [ModuleFetcher] to get the provider
]=]
function PowerHorseEngine:GetProvider(Provider:string)
	return ModuleFetcher(Provider, CoreProviders, Provider.." is not a valid Provider Name");
end;

--[=[
	@function New
	@within PowerHorseEngine
	Uses the [Whiplash] .New function
	@return Whiplash
]=]
PowerHorseEngine.New = PowerHorseEngine:Import("Whiplash").New;
--[=[
	@function OnWhiplashEvent
	@within PowerHorseEngine
	Uses the [Whiplash] library
	@return Whiplash
]=]
PowerHorseEngine.OnWhiplashEvent = PowerHorseEngine:Import("Whiplash").OnEvent;
--[=[
	@function OnWhiplashChange
	@within PowerHorseEngine
	Uses the [Whiplash] library
	@return Whiplash
]=]
PowerHorseEngine.OnWhiplashChange = PowerHorseEngine:Import("Whiplash").OnChange;
--[=[
	@function WhiplashForEach
	@within PowerHorseEngine
	Uses the [Whiplash] library
	@return Whiplash
]=]
PowerHorseEngine.WhiplashForEach = PowerHorseEngine:Import("Whiplash").ForEach;
--[=[
	@function WhiplashExecute
	@within PowerHorseEngine
	Uses the [Whiplash] library
	@return Whiplash
]=]
PowerHorseEngine.WhiplashExecute = PowerHorseEngine:Import("Whiplash").Execute;

--[=[
	Uses [CustomClassService:CreateClassAsync] to create a custom class
	@return Pseudo
]=]
function PowerHorseEngine.Create(ClassObject:table,DirectParent:Instance?,Args:any?,DirectProps:{[any]:any}?)
	return ServiceProvider:LoadServiceAsync("CustomClassService"):CreateClassAsync(ClassObject,DirectParent,Args,DirectProps);
end

--[=[
	@param Instance Pseudo | Instance | string
]=]
function PowerHorseEngine.GetPseudoFromInstance(Instance:Instance):Types.Pseudo
	local obj = typeof(Instance) == "table" and Instance:GetRef() or Instance;
	local PseudoID = obj:FindFirstChild("_pseudoid")
	assert(PseudoID, obj.Name.." does not have a pseudo id. could not find");
	return Pseudo.getPseudo(PseudoID.Value);
end;

--[=[]=]
function PowerHorseEngine:GetConfig():any?
	return Engine:RequestConfig()
end;

return PowerHorseEngine;
