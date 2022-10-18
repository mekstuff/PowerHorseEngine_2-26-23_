local CollectionService = game:GetService("CollectionService");
local CustomClassService = require(script.Parent.Parent.Services.CustomClassService);
local PseudoService = require(script.Parent.Parent.Services.PseudoService);

--[=[
    @class Collector
]=]

local Collector = {
    Name = "Collector",
    ClassName = "Collector",
};

function Collector:_GetTagInstanceObject(instance:any)
    if(instance:IsA("Pseudo"))then
        instance = instance:GetRef();
    end
    return instance;
end

function Collector:Create()
    -- return CollectionService:GetTags
end;

function Collector:_Tag(instance:any,tagname:string):nil
    instance = self:_GetTagInstanceObject(instance);
    CollectionService:AddTag(instance,tagname);
end;

function Collector:_RemoveTag(instance:any,tagname:string):nil
    instance = self:_GetTagInstanceObject(instance);
    CollectionService:RemoveTag(instance,tagname);
end
--[=[
    @param instance Pseudo | Instance
]=]
function Collector:HasTag(instance:any,tagname:string):boolean
    instance = self:_GetTagInstanceObject(instance);
    return CollectionService:HasTag(instance,tagname)
end;
--[=[
    @param instances table | Pseudo | Instance
]=]
function Collector:Tag(instances:table|Instance,tagname:string):nil
    if(typeof(instances) == "table" and not instances.IsA)then
        for _,x in pairs(instances) do
            self:_Tag(x,tagname);
        end;
    else
        self:_Tag(instances,tagname);
    end;
end;
--[=[]=]
function Collector:AddTag(...:any)
    return self:Tag(...);
end;
--[=[
    @param instances table | Instance | Pseudo
]=]
function Collector:RemoveTag(instances:table|Instance,tagname:string):nil
    if(typeof(instances) == "table")then
        for _,x in pairs(instances) do
            self:_RemoveTag(x,tagname);
        end;
    else
        self:_RemoveTag(instances,tagname);
    end;
end;
--[=[
    @return Servant
]=]
function Collector:Bind(Tag:string,Callback:any)
    local App = self:_GetAppModule();
    local BindID = tostring(Callback);
    local BindServant = App.new("Servant");
    BindServant.Name = "CollectorBinder-"..BindID:gsub("function: ","");
    BindServant._dev.Cleanup = {};

    self._dev.Servants[Callback] = BindServant;

    local function handleCallback(x)
        task.spawn(function()
            local cleanup = Callback(x,BindServant);
            if(cleanup)then
                BindServant._dev.Cleanup[x] = cleanup;
            end
        end)
        
    end;

    BindServant:Connect(CollectionService:GetInstanceAddedSignal(Tag), function(instance)
        if(instance:FindFirstChild("_pseudoid"))then
            instance = PseudoService:GetPseudoFromId(instance);
        end;
        handleCallback(instance);
    end);
    BindServant:Connect(CollectionService:GetInstanceRemovedSignal(Tag), function(instance)
        if(instance:FindFirstChild("_pseudoid"))then
            instance = PseudoService:GetPseudoFromId(instance);
        end;
        if(BindServant._dev.Cleanup[instance])then
            BindServant._dev.Cleanup[instance]();
            BindServant._dev.Cleanup[instance]=nil;
        end
    end);
    for _,v in pairs(CollectionService:GetTagged(Tag)) do
        if(v:FindFirstChild("_pseudoid"))then
            v = PseudoService:GetPseudoFromId(v) or v;
        end;
        handleCallback(v);
    end;
    self._dev.MainServant:Keep(BindServant);
    return BindServant;
end;

--[=[
    @param Binded Servant
]=]
function Collector:Unbind(Binded:Instance):nil
    Binded:Destroy();
end

function Collector:_Render(App)
    local MainServant = App.new("Servant");
    self._dev.MainServant = MainServant;
    self._dev.Servants = {};
    return {};
end;

return CustomClassService:Create(Collector);