local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
-- local Util = script.Parent.Util;

--[=[
	@class Engine
	@tag Global
]=]

local Engine = {}
local ServiceProvider = require(script.Parent.Core.Providers.ServiceProvider);

ServiceProvider:LoadServiceAsync("ReplicationService") --< Creates replication event.

Engine.ErrorService = ServiceProvider:LoadServiceAsync("ErrorService");
Engine.Manifest = require(script.Parent["Manifest"]);

local ServerInitiated=false;
local StorageEvents = {
	["RemoteFunction"] = {
		"ShareEnumerationAsync_CLIENT";
		"KEYSERVICESHAREDKEYGRABBER";
		"CoordinateCommunicator";
		"PHePanel_CommandExecutor";
		"PHePanel_CommandReciever";
		--"PingService_RequestUserPing_Event";
	};
	["RemoteEvent"]={
		"NotificationService_SendNotificationAsync";
		"VoteKickService_VoteKickUser";
		"Backpack_EquipCall";
		"InGamePurchaseService";
		"CoordinateTeleporter";
		"PromptUserAsyncEvent";
		"TradeCommunicator";
		"replicationSafetyCallback";
		"NotificationBannerService_Notify";
		"PHe_PanelRemover";
		"MagicBuild_ExecuteBuild";
		"CoreFunc_ClientEngineProvider";
		--"KEYSERVICESHAREDKEYGRABBER";
		
	};["BindableEvent"]={
		
	};
};

--[[
local function EstablishGlobals()
	local rs = game:GetService("ReplicatedStorage");
	if(script.Parent.Parent ~= rs)then return end;
	--print("Establishing Globals");
	local Globals = script.Parent.Core.Globals;
	for _,g in pairs(Globals:GetChildren()) do
		_G[g.Name] = require(g);
	end
end;
]]
--[[

local function userConfig()

	local Manifest = require(script.Parent["Manifest"]);
	-- local Config = require(Engine:RequestContentFolder():FindFirstChild("Config"));
	
	
	local ManifestVersion,ConfigVersion = Manifest.Upd.Version:gsub(" ",""),Config.v:gsub(" ","");
	
	if(ManifestVersion ~= ConfigVersion)then
		warn("[PowerHorseEngine] Version mismatch. Your version -> "..ConfigVersion.." Server version -> "..ManifestVersion);
		warn("Update PowerHorseEngine Installer from toolbox");
		warn("\nVersion Notes:");
		warn( (Manifest.Upd.VersionNotes.Major and #Manifest.Upd.VersionNotes.Major>0) and "Major Changes:\n"..table.concat(Manifest.Upd.VersionNotes.Major, "\n") or "No Major Changes.")
		warn( (Manifest.Upd.VersionNotes.Minor and #Manifest.Upd.VersionNotes.Minor>0) and "Minor Changes:\n"..table.concat(Manifest.Upd.VersionNotes.Minor, "\n") or "No Minor Changes.")
		warn( (Manifest.Upd.VersionNotes.Patches and #Manifest.Upd.VersionNotes.Patches>0) and "Patches:\n"..table.concat(Manifest.Upd.VersionNotes.Patches, "\n") or "No Patches.")
		if(Manifest.Upd.UpdReq)then
			script.Parent:Destroy();
			error("Update required. PowerHorseEngine failed.");
		end
	end
	
	
	local maniV1,maniV2,maniV3 = Manifest.Upd.Version:gsub(" ",""):match("([%d]+)%.(%d+)%.(%d+)");
	local configv1,configv2,configv3 = Config.v:gsub(" ",""):match("([%d]+)%.(%d+)%.(%d+)");

	print(maniV1,maniV2,maniV3)
	
	print(configv1,configv2,configv3)
	
	local outdated=false;
	local levelOutdate = 0
	
	if(maniV3 > configv3)then outdated=true;levelOutdate=1 end;
	if(maniV2 > configv2)then outdated=true;levelOutdate=2 end;
	if(maniV1 > configv1)then outdated=true;levelOutdate=3 end;
		
end;
]]


function Engine:InitPlugin(plugin)
	-- local Manifest = require(script.Parent["Manifest"]);
	local PluginService = ServiceProvider:LoadServiceAsync("PluginService");
	PluginService:Sync(plugin);
	-- print("\nRunning", Manifest.Name, "v-", Manifest.Upd.Version, "for plugin \"", plugin,"\"");
	
	--[[
	local Manifest = require(script.Parent["Manifest"])
	local CoreGui = game:GetService("CoreGui");
	local PluginFolderCoreGui = CoreGui:FindFirstChild(Manifest.Name.."-PluginUtil");
	
	if(not PluginFolderCoreGui)then
		local f = script.Parent.Util:FindFirstChild("Plugin");
		f.Name = Manifest.Name.."-PluginUtil";
		f.Parent = CoreGui;
		require(f.init)();
	end
	]]
	--local PluginService = 
end

function Engine:InitServer(PushPackages:boolean)	
	if game:GetService("RunService"):IsClient() then
		if game:GetService("RunService"):IsRunning() then 
			warn("Server cannot be initiated from the client.");
		end;
		return
	end;
	if script.Parent.Parent ~= game:GetService("ReplicatedStorage") then return end;
	if ServerInitiated then
		warn("Server Already Initiated");
		return 
	end;

	

	if game.ReplicatedStorage:FindFirstChild("PHe_RS") then return end;
	
	-- EstablishGlobals();
	-- userConfig();
	
		local POSTPHe = Instance.new("Folder");
		POSTPHe.Name = "PHe_POST";
		POSTPHe.Parent = ReplicatedFirst;
		
		local POSTCONTENT = self:RequestContentFolder():FindFirstChild("POST");
		
		if POSTCONTENT then
			POSTCONTENT.Parent = POSTPHe;
		end
		
		local SSStorage = Instance.new("Folder");
		SSStorage.Name = "PHe_SS";
		SSStorage.Parent = game:GetService("ServerStorage");
		
		local WSStorage = Instance.new("Folder");
		WSStorage.Name = "PHe_WS";
		WSStorage.Parent = game:GetService('Workspace');
	
		local RSStorage = Instance.new("Folder");
		RSStorage.Name = "PHe_RS";
		RSStorage.Parent = ReplicatedStorage;
		
		local RSEvents = Instance.new("Folder");
		RSEvents.Name = "events";
		RSEvents.Parent = RSStorage;

		for name,all in pairs(StorageEvents)do
			local newStore = Instance.new("Folder");
			newStore.Name = name.."s";
			newStore.Parent = RSEvents;
			for _,event in pairs(all)do
				local newEvent = Instance.new(name);
				newEvent.Name = event;
				newEvent.Parent = newStore;
			end
		end;
	
		local RSLocalEvents = Instance.new("Folder")
		RSLocalEvents.Name = "localEvents";
		RSLocalEvents.Parent = RSStorage;

		if(PushPackages)then
			script.Parent.Packages.PackageController.Parent = game.ServerScriptService;
		end
		
		-- script.Parent.Packages.PackageController.Parent = game:GetService("ServerScriptService");
	-- local thread = coroutine.create(function()
	-- 	if(PushPackages)then
	-- 	    for _,Package in pairs(script.Parent.Packages:GetChildren())do
	-- 			if(Package:IsA("Folder") and Package.Name ~= "$Preloaders")then
	-- 				for _,x in pairs(Package:GetChildren())do
	-- 					x.Parent = game:FindFirstChild(Package.Name);
	-- 				end
	-- 			end
	-- 		end;
	-- 	end
	-- end);coroutine.resume(thread);
	
end;

--//
function Engine:InitClient(Client)
	if not Client then 
		Client = game.Players.LocalPlayer;
	end;
	-- EstablishGlobals();
end;

local function waitForContentFolder(tries:number)
	local folder = script.Parent:FindFirstChild(".content") or script.Parent:FindFirstChild(".lanzo");
	if not folder then
		tries = tries or 0;
		if tries == 20 then
			warn("Waiting for .content or .lanzo folder to be added to root, this is taking longer than it should. Did you sync a \".content\" or \".lanzo\" folder into PowerHorseEngine's root? This folder is required. You may encounter a lag spike as scripts try to request this folder, Please end the session.");
		end;
		task.wait(tries/5);
		return waitForContentFolder(tries+1);
	end;
	return folder;
end;

function Engine:RequestContentFolder()
	return waitForContentFolder();
end;
--[=[]=]
function Engine:RequestConfig()
	return require(self:RequestContentFolder():WaitForChild("Config"));
end
--[=[]=]
function Engine:RequestUserGameContent()
	return require(self:RequestContentFolder():WaitForChild("Config")).Game;
end
--[=[]=]
function Engine:FetchReplicatedStorage()
	return game:GetService("ReplicatedStorage"):WaitForChild("PHe_RS");	
end
--[=[]=]
function Engine:FetchWorkspaceStorage()
	return game:GetService("Workspace"):WaitForChild("PHe_WS");	
end
--[=[]=]
function Engine:FetchLocalEvents()
	return Engine:FetchReplicatedStorage():WaitForChild("localEvents");
end
--[=[]=]
function Engine:FetchServerStorage()
	return game:GetService("ServerStorage"):WaitForChild("PHe_SS");
end
--[=[]=]
function Engine:FetchStorageEvent(EventName:string, Type:string)
	if not Type then
		Type = "RemoteEvents";
	end;
	--Type = Type.."Events";
	
	local PHe_RS_events = game:GetService("ReplicatedStorage"):WaitForChild("PHe_RS",600):WaitForChild("events",600);
	
	--local Search 
	
	local TypeSearch = PHe_RS_events:FindFirstChild(Type);
	if not TypeSearch then
		local x = Instance.new("Folder");
		x.Name = Type;
		x.Parent = PHe_RS_events;
		TypeSearch = x;
	end;
	
	local eventSearch = TypeSearch:FindFirstChild(EventName);
	if not eventSearch and game:GetService("RunService"):IsServer() then
		local t = string.sub(TypeSearch.Name, 1, #TypeSearch.Name-1);

		local x = Instance.new(t);
		x.Name = EventName;
		x.Parent = TypeSearch;
		eventSearch = x;
		--print("Event : "..EventName.." was created because it didn't exist before.");
	else
		eventSearch = TypeSearch:WaitForChild(EventName);
	end;
	
	return eventSearch
end

return Engine
