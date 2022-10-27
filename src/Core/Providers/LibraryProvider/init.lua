--[=[
	@class LibraryProvider
	@tag Provider
]=]

local LibraryProvider = {}

local ConstantProviders = script.Parent.Constants;
local ModuleFetcher = require(ConstantProviders.ModuleFetcher);
local CoreLibraries = script.Parent.Parent.Libraries;
local Content = require(script.Parent.Parent.Globals:WaitForChild("Engine")):RequestContentFolder();
local libs = Content:FindFirstChild("libs");

local isServer = not game.Players.LocalPlayer and true;

local function importLibraryFromCloud(name)
	if(not libs)then
		if(isServer)then
			libs = Instance.new("Folder");
			libs.Name = "libs";
			libs.Parent = Content;
		end;
	end;
	local directory = name:split("/");

	local lastdir = libs;
	for i,v in pairs(directory) do
		local target = lastdir:FindFirstChild(v);
		if(not target)then
			error("Failed to import library @"..name..". Failed @ dir path \""..v.."\"");
		else
			lastdir = target;
		end
	end;

	if(lastdir:IsA("ModuleScript"))then
		return require(lastdir);
	else
		return lastdir;
	end

--[[
	if(not lib)then
		if(not isServer)then return ErrorService.tossError("Cannot import external library from client unless it was imported first by the server. Try running App:Import('@"..name.."') first from a server script.");end;
		
		local link = require(script.Cloud)[name];
		if(not link)then
			ErrorService.tossError("Could not import external library '"..name.."', The library does not exist or is not supported.");
		end;
		local s,Insert = pcall(function() return game:GetService("InsertService"):LoadAsset(link):GetChildren()[1]; end)
		if(not s)then
			ErrorService.tossError("Failed to import external library '"..name..". "..Insert);
		end
		Insert.Name = name;
		Insert.Parent = script.Cloud;
		return Insert;
	end;
]]
    -- return require(lib);
end

--[=[
	You can Load Multiple Libraries at once

	```lua
	local Library1,Library2 = LibraryProvider.LoadLibrary("Library1","Library2");
	```

	You can also Load `Cloud` Libraries from here. `Cloud` Libraries are just modules in your .content > libs folder. To load a
	cloud library place `@` at the start of the library name

	```lua
	local Library1,Library2 = LibraryProvider.LoadLibrary("@Library1","@Library2");
	```
	
	You can also load specific modules within a library

	```lua
	local FastSpawningModule,SlowSpawningModule = LibraryProvider.LoadLibrary("@Library1/FastSpawningModule","Library2/SlowSpawningModule");
	```
]=]
function LibraryProvider.LoadLibrary(...:any)
	local libs = {};
	for _,LibraryName in ipairs({...}) do
		local isCloudLibrary = LibraryName:match("^@");
		if(isCloudLibrary)then
			table.insert(libs,importLibraryFromCloud(LibraryName:sub(2,#LibraryName))) 
		end
		local Results = ModuleFetcher(LibraryName,CoreLibraries,"Could not load library "..LibraryName..". Library may not exist. To load external libraries, use @libraryname",false);
		table.insert(libs,Results);
	end;
	
	return unpack(libs);

end

return LibraryProvider;
