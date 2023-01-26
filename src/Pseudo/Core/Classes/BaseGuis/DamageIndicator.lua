
--[=[
    @class DamageIndicator
    Original was apart of LanzoUiMaterial, now is a native component.

    Inherits [BaseGui]
]=]
local DamageIndicator = {
    Name = "DamageIndicator",
    ClassName = "DamageIndicator",
    Damage = "**any",
    Origin = "**any",
    TextColor3 = "**any",
    TextSize = 35,
    Lifetime = .1,
    PositionOffset = UDim2.fromOffset(0,0);
    PopoutTweenInfo = TweenInfo.new(.7,Enum.EasingStyle.Elastic);
};

DamageIndicator.__inherits = {"BaseGui"}

--[=[
    @prop Damage number|string
    @within DamageIndicator
]=]
--[=[
    @prop Origin UDim2|Vector3|Instance|CFrame
    @within DamageIndicator
]=]
--[=[
    @prop TextColor3 Color3|{}
    @within DamageIndicator
]=]
--[=[
    @prop TextSize number
    @within DamageIndicator
]=]
--[=[
    @prop Lifetime number
    @within DamageIndicator
]=]
--[=[
    @prop PositionOffset UDim2
    @within DamageIndicator
]=]
--[=[
    @prop PopoutTweenInfo TweenInfo
    @within DamageIndicator
]=]

function DamageIndicator:Destroy()
    local App = self:_GetAppModule();
    local TweenService = App:GetService("TweenService");
    local Text = self:GET("Text");
    local transparentTween = TweenService:Create(Text, TweenInfo.new(.2), {
        TextTransparency = 1;
        TextStrokeTransparency = 1;
    });
    transparentTween.Completed:Connect(function()
        self:GetRef():Destroy();
    end)
    transparentTween:Play();
end

--[=[]=]
function DamageIndicator:_Initiate(Hooks:PseudoHooks)
    local App = self:_GetAppModule();
    local TweenService = App:GetService("TweenService");
    local ErrorService = App:GetService("ErrorService");

    local Origin = self.Origin;
    local Damage = self.Damage;
    local TextColor3 =  self.TextColor3;
    local PositionOffset = self.PositionOffset;
    local PopoutTweenInfo = self.PopoutTweenInfo;

    --> We only use UDim2 Value for origin, but other types will be converted to UDim2
    --> Convert Instances To Vector3
    if(typeof(Origin) == "Instance")then
        if(Origin:IsA("BasePart"))then
            Origin = Origin.Position;
        elseif(Origin:IsA("Model"))then
            Origin = Origin.PrimaryPart and Origin.PrimaryPart.Position or Origin:FindFirstChildWhichIsA("BasePart",true).Position;
        end;
    --> Convert CFrame to Vector3
    elseif(typeof(Origin) == "CFrame")then
        Origin = Vector3.new(Origin.X,Origin.Y,Origin.Z);
    end;

    --> Convert That Vector3 Into UDim2
    if(typeof(Origin) == "Vector3")then
        local WTSP = workspace.CurrentCamera:WorldToScreenPoint(Origin);
        Origin = UDim2.fromOffset(WTSP.X,WTSP.Y);
    end;

    if(typeof(Origin) ~= "UDim2")then
        ErrorService.tossError("Failed trying to create DamageIndicator because the given origin is not supported. Origins can only be UDim2, Vector3, Instance or CFrame");
    end;

    local Text = App.new("Text");
    Text.Text = tostring(Damage) or "???";
    Text.TextSize = self.TextSize;
    Text.Rotation = 90;
    Text.TextStrokeTransparency = .2;
    Text.Position = Origin;

    if(typeof(TextColor3) == "table")then
        for p,v in pairs(TextColor3) do
            Text[p] = v;
        end;
    elseif(typeof(TextColor3) == "Color3")then
        Text.TextColor3 = TextColor3;
    end;

    PositionOffset = PositionOffset or UDim2.fromOffset(math.random(-50,50),math.random(-50,50))

    local pt = TweenService:Create(Text:GetGUIRef(),PopoutTweenInfo or _PopoutTweenInfo,{
        Position = Origin - PositionOffset;
        Rotation = 0;
    });
    pt.Completed:Connect(function()
        if(self.Lifetime == -1)then
            return;
        end;
        task.wait(self.Lifetime);
        self:Destroy();
    end)

    pt:Play();

    Hooks.useComponents({
        FatherComponent = Text:GetGUIRef();
        Text = Text;
    });

    Text.Parent = self:GetRef();

    return Text
end;

function DamageIndicator:_Render()
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

return DamageIndicator
