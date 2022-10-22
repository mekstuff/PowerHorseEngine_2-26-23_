--[=[
	Provider of libraries for live games (does not work for plugins and command)

	@class LibraryProvider
	@tag Provider
]=]

local LibraryProvider = {}

local ConstantProviders = script.Parent.Constants;
local ModuleFetcher = require(ConstantProviders.ModuleFetcher);
local CoreLibraries = script.Parent.Parent.Libraries;
local ErrorService = require(script.Parent.Parent.Services.ErrorService);
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


function LibraryProvider.LoadLibrary(...)
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
