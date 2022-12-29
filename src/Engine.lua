local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


--[=[
	@class Engine
	@tag Global
]=]

local Engine = {}
local ServiceProvider = require(script.Parent:WaitForChild("Core"):WaitForChild("Providers"):WaitForChild("ServiceProvider"));

ServiceProvider:LoadServiceAsync("ReplicationService") --< Creates replication event.

Engine.ErrorService = ServiceProvider:LoadServiceAsync("ErrorService");
Engine.Manifest = require(script.Parent:WaitForChild("Manifest"));

local ServerInitiated=false;
--> Optimize so we only use events that are used.
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
		"SSRENDERV1_SUBSCRIBEREQUEST";
		"CODESERVICE_COMMUNICATION";
		--"KEYSERVICESHAREDKEYGRABBER";
		
	};["BindableEvent"]={
		
	};
};

function Engine:InitPlugin(plugin)
	local Manifest = require(script.Parent["Manifest"]);
	local PluginService = ServiceProvider:LoadServiceAsync("PluginService");
	PluginService:Sync(plugin);
	print("\nRunning", Manifest.Name, "v-", Manifest.Upd.Version, "for plugin \"", plugin,"\"");
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
end;

--//
function Engine:InitClient(Client)
	if not Client then 
		Client = game.Players.LocalPlayer;
	end;
end;

local function waitForContentFolder(tries:number?)
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
function Engine:RequestConfig(NotImportant:boolean?):{}|nil
	if(NotImportant)then
		local x = self:RequestContentFolder():FindFirstChild("Config");
		if(x)then
			return require(x);
		else
			return nil;
		end;
	end
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

	local PHe_RS_events = game:GetService("ReplicatedStorage"):WaitForChild("PHe_RS",600):WaitForChild("events",600);

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
	else
		eventSearch = TypeSearch:WaitForChild(EventName);
	end;
	
	return eventSearch
end

return Engine
