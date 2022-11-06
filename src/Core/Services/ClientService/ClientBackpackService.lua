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
function ClientBackpackService:GetTools(Player:Player,existingTable:table?)
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
    
    @return Servant -- Collector Binded Connection.
    Useful for creating custom backpack systems
]=]
function ClientBackpackProxy:ToolBind(BindHandler:any)
    local Collector = self:_GetAppModule():Import("Collector");
    return Collector:Bind(self._toolbindtag,BindHandler)
end;
--[=[]=]
function ClientBackpackProxy:GetTools():table
    local Collector = self:_GetAppModule():Import("Collector");
    return Collector:GetTagged(self._toolbindtag);
end
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