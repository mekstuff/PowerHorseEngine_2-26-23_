local App = require(script.Parent:WaitForChild("$AppPointer").Value);
local CloudStoreClass = require(script.CloudStore);
local CloudStorage = {};

function CloudStorage:GetCloudStore(StoreName:string,Scope:string,Options:string)
    local CloudStore = App.Create(CloudStoreClass,nil,{StoreName = StoreName,Scope=Scope,Options=Options});
    return CloudStore;
end;

return CloudStorage;