local ContextActionService = game:GetService("ContextActionService")
local HttpService = game:GetService("HttpService")
--[=[
    @class ClientBackpackService
    @tag ClientService
]=]
local ClientBackpackService = {
    Name = "ClientBackpackService",
    ClassName = "ClientBackpackService",
    Tracked = {};
    ToolTagName = "CLIENT_BACK_SERVICE_ACTIVE_BACKPACK_TOOL";
    ProxyBackpacks = {};
};

--[=[
    Uses [CoreGuiService.SetNativeGuiEnabled]
    @return Promise
]=]
function ClientBackpackService:SetCoreBackpackEnabled(state:boolean)
    local App = self:_GetAppModule();
    local CoreGuiService = App:GetService("CoreGuiService");
    return CoreGuiService:SetNativeGuiEnabled(Enum.CoreGuiType.Backpack, state);
end;

--[=[]=]
function ClientBackpackService:GetTools(Player:Player,existingTable:{[any]:any}?)
    local Backpack = Player:WaitForChild("Backpack");
    local Character = Player.Character or Player.CharacterAdded:Wait();

    local t = existingTable or {};
    for _,x in pairs(Backpack:GetChildren()) do
        if(x:IsA("Tool"))then
            if(not table.find(t,x))then
                table.insert(t,x);
            end;
        end
    end;
    for _,x in pairs(Character:GetChildren()) do
        if(x:IsA("Tool"))then
            if(not table.find(t,x))then
                table.insert(t,x);
            end;
        end
    end;
    return t;
end;

--[=[
    @class ClientBackpackProxy
]=]
local ClientBackpackProxy = {
    Name = "ClientBackpackProxy",
    ClassName = "ClientBackpackProxy",
    GUID = HttpService:GenerateGUID(false);
    Backpacks = {};
    Charaters = {};
}

function ClientBackpackProxy:_Render()
    self._toolbindtag = self._dev.args.ToolTagName.."-"..tostring(self._dev.args.Player.UserId);
    local App = self:_GetAppModule();
    local Player:Player = self._dev.args.Player;
    local Backpack = Player:WaitForChild("Backpack");
    local Character = Player.Character or Player.CharacterAdded:Wait();
    local Collector = App:Import("Collector");

    table.insert(self.Charaters, Character);
    table.insert(self.Backpacks, Backpack);

    local function connectToItem(item,servant,doubleChecker)
        for _,x in pairs(item) do
            for _,v in pairs(x:GetChildren())do
                if(v:IsA("Tool"))then
                    Collector:Tag(v,self._toolbindtag);
                end;
            end;
            servant:Connect(x.ChildAdded,function(child)
                if(child:IsA("Tool"))then
                    Collector:Tag(child,self._toolbindtag);
                end
            end);
            servant:Connect(x.ChildRemoved,function(child)
                if(child:IsA("Tool") and not table.find(doubleChecker:GetChildren(), child))then
                    Collector:RemoveTag(child,self._toolbindtag);
                end
            end);
        end; 
    end;
    
    return function(Hooks)
        local useEffect = Hooks.useEffect;

        useEffect(function()
            local servant = App.new("Servant")
            task.spawn(function()
                connectToItem(self.Backpacks,servant,Character);
                connectToItem(self.Charaters,servant,Backpack);
            end)

            return function ()
                servant:Destroy();
            end
        end,{"Backpacks"})

    end
end;

--[=[
    @param BindHandler (Tool:Tool,CollectorBinder:Servant)->any
    @return Servant -- Collector Binded Connection.
    Useful for creating custom backpack systems
]=]
function ClientBackpackProxy:ToolBind(BindHandler:any)
    local Collector = self:_GetAppModule():Import("Collector");
    return Collector:Bind(self._toolbindtag,BindHandler)
end;
--[=[]=]
function ClientBackpackProxy:GetTools():{[number]:Tool}
    local Collector = self:_GetAppModule():Import("Collector");
    return Collector:GetTagged(self._toolbindtag);
end;
--[=[]=]
function ClientBackpackProxy:GetIndexBasedOnBindId(BindId:string)
    if(not self._List)then
        self:_GetAppModule():GetService("ErrorService").tossWarn("self._List is nil, cannot fetch GetIndexBasedOnBindId")
    end
    for i:number,x:{[any]:any} in pairs(self._List)do
        if(x.BindId == BindId)then
            return i;
        end;
    end;
end;
function ClientBackpackProxy:HasToolEquipped(Tool:Tool)
    local Character = self.Charaters[1];
    if(Tool:IsDescendantOf(Character))then
        return true;
    else
        return false;
    end
end;
--[=[]=]
function ClientBackpackProxy:SetToolEquipped(Tool:Tool,State:boolean)
    if(State == true)then
        local Human:Humanoid = self.Charaters[1]:WaitForChild("Humanoid");
        Human:EquipTool(Tool);
    else
        Tool.Parent = self.Backpacks[1];
    end;
end
--[=[
    Connects to the ToolBind and binds keys to the tool of the given index of the KeybindMap, Basically custom backpack.
    By Default, Request Handler will automatically equip and unequip on requests, you can override this behaviour by passing your own function handler. 
    @return Servant
]=]
function ClientBackpackProxy:BindKeysToList(KeybindMapping:{[number]:{[number]:Enum.KeyCode}},RequestsHandler:(TargetTool:Tool,InputObject:InputObject)->nil??)
    if(not self._List)then
        self._List = {};
    end;

    RequestsHandler = RequestsHandler or function(ToolObject:Tool,InputObject:InputObject)
        if(not self:HasToolEquipped(ToolObject))then
            self:SetToolEquipped(ToolObject, true);
        else
            self:SetToolEquipped(ToolObject, false);
        end
    end;

    return self:ToolBind(function(ToolObject:Tool)
        local BindId = "$lanzo-"..self.GUID.."@"..tostring(#self._List);
        table.insert(self._List, {
            BindId = BindId;
            LinkedTool = ToolObject;
        });
        ContextActionService:BindAction(BindId, function(Id:string,InputState:Enum.UserInputState,InputObject:InputObject)
            if(InputState == Enum.UserInputState.End)then
                RequestsHandler(ToolObject,InputObject);
            end;
        end, false, unpack(KeybindMapping[#self._List]))
        return function()
            local myCurrentIndex = self:GetIndexBasedOnBindId(BindId);
            local newList = {};
            ContextActionService:UnbindAction(BindId) --> Unbind self
            for i = myCurrentIndex,#self._List do
                local id = (self._List[i].BindId);
                --> We unbind the old ones, for e.g if #3 was removed, we bind #4 to #3 and #5 to #4 etc.
                ContextActionService:UnbindAction(id);
                --> Rebind to -1 index                
                local newID = "$lanzo-"..self.GUID.."@"..tostring(i-1);
                local newTool = self._List[i-1].LinkedTool;
                ContextActionService:BindAction(newID, function(NestedId:string,NestedInputState:Enum.UserInputState,NestedInputObject:InputObject)
                    if(NestedInputState == Enum.UserInputState.End)then
                        RequestsHandler(newTool,NestedInputObject);
                    end;
                end, false, unpack(KeybindMapping[i-1]));
                table.insert(newList, {
                    BindId = newID;
                    LinkedTool = self._List[i-1].LinkedTool;
                });
            end;
            self._List = nil;
            self._List = newList;
        end
    end)
end;
--[=[
    @return ClientBackpackProxy
]=]
function ClientBackpackService:ProxyBackpack(Player:Player?)
    Player = Player or game.Players.LocalPlayer;
    if(self.ProxyBackpacks[Player.UserId])then
        return self.ProxyBackpacks[Player.UserId];
    end
    local proxy = self:_GetAppModule():GetService("CustomClassService"):Create(ClientBackpackProxy,nil,{
        Player=Player,
        ToolTagName = self.ToolTagName,
        ClientBackpackService = self;
    });
    self.ProxyBackpacks[Player.UserId] = proxy;
    return proxy;
end;

--[=[]=]
function ClientBackpackService:GetToolOwner(Tool:Tool)
    if(Tool.Parent and Tool.Parent:IsA("Player"))then
        return Tool.Parent;
    elseif(Tool.Parent and Tool.Parent:IsA("Model") and Tool.Parent:FindFirstChild("Humanoid"))then
        return game.Players:GetPlayerFromCharacter(Tool.Parent);
    end
end

function ClientBackpackService:_Render()
    return {};
end

return ClientBackpackService;