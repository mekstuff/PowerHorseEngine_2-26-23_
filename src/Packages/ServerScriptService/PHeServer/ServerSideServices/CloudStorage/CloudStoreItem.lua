local CloudStoreItem = {
    Name = "CloudStoreItem";
    ClassName = "CloudStoreItem";
    Data = "**table";
};

function CloudStoreItem:Set(key,value)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    ErrorService.assert(typeof(key) == "string", ("argument 1 missing from :Set method on %s, key must be a string value. got %s"):format(self.Name,tostring(key)));
    local CloudStore = self._dev.args.Store;
    local SetPromise = App.new("Promise"):Try(function(resolve,reject)
        local s,r,keyinfo = pcall(function()
            return CloudStore:_UpdateAsync(key, function()
                return value;
            end);
        end);
        if(s)then
            resolve({success = true})
        else
            reject({error = r})
        end
    end);
    return SetPromise;
end

function CloudStoreItem:Get(key)
    -- return key and self._data[key] or self._data;
end;

function CloudStoreItem:Adapt(...:any):table
    local App = self:_GetAppModule();
    local Array = App:Import("Array");

    return Array.Adapt(self._data,...);
end;

function CloudStoreItem:_Render()
    local key = self._dev.args.key;
    local Store = self._dev.args.Store;

    -- Store._DStore:SetAsync("TestValue1", true);
  

    -- self.Data = {};
    -- self.Name = key;


    return {};
end

return CloudStoreItem;