--[=[
    @class PathComputingService
    @tag Service
]=]
local PathComputingService = {};

local PathfindingService = game:GetService("PathfindingService");
local TweenService = game:GetService("TweenService")
local CustomClassService = require(script.Parent.Parent.Providers.ServiceProvider):LoadServiceAsync("CustomClassService");
--[=[
    @class ComputedPath
]=]
local ComputedPath = {
    Name = "ComputedPath",
    ClassName = "ComputedPath",
    DebugVisualization = false,
    DebugComputationInfo = {},
    AutoMoveToDestination = false,
    Destination = "**Instance|CFrame|Vector3|nil",
    AutoMoveAgent = true,
    Agent = "**Instance|nil",
    AgentRadius = 2,
    AgentHeight = 5,
    AgentCanJump = true,
    AgentCanClimb = false,
    WaypointSpacing = 4,
    Costs = "**table|nil",
    AgentTweenInfo = TweenInfo.new(.1,Enum.EasingStyle.Linear);
};
--[=[
    @prop DebugVisualization boolean
    @within ComputedPath
]=]
--[=[
    @prop DebugComputationInfo {}
    @private
    @within ComputedPath
]=]
--[=[
    @prop AutoMoveAgent boolean
    @within ComputedPath
]=]
--[=[
    @prop Destination Instance|CFrame|Vector3|nil
    @within ComputedPath
]=]
--[=[
    @prop AutoMoveAgent boolean
    @within ComputedPath
]=]
--[=[
    @prop Agent Instance|nil
    @within ComputedPath
]=]
--[=[
    @prop AgentRadius number
    @within ComputedPath
]=]
--[=[
    @prop AgentHeight number
    @within ComputedPath
]=]
--[=[
    @prop AgentCanJump boolean
    @within ComputedPath
]=]
--[=[
    @prop AgentCanClimb boolean
    @within ComputedPath
]=]
--[=[
    @prop WaypointSpacing number
    @within ComputedPath
]=]
--[=[
    @prop Costs {}|nil
    @within ComputedPath
]=]


--[=[
    @private
]=]
function ComputedPath:_getAgentPrimaryPart()
    return self.Agent:IsA("Model") and (self.Agent.PrimaryPart or self.Agent:FindFirstChildWhichIsA("BasePart")) or self.Agent;
end;

--[=[
    @private
]=]
function ComputedPath:_getAgentPrimaryPartPosition()
    return PathComputingService:_getVector3FromItem(self.Agent);
end

--[=[
    @private
]=]
function ComputedPath:_getDestinationVector()
    return PathComputingService:_getVector3FromItem(self.Destination);
end;

--[=[]=]
function ComputedPath:GetAgentHumanoid()
    return self.Agent:FindFirstChildWhichIsA("Humanoid");
end
--[=[]=]
function ComputedPath:GetReachedConnection()
    local AgentHumanoid = self:GetAgentHumanoid();
    if(AgentHumanoid)then
        return AgentHumanoid.MoveToFinished;
    else
        return self._dev.AgentTween.Completed;
    end;
end;

--[=[]=]
function ComputedPath:DoMoveToAgent(pos:Vector3)
    if(self._dev.AgentTween)then
        self._dev.AgentTween:Destroy();
        self._dev.AgentTween = nil;
    end
    local AgentHumanoid = self:GetAgentHumanoid();
    if(AgentHumanoid)then
        AgentHumanoid:MoveTo(pos);
    else
        local ActiveTween = TweenService:Create(self:_getAgentPrimaryPart(), self.AgentTweenInfo, {
            Position = pos;
        });
        self._dev.AgentTween = ActiveTween;
        ActiveTween:Play();
    end
end

--[=[]=]
function ComputedPath:Compute()
    local path = self._dev.mainPath;
    local s,r = pcall(function()
        path:ComputeAsync(self:_getAgentPrimaryPartPosition(),self:_getDestinationVector())
    end);

    if(self._dev.reachedConnection)then
        self._dev.reachedConnection:Disconnect();
        self._dev.reachedConnection = nil;
    end
    if(self._dev.blockedConnection)then
        self._dev.blockedConnection:Disconnect();
        self._dev.blockedConnection = nil;
    end

    if(s and path.Status == Enum.PathStatus.Success) then
        local waypoints = path:GetWaypoints();
        self.DebugComputationInfo = waypoints;
        
        self._dev.blockedConnection = path.Blocked:Connect(function(blockedWaypointIdx)
            if(blockedWaypointIdx >= self._nextWaypointIndex)then
                self:GetEventListener("Blocked"):Fire(blockedWaypointIdx);
                self._dev.blockedConnection:Disconnect();
                -- self:Compute();
            end
        end);

        self._nextWaypointIndex = 2;
        self:DoMoveToAgent(waypoints[self._nextWaypointIndex].Position);

        if(not self._dev.reachedConnection)then
            self._dev.reachedConnection = self:GetReachedConnection():Connect(function(reached)
                if(reached and self._nextWaypointIndex < #waypoints-1) then
                    self._nextWaypointIndex+=1;
                    self:DoMoveToAgent(waypoints[self._nextWaypointIndex].Position);
                    self:GetEventListener("WaypointReached"):Fire(reached);
                else
                    self._dev.reachedConnection:Disconnect();
                    self._dev.blockedConnection:Disconnect();
                    self:GetEventListener("Completed"):Fire(reached);
                end
            end)
        end;
    else
        self:GetEventListener("Failed"):Fire(r);
    end

end;


function ComputedPath:_Render()
    --[=[
        @prop Completed PHeSignal
        @within ComputedPath
    ]=]
    self:AddEventListener("Completed", true);
    --[=[
        @prop WaypointReached PHeSignal<PathWaypoint>
        @within ComputedPath
    ]=]
    self:AddEventListener("WaypointReached", true);
    --[=[
        @prop Blocked PHeSignal
        @within ComputedPath
    ]=]
    self:AddEventListener("Blocked", true);
    --[=[
        @prop Failed PHeSignal
        @within ComputedPath
    ]=]
    self:AddEventListener("Failed", true);

    self:_lockProperty("Agent","Agent cannot be set after initial render");

    return function(Hooks:PseudoHooks)
        local useEffect = Hooks.useEffect;

        useEffect(function()
            if(self.Destination and self.AutoMoveToDestination)then
                self:Compute();
            end;
            if(not self.Destination)then
                self.DebugComputationInfo = {};
                if(self._dev.reachedConnection)then
                    self._dev.reachedConnection:Disconnect();
                    self._dev.reachedConnection = nil;
                end
                if(self._dev.blockedConnection)then
                    self._dev.blockedConnection:Disconnect();
                    self._dev.blockedConnection = nil;
                end
            end
        end,{"Destination"})

        useEffect(function()
            if(self.DebugVisualization)then
                local debugFolder = Instance.new("Folder");
                debugFolder.Name = self.Name.."->DebugVisualization->"..self.__id;
                debugFolder.Parent = workspace;
                local debugColor = BrickColor.random();
                local debugSelectionBox = Instance.new("SelectionBox",debugFolder);
                debugSelectionBox.Color3 = debugColor.Color;
                debugSelectionBox.SurfaceColor3 = debugSelectionBox.Color3;
                debugSelectionBox.SurfaceTransparency = .7;
                debugSelectionBox.Adornee = self.Agent;
                for _,x in pairs(self.DebugComputationInfo) do
                    local debugPart = Instance.new("Part");
                    debugPart.BrickColor = debugColor;
                    debugPart.Transparency = .5;
                    debugPart.Material = Enum.Material.SmoothPlastic;
                    debugPart.Position = x.Position;
                    debugPart.Anchored = true;
                    debugPart.CanCollide = false;
                    debugPart.Size = Vector3.new(1,1,1)
                    debugPart.Parent = debugFolder;
                end;
                return function ()
                    debugFolder:Destroy();
                end
            end
        end,{"DebugComputationInfo","DebugVisualization"})

        useEffect(function()
            if(self._dev.mainPath)then
                self._dev.mainPath:Destroy();
            end
            self._dev.mainPath = PathfindingService:CreatePath({
                AgentRadius = self.AgentRadius,
                AgentHeight = self.AgentHeight,
                AgentCanJump = self.AgentCanJump,
                AgentCanClimb = self.AgentCanClimb,
                Costs = self.Costs;
            });
        end,{"AgentRadius","AgentHeight","AgentCanJump","AgentCanClimb","Costs"})
    end;
end


--//PathComputingService

--[=[]=]
function PathComputingService:_getVector3FromItem(Item:Instance|Model|CFrame|Vector3)
    if(typeof(Item) == "Instance")then
        if(Item:IsA("Model"))then
            return Item.PrimaryPart and Item.PrimaryPart.Position or Item:FindFirstChildWhichIsA("BasePart").Position;
        else
            return Item.Position;
        end;
    elseif(typeof(Item) == "CFrame")then
        return Item.Position;
    end
    return Item;
end
--[=[]=]
function PathComputingService.new(Agent:Instance,Destination:Instance|CFrame|Vector3?)
    return CustomClassService:Create(ComputedPath,nil,nil, {
        Agent = Agent,
        Destination = Destination,
    });
end;

--[=[
    Calculates the nearest vector from the list of destinations
]=]
function PathComputingService:CalculateNearestDestination(Agent:Instance|CFrame|Vector3,Destinations:{Instance|Model|CFrame|Vector3}):(Instance|Model|CFrame|Vector3|nil,number?)
    local AgentVector3 = self:_getVector3FromItem(Agent);
    local lowestmag,currt;
    for _,v in pairs(Destinations) do
        local pos = self:_getVector3FromItem(v);
        if( (AgentVector3 - pos).Magnitude < (lowestmag or math.huge))then
            lowestmag = (AgentVector3 - pos).Magnitude;
            currt = v;
        end
    end;
    return currt,lowestmag;
end

return PathComputingService;