local Actives = {};

--[=[
    @class LocationIndicator
    You can pass every prop expect IndicatorClass as a arg .new("LocationIndicator",nil,{Text = "Initial"}) to overwrite default props and not 
    cause reanimations.
]=]
local LocationIndicator = {
    Name = "LocationIndicator";
    ClassName = "LocationIndicator";
    StartAnchorPoint = Vector2.new(.5);
    AnchorPoint = Vector2.new(.5,0);
    Position = UDim2.new(.5,0,0,5);
    StartPosition = UDim2.new(.5,0,-1,0);
    TweenInfo = TweenInfo.new(1,Enum.EasingStyle.Cubic);
    Text = "Location Indicator!";
    Lifetime = -1;
    IndicatorClass = "default";
};
--[=[
    @prop StartAnchorPoint Vector2
    @within LocationIndicator
]=]
--[=[
    @prop AnchorPoint Vector2
    @within LocationIndicator
]=]
--[=[
    @prop Position UDim2
    @within LocationIndicator
]=]
--[=[
    @prop StartPosition UDim2
    @within LocationIndicator
]=]
--[=[
    @prop TweenInfo TweenInfo
    @within LocationIndicator
]=]
--[=[
    @prop Text string
    @within LocationIndicator
]=]
--[=[
    @prop Lifetime number
    @within LocationIndicator
    Defaults to -1, this means it'll stay until you destroy manually.
]=]
--[=[
    @prop IndicatorClass string
    @within LocationIndicator
]=]

function LocationIndicator:Destroy()
    local App = self:_GetAppModule();
    local TweenService = App:GetService("TweenService");
    local Text = self:GET("Text");
    local myClass = self.IndicatorClass;
    if(Actives[myClass] == self)then
        Actives[myClass] = nil;
    end;
    local t = TweenService:Create(Text:GetGUIRef(),self.TweenInfo, {
        Position = self.StartPosition;
        AnchorPoint = self.StartAnchorPoint;
    });
    t:Play();
    task.spawn(function()
        t.Completed:Wait();
        self:GetRef():Destroy();
    end)
end

function LocationIndicator:_Render()
    local App = self:_GetAppModule();
    local TweenService = App:GetService("TweenService");
    local Text = App.new("Text");
    Text.TextStrokeTransparency = .4;
    Text.TextSize = 35;

    local args = self._dev.args;

    self.Position = args and args.Position or self.Position;
    self.AnchorPoint = args and args.AnchorPoint or self.AnchorPoint;
    self.StartPosition = args and args.StartPosition or self.StartPosition;
    self.StartAnchorPoint = args and args.StartAnchorPoint or self.StartAnchorPoint;
    self.TweenInfo = args and args.TweenInfo or self.TweenInfo;
    self.Lifetime = args and args.Lifetime or self.Lifetime;
    self.Text = args and args.Text or self.Text;

    Text.Text = self.Text

    Text.Parent = self:GetRef();

    return function (hooks)
        local useEffect,useComponents = hooks.useEffect,hooks.useComponents;
        local Initiated = false;

        useComponents({
            Text = Text;
        });

        useEffect(function()
            if(self:GetRef():FindFirstAncestorOfClass("DataModel"))then
                if(not Initiated)then
                    if(self.Lifetime ~= -1)then
                        Initiated = true;
                        task.delay(self.Lifetime,function()
                            self:Destroy();
                        end);
                    end
                end
            end;
        end, {"Parent","Lifetime"})

        useEffect(function()
            Text.AnchorPoint = self.StartAnchorPoint;
            Text.Position = self.StartPosition;
            local t = TweenService:Create(Text:GetGUIRef(),self.TweenInfo, {
                Position = self.Position;
                AnchorPoint = self.AnchorPoint;
            });
            t:Play();
        end, {"StartAnchorPoint","AnchorPoint","Position","StartPosition"})
    end;
end;

return LocationIndicator;

--[[
return function(Text:string|table?,Info:table?) -- Position:UDim2?,AnchorPoint:Vector2?,Lifetime:number?,StartPosition:UDim2?,StartAnchorPoint:UDim2?)
    Info = Info or {};
    local Class = Info.Class or "default";
    local Active = Actives[Class];
    if(Active)then
        Active:Destroy();
        Actives[Class] = nil;
    end;
    local Indicator = CustomClassService:Create(LocationIndicator,nil, {
        Text = typeof(Text) == "string" and Text,
        Position = Info.Position,
        AnchorPoint = Info.AnchorPoint,
        StartPosition = Info.StartPosition,
        StartAnchorPoint = Info.StartAnchorPoint,
        Class = Class;
    });

    if(type(Text) == "table")then
        for p,v in pairs(Text) do
            Indicator:GET("Text")[p]=v;
        end
    end;

    Actives[Class] = Indicator;

    if(Info.Lifetime)then
        task.delay(Info.Lifetime, function()
            if(Indicator and Indicator._dev)then
                Indicator:Destroy();
            end;
        end)
    end

    return Indicator;
end;
]]