--[=[
    @class ClientBackpackService
    @tag ClientService
]=]
local ClientBackpackService = {
    Name = "ClientBackpackService",
    ClassName = "ClientBackpackService",
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
end

--[=[
    @class ClientBackpackServiceTool
]=]
local ClientBackpackServiceTool = {
    Name = "ClientBackpackServiceTool";
    NameClass = "ClientBackpackServiceTool";
}

function ClientBackpackServiceTool:_Render()
    
end;

--[=[]=]
function ClientBackpackService:OnToolAdded(Player:Player)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    local SignalProvider = App:GetProvider("SignalProvider");
    Player = Player or game.Players.LocalPlayer;
    ErrorService.assert(("[$SCRIPT_NAME] Player expected got %s"):format(typeof(Player)));
    if(not self._dev._tools[Player.UserId])then
        
    end;
    self._dev._tools[Player.UserId] = self._dev._tools[Player.UserId] or {
        Tools = {};
        OnToolAddedEvent = SignalProvider.new("ToolAdded-"..Player.Name);
        OnToolRemoved = SignalProvider.new("ToolRemoved-"..Player.Name);
    };
    local Tools = self._dev._tools[Player.UserId].Tools;
end;

--[=[]=]
function ClientBackpackService:OnToolRemoved(Player:Player)
    local App = self:_GetAppModule();
    local SignalProvider = App:GetProvider("SignalProvider");
    self._dev._tools[Player.UserId] = self._dev._tools[Player.UserId] or {
        Tools = {};
        OnToolAddedEvent = SignalProvider.new("ToolAdded-"..Player.Name);
        OnToolRemoved = SignalProvider.new("ToolRemoved-"..Player.Name);
    };
end

function ClientBackpackService:_Render()
    return {};
end

return ClientBackpackService;