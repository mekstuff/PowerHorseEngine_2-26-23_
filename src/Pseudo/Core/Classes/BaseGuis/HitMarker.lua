--[=[
    @class HitMarker
]=]

local HitMarker = {
    Name = "HitMarker",
    ClassName = "HitMakrer",
    SoundProps = {
        SoundId = "",
        SoundVolume = 1,
    },
    Lifetime = .3,
    Position = UDim2.fromScale(.5,.5),
    AnchorPoint = Vector2.new(.5,.5),
    HitMarkerType = "default",
    HitMarkerImage = "http://www.roblox.com/asset/?id=8797893157",
    Target = "**Instance",
    Size = UDim2.fromOffset(20,20),
};

HitMarker.__inherits = {"BaseGui"};

--[=[
    @prop SoundProps {}
    @within HitMarker
]=]
--[=[
    @prop SoundProps.SoundId string
    @within HitMarker
]=]
--[=[
    @prop SoundProps.SoundVolume number
    @within HitMarker
]=]
--[=[
    @prop Lifetime number
    @within HitMarker
    Set to -1 for infinite lifetime.
]=]
--[=[
    @prop HitMarkerType string
    @within HitMarker
    "default"
]=]
--[=[
    @prop HitMarkerImage string
    @within HitMarker
]=]
--[=[
    @prop Target Instance?
    @within HitMarker
]=]

--[=[]=]
function HitMarker:GetTargetPositionRelativeToCamera(Target:BasePart|Model|Instance?):UDim2
    local ErrorService = self:_GetAppModule():GetService("ErrorService");
    Target = Target or self.Target;
    ErrorService.assert(Target, ("Target (Instance,Model,BasePart) Expected From :GetTargetRelativeToCamera, Got %s"):format(typeof(Target)))
    local Cam = workspace.CurrentCamera;
    local TargetPosition:Vector3;
    if(Target:IsA("BasePart"))then
        TargetPosition = Target.Position;
    elseif(Target:IsA("Model"))then
        TargetPosition = Target.PrimaryPart.Position;
    end;
    ErrorService.assert(TargetPosition, ("Could not determine a target position from GetTargetPositionRelativeToCamera on %s, If item is a model, make sure it has a primary part"):format(tostring(Target)));
    local t = Cam:WorldToViewportPoint(TargetPosition);
    return UDim2.fromOffset(t.X,t.Y);
end;

--[=[
    @private

    Called whenever the hitmarker is descendant of datamodel
]=]
function HitMarker:_Initiate(Hooks:PseudoHooks)
    local App = self:_GetAppModule();
    self:_lockProperties("SoundProps","Lifetime","HitMarkerType")
    if(self.SoundProps.SoundId ~= "")then
        local AudioService:AudioService = App:GetService("AudioService");
        local SE = AudioService:CreateSoundEffectsChannel():AddAudio("$lanzo@HitMarkerClass-SoundEffect",self.SoundProps.SoundId, self.SoundProps.SoundVolume, false, true, true);
        SE:Play();
        --> Find a way to destroy or something
    end;

    local ObjectContainer = App.new("Frame",self:GetRef());
    ObjectContainer.BackgroundTransparency = 1;
    Hooks.useMapping({"Position","AnchorPoint","Size"}, {ObjectContainer});

    if(self.HitMarkerType == "default")then
        local HitMarkerImage = App.new("Image",ObjectContainer);
        HitMarkerImage.Size = UDim2.fromScale(1,1);
        HitMarkerImage.BackgroundTransparency = 1;
        HitMarkerImage.ScaleType = Enum.ScaleType.Fit;
        HitMarkerImage.Image = self.HitMarkerImage;
    end;
    Hooks.useEffect(function()
        if(self.Target)then
            local Connection = game:GetService("RunService").Heartbeat:Connect(function()
                self.Position = self:GetTargetPositionRelativeToCamera();
            end);
            self._dev["HeartbeatConnection"] = Connection;
            return function ()
                Connection:Disconnect();
                self._dev["HeartbeatConnection"] = nil;
            end
        end
    end, {"Target"})

    Hooks.useComponents({
        ObjectContainer = ObjectContainer;
    });

    if(self.Lifetime ~= -1)then
        task.delay(self.Lifetime, function()
            self:Destroy();
        end)
    end;

end;

function HitMarker:Destroy()
    print("Do Whatever Animation");
    self:GetRef():Destroy();
end

function HitMarker:_Render()
    local Initiated = false;
    return function(Hooks:PseudoHooks)
        Hooks.useEffect(function()
            if(self:GetRef():FindFirstAncestorOfClass("DataModel"))then
                if(not Initiated)then
                    self:_Initiate(Hooks);
                    Initiated = true;
                end
            end;
        end, {"Parent"})
    end;
end;

return HitMarker;