local module = {}
local HTTPService = game:GetService("HttpService");
local ErrorService = require(script.Parent.ErrorService);
local Engine = require(script.Parent.Parent.Globals.Engine);
local isServer = game:GetService("RunService"):IsServer();
local Keys = {};


if not (game:GetService("RunService"):IsRunning())then
	ErrorService.tossError("KEYSERVICE can only be used while the game is running");
	return;
end;

if(isServer)then
	local function onInvoke(Plr,keySearch)
		local ServerStorageArea = Engine:FetchServerStorage();
		local KeyStorage = ServerStorageArea:FindFirstChild("KeyStorage");
		if(not KeyStorage)then return "XD", "Keystorage is not available (not initiated by server yet)";end;
		local Key = KeyStorage:FindFirstChild(keySearch)
		if(Key)then
			local isDedicated = Key:FindFirstChild("dedicatedUser");
			--print(tonumber(isDedicated.Value) == Plr.UserId)
			if(isDedicated)then
				if(isDedicated.Value == tostring(Plr.UserId))then
					return Key.Value;					
				else
					return nil, "This key is a dedicated shared key and cannot be accessed by the user."
				end;
			else
				return Key.Value;
			end
		end
		return nil, "Shared key could not be found.";
	end;
	
	local fetchKeyRemote = Engine:FetchStorageEvent("KEYSERVICESHAREDKEYGRABBER","RemoteFunctions");
	fetchKeyRemote.OnServerInvoke = onInvoke;
	--fetchKeyRemote.o
end

function module:Give(KeyName,Shared,dedicatedUserId)
	if(Keys[KeyName])then
		ErrorService.tossWarn("Key "..KeyName.." is already an existing key name");
		return;
	end;
	local key = HTTPService:GenerateGUID(false);
	Keys[KeyName]=key;
	if(Shared)then
		if(not isServer)then ErrorService.tossWarn("Shared keys can only be created by the server \""..KeyName.."\"") return end;
		local ServerStorageArea = Engine:FetchServerStorage();
		local KeyStorage = ServerStorageArea:FindFirstChild("KeyStorage");
		if(not KeyStorage)then
			KeyStorage = Instance.new("Folder",ServerStorageArea);
			KeyStorage.Name = "KeyStorage";
		end;
		local newKey = Instance.new("StringValue",KeyStorage);
		newKey.Name = KeyName;
		newKey.Value = key;
		if(dedicatedUserId)then
			local dedicated = Instance.new("StringValue",newKey);
			dedicated.Name = "dedicatedUser";
			dedicated.Value = dedicatedUserId;
		end
	end
	return key;
end;

function module:Get(Keyname,fromShared)
	if not fromShared then
		return Keys[Keyname];
	end;
	
	if(not isServer)then
		local fetchKeyRemote = Engine:FetchStorageEvent("KEYSERVICESHAREDKEYGRABBER","RemoteFunctions");
		if(not fetchKeyRemote)then
			ErrorService.tossWarn("Can't fetch sharedkeys because the server hasn't initiated KEYSERVICE");
			return
		end
	 return fetchKeyRemote:InvokeServer(Keyname)
	end
	
end

return module
