--[=[
    @class CurrencyIndicator

    Inherits [BaseGui]
]=]
local CurrencyIndicator = {
    Name = "CurrencyIndicator",
    ClassName = "CurrencyIndicator",
    VisibleLifetime = 5;
    AnimateNumbers = false;
    Position = UDim2.fromScale(0,0);
    AnchorPoint = Vector2.new(0);
    FormatToCommas = true;
    FormatToNumberAbbreviation = false;
    Text = "";
    MinimumRandom = 1;
    MaximumRandom = 10;
    Icon = "";
    ZIndex = 1;
    EntryTween = TweenInfo.new(.7,Enum.EasingStyle.Elastic);
    TweenInfo = TweenInfo.new(.4);
};
CurrencyIndicator.__inherits = {"BaseGui"};

--[=[
    @prop VisibleLifetime number
    @within CurrencyIndicator
]=]
--[=[
    @prop AnimateNumbers boolean
    @within CurrencyIndicator
]=]
--[=[
    @prop FormatToCommas boolean
    @within CurrencyIndicator
]=]
--[=[
    @prop FormatToNumberAbbreviation boolean
    @within CurrencyIndicator
]=]
--[=[
    @prop Text string
    @within CurrencyIndicator
]=]
--[=[
    @prop MinimumRandom number
    @within CurrencyIndicator
]=]
--[=[
    @prop MaximumRandom number
    @within CurrencyIndicator
]=]
--[=[
    @prop Icon string
    @within CurrencyIndicator
]=]
--[=[
    @prop EntryTween TweenInfo
    @within CurrencyIndicator
]=]
--[=[
    @prop TweenInfo TweenInfo
    @within CurrencyIndicator
]=]

--[=[]=]
function CurrencyIndicator:animText(v:number,default:number?)
    local TweenService = self:_GetAppModule():GetService("TweenService");
    local int = Instance.new("IntValue");
    int.Value = default or 0;
    local t = TweenService:Create(int, self.TweenInfo, {Value = v});
    t.Completed:Connect(function()
        t = nil;
        int:Destroy();
    end);
    t:Play();
    return int;
end


function CurrencyIndicator:_Render()
    local App = self:_GetAppModule();
    local Format = App:GetGlobal("Format");
    local TweenService = App:GetService("TweenService");
    local Container = App.new("Frame",self:GetRef());
    Container.BackgroundTransparency = 1;

    local List = Instance.new("UIListLayout");
    List.VerticalAlignment = Enum.VerticalAlignment.Center;
    List.Padding = UDim.new(0,5);
    List.FillDirection = Enum.FillDirection.Horizontal;
    List.Parent = Container:GetGUIRef();

    local Icon = App.new("Image")
    Icon.SupportsRBXUIBase = true;
    Icon.BackgroundTransparency = 1;
    Icon.Size = UDim2.fromOffset(25,25);
    Icon.Parent = Container;

    local Text = App.new("Text");
    Text.TextXAlignment = Enum.TextXAlignment.Left;
    Text.AutomaticSize = Enum.AutomaticSize.XY;
    Text.SupportsRBXUIBase = true;
    Text.TextStrokeColor3 = Color3.fromRGB(0,0,0);
    Text.TextStrokeTransparency = .35;
    Text.TextStrokeThickness = 2;
    Text.TextSize = 16;
    Text.Parent = Container;

    self.VisibleLifetime = self._dev.args or self.VisibleLifetime;
    
    local lastKnownNumberValue = 0;

    local VisibilityGained = self:AddEventListener("VisibilityGained",true);
    local VisibilityLost = self:AddEventListener("VisibilityLost",true);

    local function animateEntry()
        local op = math.random(1,2) == 1;
        local pos;
        if(op)then
            pos = self.Position + UDim2.fromOffset(math.random(self.MinimumRandom,self.MaximumRandom),math.random(self.MinimumRandom,self.MaximumRandom));
        else
            pos = self.Position - UDim2.fromOffset(math.random(self.MinimumRandom,self.MaximumRandom),math.random(self.MinimumRandom,self.MaximumRandom));
        end
        Container.Position = pos;
        Text:GetGUIRef().TextTransparency = 0;
        Container.Visible = true;
        TweenService:Create(Container:GetGUIRef(), self.EntryTween, {
            Position = self.Position
        }):Play();
    end;

    local function animateExit()
        if(self and self._dev)then
            local t = TweenService:Create(Text:GetGUIRef(), TweenInfo.new(.5), {
                TextTransparency = 1;
            });
            t.Completed:Connect(function(playbackState)
                if(playbackState == Enum.PlaybackState.Completed)then
                    Container.Visible = false;
                end;
            end);
            t:Play();
        end;
    end

    return function (hooks)
        local useComponents,useEffect,useMapping = hooks.useComponents,hooks.useEffect,hooks.useMapping;
        --> Components
        useComponents({
            Text = Text;
            Icon = Icon;
            FatherComponent = Container:GetGUIRef();
        });
        --> Maps
        useMapping({"AnchorPoint","Position"}, {Container});
        useMapping({"ZIndex"}, {Container,Text,Icon});

        --> Updates Icon
        useEffect(function()
            if(self.Icon == "")then
                Icon.Visible = false;
            else
                Icon.Image = self.Icon;
                Icon.Visible = true;
            end
        end, {"Icon"})

        --> Animation and Update Texts
        useEffect(function()
            local alreadyOverwritten = false;
            --> Doesn't make sense to animate empty string and icon

            -- if(self.Text == "" and self.Icon == "")then
            --     return function ()
            --         -- alreadyOverwritten = true;
            --     end
            -- end
            if not(Container.Visible)then
                VisibilityGained:Fire();
            end;
            animateEntry();
            --> Detect number
            local textIsNumber = self.AnimateNumbers and tonumber(self.Text:match("%d+",1)) or false;
            Text.Visible = true;
            --> For fading out, we do not fade out if another useEffect was triggered.
            task.delay(self.VisibleLifetime, function()
                if(not alreadyOverwritten)then
                    animateExit();
                    VisibilityLost:Fire(true);
                end;
            end)
            --> If is number, we should animate counting up or down
            if(textIsNumber)then
                local int = self:animText(textIsNumber,lastKnownNumberValue);
                int:GetPropertyChangedSignal("Value"):Connect(function()
                    local nt = self.Text:gsub("%d+",tostring(int.Value));
                    if(self.FormatToCommas)then
                        nt = Format(nt):toNumberCommas():End();
                    end;
                    if(self.FormatToNumberAbbreviation)then
                        nt = Format(nt):toNumberAbbreviation():End();
                    end
                    Text.Text = nt;
                end);
                lastKnownNumberValue = textIsNumber;
                return function ()
                    alreadyOverwritten = true;
                    if(int)then
                        int:Destroy();
                        int=nil;
                    end;
                end;
            else
                --> If it isn't a number then update as normal
                Container.Visible = true;
                Text.Text = self.Text;
                return function ()
                    alreadyOverwritten = true;
                end
            end
        end, {"Text"})
    end;
end;

return CurrencyIndicator;

--[[
return function(Icon:string,VisibleLifetime:number,TextSize:number|table?,IconSize:UDim2|table?):any|any
    local indicator = App.Create(CurrencyIndicator,nil,VisibleLifetime);
    -- if(Icon)then indicator.Icon = Icon;end;
    local IconComponent = indicator:GET("Icon");
    if(IconSize)then
        if(typeof(IconSize) == "table")then
            for a,b in pairs(IconSize) do
                IconComponent[a] = b;
            end
        else
            Icon.Size = IconSize;
        end;
    end;
    if(TextSize)then
        local Text = indicator:GET("Text");
        if(typeof(TextSize) == "table")then
            for a,b in pairs(TextSize) do
                Text[a] = b;
            end
        else
            Text.TextSize = TextSize;
        end
    end;
    return indicator,ui;
end;
]]