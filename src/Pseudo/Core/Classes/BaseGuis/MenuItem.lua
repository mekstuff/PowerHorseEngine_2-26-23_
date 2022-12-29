local Theme = require(script.Parent.Parent.Parent.Theme);
--[=[
    @class MenuItem
]=]
local MenuItem = {
    Name = "MenuItem";
    ClassName = "MenuItem",
    RightSlotIcon = "",
    BackgroundColor3 = Theme.getCurrentTheme().Primary;
    HoverColorEffect = false;
    HoverColor3 = Theme.getCurrentTheme().Secondary;
    HoverColorTweenInfo = TweenInfo.new(.2);
};

--[=[
    @prop RightSlotIcon string
    @within MenuItem
]=]
--[=[
    @prop HoverColorEffect boolean
    @within MenuItem
]=]
--[=[
    @prop HoverColor3 Color3
    @within MenuItem
]=]
--[=[
    @prop HoverColorTweenInfo TweenInfo
    @within MenuItem
]=]


MenuItem.__inherits = {"BaseGui", "Button", "Text", "Frame","GUI"};

function MenuItem:_Render()
    local App = self:_GetAppModule();
    local TweenService = App:GetService("TweenService");
    local Container = App.new("Frame", self:GetRef());
    local MenuButton = App.new("Button", Container);
    self:AddEventListener("MouseButton1Down",true,MenuButton:GetEventListener("MouseButton1Down"));
    self:AddEventListener("MouseButton2Down",true,MenuButton:GetEventListener("MouseButton2Down"));
    self:AddEventListener("MouseButton1Up",true,MenuButton:GetEventListener("MouseButton1Up"));
    self:AddEventListener("MouseButton2Up",true,MenuButton:GetEventListener("MouseButton2Up"));
    self:AddEventListener("MouseButton1Click",true,MenuButton:GetEventListener("MouseButton1Click"));
    self:AddEventListener("MouseButton2Click",true,MenuButton:GetEventListener("MouseButton2Click"));
    self:AddEventListener("MouseEnter",true,MenuButton:GetEventListener("MouseEnter"));
    self:AddEventListener("MouseLeave",true,MenuButton:GetEventListener("MouseLeave"));
    -- self:AddEventListener("InputBegan",true,MenuButton:GetEventListener("InputBegan"));
    -- self:AddEventListener("InputEnded",true,MenuButton:GetEventListener("InputEnded"));
    MenuButton.BackgroundTransparency = 1;
    local RightSlotIcon = App.new("Image", Container);
    RightSlotIcon.BackgroundTransparency = 1;
    RightSlotIcon.Size = UDim2.new(0,0,.5,0);
    RightSlotIcon.AnchorPoint = Vector2.new(1,.5);
    RightSlotIcon.Position = UDim2.new(1,-10,.5,0);
    local AspectRatioConstaint = Instance.new("UIAspectRatioConstraint",RightSlotIcon:GetGUIRef());
    AspectRatioConstaint.AspectType = Enum.AspectType.ScaleWithParentSize;
    AspectRatioConstaint.DominantAxis = Enum.DominantAxis.Height;
    MenuButton.Size = UDim2.fromScale(1,1);
    return function(Hooks:PseudoHooks)
        local useComponents,useEffect,useMapping = Hooks.useComponents,Hooks.useEffect,Hooks.useMapping;

        useMapping({"Icon","Text","TextSize"
        ,"TextColor3","TextTransparency","TextAdjustment","IconAdjustment","Font","ZIndex","RippleStyle","Disabled",
    "IconSize","IconAdaptsTextColor","IconColor3"}, {MenuButton});
        useMapping({"BackgroundTransparency","Size","Position"
        ,"AnchorPoint","StrokeTransparency","StrokeThickness","StrokeColor3","ZIndex","Roundness","Visible"}, {Container});
        useEffect(function()
           Container.Size = self.Size;
        end, {"Size"});
        useEffect(function()
            RightSlotIcon.Image = self.RightSlotIcon;
        end, {"RightSlotIcon"});

        useEffect(function()
            if(not self.HoverColorEffect)then
                Container.BackgroundColor3 = self.BackgroundColor3;
            end
        end,{"BackgroundColor3"})

        useEffect(function()
            if(self.HoverColorEffect)then
                Container.BackgroundColor3 = self.BackgroundColor3;
                local MouseEnter,MouseLeave;
                MouseEnter = self.MouseEnter:Connect(function()
                    TweenService:Create(Container:GetGUIRef(), self.HoverColorTweenInfo, {
                        BackgroundColor3 = self.HoverColor3;
                    }):Play();
                end);
                MouseLeave = self.MouseLeave:Connect(function()
                    TweenService:Create(Container:GetGUIRef(), self.HoverColorTweenInfo, {
                        BackgroundColor3 = self.BackgroundColor3;
                    }):Play();
                end);
                return function()
                    MouseEnter:Disconnect();
                    MouseLeave:Disconnect();
                end;
            else
                Container.BackgroundColor3 = self.BackgroundColor3;
            end
        end, {"HoverColorEffect"})

        useComponents({
            FatherComponent = Container:GetGUIRef();
        })
    end
end;

return MenuItem;