--[=[
    @class CurrencyDropIndicator
    You can pass Lost and Target as args and pass "TextProperties" arg to be applied to the text object
]=]
local CurrencyDropIndicator = {
    Name = "CurrencyDropIndicator";
    ClassName = "CurrencyDropIndicator";
    Lost = "0";
    Target = "**any";
};

--[=[
    @prop Lost number
    @within CurrencyDropIndicator
]=]
--[=[
    @prop Target Instance|Pseudo|nil
    @within CurrencyDropIndicator
]=]

local ignore = {
    "Parent",
    "Name",
    "Archivable",
    "Visible",
    "AnchorPoint",
    "Position",
    "Size"
}

function CurrencyDropIndicator:_Render()
    local App = self:_GetAppModule();
    local TweenService = App:GetService("TweenService");
    local TextItem = App.new("Text",self:GetRef());
    local Theme = App:GetGlobal("Theme");
    local args = self._dev.args;
    self.Lost = args and args.Lost or self.Lost;
    self.Target = args and args.Target or self.Target;

    if(self.Target:IsA("Pseudo") and self.Target:IsA("Text"))then
        for a,b in pairs(self.Target._getCurrentPropSheetState(true,true)) do
            if not(table.find(ignore,a))then
                TextItem[a] = b;
            end
        end
    end;

    if(args and args.TextProperties)then
        for a,b in pairs(args.TextProperties) do
            TextItem[a] = b;
        end;
    end
    return function(Hooks)
        local useEffect = Hooks.useEffect;
        local useComponents = Hooks.useComponents;

        useComponents({
            TextItem = TextItem;
        })

        useEffect(function()
            local asNumber = tonumber(self.Lost);
            if(asNumber)then
                TextItem.Text = asNumber > 0 and "+"..(self.Lost) or (self.Lost);
            end
            if(not args.TextProperties or not args.TextProperties.TextColor3)then
                if(asNumber)then
                    TextItem.TextColor3 = asNumber > 0 and Theme.getCurrentTheme().Success  or Theme.getCurrentTheme().Danger;
                end
            end;
            local AbsoluteStartPosition:Vector2 = self.Target:IsA("Pseudo") and self.Target:GetGUIRef().AbsolutePosition or self.Target.AbsolutePosition;
            local AbsoluteStartSize:Vector2 = self.Target:IsA("Pseudo") and self.Target:GetGUIRef().AbsoluteSize or self.Target.AbsoluteSize;
            local StartPosition:UDim2 = UDim2.fromOffset(AbsoluteStartPosition.X,AbsoluteStartPosition.Y);
            local StartSize:UDim2 = UDim2.fromOffset(AbsoluteStartSize.X,AbsoluteStartSize.Y);
            TextItem.Size = StartSize;
            TextItem.Position = StartPosition;
            local t = TweenService:Create(TextItem:GetGUIRef(), args.tweenInfo or TweenInfo.new(.65), {
                Position = args.EndPositon or UDim2.fromOffset(0,(asNumber > 0 and -40 or 40)) + TextItem.Position;
            });
            t:Play();
            t.Completed:Connect(function()
                self:Destroy();
            end);
        end,{"Lost"});

    end
end;

return CurrencyDropIndicator;