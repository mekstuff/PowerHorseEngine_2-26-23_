local module = {}
local CustomClassService = require(script.Parent.CustomClassService);
local ErrorService = require(script.Parent.ErrorService);
local DataStoreService = game:GetService("DataStoreService");
local ModuleCache = {};
local IsClient = game.Players.LocalPlayer and true;

local DataStore = {
	Name = "DataStore";
	ClassName = "DataStore";
	Autosave = true;
};

local function handle(r,e)
	e = e or "Internal DataStoreError ->"
	ErrorService.tossWarn(e.." "..r);
end;
--//
function DataStore:RemoveCache(Key)
	self._data[Key]=nil;
end;
--//
function DataStore:GetCache()
	if(ModuleCache[self._name])then
		ErrorService.tossMessage("Since we don't have access to your GetCache Memory, we can't clear it when Cache is cleared.");
		return ModuleCache[self._name];	
	end;
end;
--//
function DataStore:SetCache(To)
	--assert(To == nil, "SetCache requires")
	ErrorService.tossMessage("Using SetCache will overwrite the existing data stored on the server. If a key is updated before this function is call, it will completely wipe the data and use yours. This cache can be served to ROBLOX use DataStore:Serve()");
	ModuleCache[self._name] = To;
end;


--//
function DataStore:RemoveAsync(Key)
	--ModuleCache[Key] = nil;
	local ran,results = pcall(function()
		return self._datastore:RemoveAsync(Key);
	end)if(not ran)then handle(results);end;
	self._data[Key]=nil;
	ErrorService.tossWarn("DataStoreService: Note that the server cache (if any) was removed and the next GetAsync for the given key will make a external call.");
	print("Data cache removed")
end

function DataStore:GetAsync(Key)
	if(self._data[Key] == nil)then
		local ran,results = pcall(function()
			return self._datastore:GetAsync(Key);
		end);if(not ran)then
			handle(results)
		end;	
		self._data[Key]=results;
	end;
	return self._data[Key];
end;
--//
function DataStore:SetAsync(Key,Value,ShouldServe)
	self._data[Key]=Value;
	if(ShouldServe)then self:Serve(Key);end;
end;
--//
function DataStore:SaveAsync()
	--print(self._data);
end
--//
function DataStore:Serve(Key)
	assert(not IsClient, "Serve can only be called by the server");
	local ran,results = pcall(function()
		return self._datastore:UpdateAsync(Key,function()
			return self._data[Key];
		end)
	end)if(not ran)then
		handle(results)
	end;	
	if(game:GetService("RunService"):IsStudio())then
		ErrorService.tossMessage("DataStore:Serve:"..self.Name.." -> "..tostring(Key)..":Studio:Successfully served datastore.");
	end
end
--//
function DataStore:UpdateAsync(DatastoreKey,Key,Value)
	assert(not IsClient, "UpdateAsync can only be called by the server");
	if not (self._data[DatastoreKey])then ErrorService.tossWarn(DatastoreKey.." is not a valid DataStoreKey of this datastore \""..self.Name.."\"");return;end;
	--if not (self._data[DatastoreKey][Key])then ErrorService.tossWarn("Could not find "..tostring(Key).." inside "..tostring(DatastoreKey)..". Is your data stored as a dictionary?\n\n DataStoreKey = { Key1 : true, Key2 : false, Key3 : Hello, Belly }");return;end;

	self._data[DatastoreKey][Key]=Value;
	print("Nice")
end

function DataStore:_Render()
	return {
		["Autosave"] = function(Value)
			if(Value)then
				self._dev.AutosaveBindToClose = game:BindToClose(function()
					--print("Saving entire data");
					--self:SaveAsync();
				
				end);
			else
				print(self._dev.AutosaveBindToClose);
			end
		end,	
	};
end;

function module:GetDataStore(dstore,version_)
	assert(not IsClient, "GetDataStore can only be called by the server");
	if(version_)then
		dstore = dstore..tostring(version_);
	end
	local DataCache = ModuleCache[dstore];
	
	if(DataCache)then return DataCache;end;
	
	local DatastoreClass = CustomClassService:CreateClassAsync(DataStore);
	
	local ran,results = pcall(function()
		return DataStoreService:GetDataStore(dstore);
	end);if(not ran)then
		ErrorService.tossMessage("Internal DataStore Error -> "..results);
	end;
	
	DatastoreClass.Name = DatastoreClass.ClassName.." "..dstore;
	DatastoreClass._datastore = results;
	DatastoreClass._name = dstore;
	DatastoreClass._data = {};
	
	ModuleCache[dstore]=DatastoreClass;
	
	return DatastoreClass;
	
end;


return module
