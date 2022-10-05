local DataStoreService = game:GetService("DataStoreService");
local CloudStoreItem = require(script.Parent.CloudStoreItem);

local m = {
    Name = "CloudStore";
    ClassName = "CloudStore";
    SessionLocked = false;
    SESSIONID = "";
};

function m:_UpdateAsync(...:any)
    return self._DStore:UpdateAsync(...);
end

function m:Load(key)
    local data = self:_GetAppModule().Create(CloudStoreItem,nil,{key = key,Store = self});
    return data;
end;

function m:_Render()
    local args = self._dev.args;
    local StoreName = args.StoreName;
    local Scope = args.Scope;
    local Options = args.Options

    local DataStoreFetch = DataStoreService:GetDataStore(StoreName,Scope,Options);

    self._DStore = DataStoreFetch;

    self.SESSIONID = tostring(game.JobId).."-"..tostring(game.PlaceId);
    self.__lockedProperties["SESSIONID"] = true;
    


    return {
        ["SessionLocked"] = function(v)
            self.__lockedProperties["SessionLocked"] = true;

            self.__lockedProperties["SessionLocked"] = false;
            
        end;
    };
end

return m;
