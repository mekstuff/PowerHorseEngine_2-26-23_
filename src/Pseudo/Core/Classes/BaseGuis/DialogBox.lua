local Theme = require(script.Parent.Parent.Parent.Theme);

--[=[
    @class DialogBox
]=]
local DialogBox = {
    AutomaticSize = Enum.AutomaticSize.None,
    Name = "DialogBox",
    ClassName = "DialogBox",

    -- HorizontalAlignment = Enum.HorizontalAlignment.Left;

    BackgroundColor3 = Theme.getCurrentTheme().Text,
    BackgroundTransparency = 0,
    Roundness = UDim.new(0,10),

    SpeakerText = "Unknown",
    SpeakerTextColor3 = Theme.getCurrentTheme().Text,
    SpeakerTextSize = 16,
    SpeakerRichText = false,
    SpeakerSmartText = false,
    SpeakerRotation = 0,
    SpeakerFont = Theme.getCurrentTheme().Font,
    SpeakerBackgroundColor3 = Theme.getCurrentTheme().Background,
    SpeakerPaddingBottom = UDim.new(0,10),
    SpeakerPaddingLeft = UDim.new(0,10),
    SpeakerPaddingRight = UDim.new(0,10),
    SpeakerPaddingTop = UDim.new(0,10),
    SpeakerRoundness = UDim.new(0,10),
    
    ContentText = "Welcome to earth",
    ContentTextColor3 = Theme.getCurrentTheme().Background,
    ContentTextSize = 16,
    ContentFont = Theme.getCurrentTheme().Font,
    ContentRichText = false,
    ContentSmartText = false,

    Size = UDim2.fromOffset(300,100),

    OptionsVerticalAlignment = Enum.VerticalAlignment.Center,
    OptionsHorizontalAlignment = Enum.HorizontalAlignment.Right,
    OptionsFillDirection = Enum.FillDirection.Vertical;
    OptionsSortOrder = Enum.SortOrder.LayoutOrder;
    OptionsAnchorPoint = Vector2.new(1,1),
    OptionsPosition = UDim2.new(1,0,0,-10),
    Options = {}
};

DialogBox.__inherits = {"BaseGui"}

--[=[
    @prop Inherits BaseGui
    @within DialogBox
]=]
--[=[
    @prop SpeakerTextColor3 Color3
    @within DialogBox
]=]
--[=[
    @prop SpeakerTextSize number
    @within DialogBox
]=]
--[=[
    @prop SpeakerRichText boolean
    @within DialogBox
]=]
--[=[
    @prop SpeakerSmartText boolean
    @within DialogBox
]=]
--[=[
    @prop SpeakerRotation number
    @within DialogBox
]=]
--[=[
    @prop SpeakerFont Font
    @within DialogBox
]=]
--[=[
    @prop SpeakerBackgroundColor3 UDim
    @within DialogBox
]=]
--[=[
    @prop SpeakerPaddingLeft UDim
    @within DialogBox
]=]
--[=[
    @prop SpeakerPaddingRight UDim
    @within DialogBox
]=]
--[=[
    @prop SpeakerPaddingTop UDim
    @within DialogBox
]=]
--[=[
    @prop SpeakerRoundness UDim
    @within DialogBox
]=]
--[=[
    @prop ContentText string
    @within DialogBox
]=]
--[=[
    @prop ContentTextColor3 number
    @within DialogBox
]=]
--[=[
    @prop ContentTextSize Font
    @within DialogBox
]=]
--[=[
    @prop ContentFont boolean
    @within DialogBox
]=]
--[=[
    @prop ContentRichText boolean
    @within DialogBox
]=]
--[=[
    @prop ContentSmartText Enum.VerticalAlignment
    @within DialogBox
]=]
--[=[
    @prop OptionsVerticalAlignment Enum.HorizontalAlignment
    @within DialogBox
]=]
--[=[
    @prop OptionsHorizontalAlignment Enum.FillDirection
    @within DialogBox
]=]
--[=[
    @prop OptionsFillDirection Enum.SortOrder
    @within DialogBox
]=]
--[=[
    @prop OptionsAnchorPoint Vector2
    @within DialogBox
]=]
--[=[
    @prop OptionsPosition UDim2
    @within DialogBox
]=]
--[=[
    @prop Options {id:string, [any]:any}
    @within DialogBox
]=]


function DialogBox:_Render()
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");

    local Container = App.new("Frame");
    Container.BackgroundTransparency = 1;
    Container.Name = "Wrapper_$l";

    local OptionsWrapper = Instance.new("Frame", Container:GetGUIRef());
    OptionsWrapper.AnchorPoint = Vector2.new(1,1);
    OptionsWrapper.BackgroundTransparency = 1;
    OptionsWrapper.AutomaticSize = Enum.AutomaticSize.XY;
    local OptionsWrapperList = Instance.new("UIListLayout", OptionsWrapper);
    OptionsWrapperList.Padding = UDim.new(0,5);
    --[[
    local Lister = Instance.new("UIListLayout", Container:GetGUIRef());
    Lister.FillDirection = Enum.FillDirection.Vertical;
    Lister.Padding = UDim.new(0,-15);
    ]]
    
    local SpeakerContainer = App.new("Frame",Container);
    SpeakerContainer.Name = "SpeakerContainer";
    SpeakerContainer.Position = UDim2.new(0,10,0,0);
    SpeakerContainer.AnchorPoint = Vector2.new(0,.5);
    SpeakerContainer.Size = UDim2.new(0);
    SpeakerContainer.AutomaticSize = Enum.AutomaticSize.XY;
    SpeakerContainer.SupportsRBXUIBase = true;

    local Padding = Instance.new("UIPadding", SpeakerContainer:GetGUIRef());

    local SpeakerText = App.new("Text", SpeakerContainer);
    SpeakerText.Size = UDim2.new(0);
    SpeakerText.AutomaticSize = Enum.AutomaticSize.XY;
    SpeakerText.ZIndex = 2;

    local ContentContainer = App.new("Frame", Container);
    ContentContainer.SupportsRBXUIBase = true;
    -- ContentContainer.Size = UDim2.new(1);
    -- ContentContainer.AutomaticSize = Enum.AutomaticSize.Y;

    Container.Parent = self:GetRef();

    return function(Hooks:PseudoHooks)
        local useEffect,useComponents,useMapping = Hooks.useEffect, Hooks.useComponents,Hooks.useMapping

        -- useMapping({"HorizontalAlignment"},{Lister})

        useMapping({
            ["OptionsFillDirection"] = "FillDirection",
            ["OptionsHorizontalAlignment"] = "HorizontalAlignment",
            ["OptionsVerticalAlignment"] = "VerticalAlignment",
            ["OptionsSortOrder"] = "SortOrder",
        },{OptionsWrapperList});

        useMapping({
            ["OptionsPosition"] = "Position",
            ["OptionsAnchorPoint"] = "AnchorPoint",
        },{OptionsWrapper})


        useMapping({
            ["SpeakerPaddingBottom"] = "PaddingBottom",
            ["SpeakerPaddingTop"] = "PaddingTop",
            ["SpeakerPaddingLeft"] = "PaddingLeft",
            ["SpeakerPaddingRight"] = "PaddingRight",
        },{Padding})

        useMapping({
            "Position","Size","Visible","AnchorPoint"
        },{Container});

        useMapping({
            "BackgroundTransparency","BackgroundColor3","Roundness"
        },{ContentContainer});

        useEffect(function()
            if(self.AutomaticSize ~= Enum.AutomaticSize.Y)then
                ContentContainer.Size = UDim2.fromScale(1,1);
                ContentContainer.AutomaticSize = Enum.AutomaticSize.None;
            else
                ContentContainer.Size = UDim2.new(1);
                ContentContainer.AutomaticSize = Enum.AutomaticSize.Y;
            end;
        end,{"AutomaticSize"})

        local PreviousContentTextHook;

        --[=[
            @prop OptionClicked PHeSignal<Button,id>
        ]=]
        self:AddEventListener("OptionClicked",true)
        useEffect(function()
            for _,btnprops in pairs(self.Options) do
                if(btnprops.ButtonFlexSizing == nil)then
                    btnprops.ButtonFlexSizing = true;
                end;
                local btn = App.new("Button");
                for a,b in pairs(btnprops) do
                    if(a ~= "id")then
                        btn[a] = b;
                    end
                end;
                btn.MouseButton1Click:Connect(function()
                    self:GetEventListener("OptionClicked"):Fire(btn,btnprops.id)
                end)
                btn.Parent = OptionsWrapper;
                btn.SupportsRBXUIBase = true;
            end;
        end,{"Options"})

        useEffect(function()
            if(self.ContentText ~= "")then
                if(not PreviousContentTextHook)then
                    local DisplayContentText = App.new("Text");
                    DisplayContentText.TextWrapped = true;

                    PreviousContentTextHook = useMapping({
                        ["ContentText"] = "Text",
                        ["ContentTextColor3"] = "TextColor3",
                        ["ContentFont"] = "Font",
                        ["ContentTextSize"] = "TextSize",
                        ["ContentRichText"] = "RichText",
                        ["ContentSmartText"] = "SmartText",
                    },{DisplayContentText},true);

                    PreviousContentTextHook:Keep(useEffect(function()
                        if(self.AutomaticSize ~= Enum.AutomaticSize.Y)then
                            DisplayContentText.Size = UDim2.fromScale(1,1);
                            DisplayContentText.AutomaticSize = Enum.AutomaticSize.None;
                        else
                            DisplayContentText.Size = UDim2.new(1);
                            DisplayContentText.AutomaticSize = Enum.AutomaticSize.Y;
                        end;
                    end,{"AutomaticSize"}))

                    PreviousContentTextHook:Keep(DisplayContentText) --> So the text will be destroyed with the use effect hook
                    DisplayContentText.Parent = ContentContainer;
                 
                end
            else
                if(PreviousContentTextHook)then
                    PreviousContentTextHook:Destroy();
                    PreviousContentTextHook = nil;
                end
            end;
        end,{"ContentText"})
 
        useMapping({
            ["SpeakerText"] = "Text",
            ["SpeakerTextSize"] = "TextSize",
            ["SpeakerTextColor3"] = "TextColor3",
            ["SpeakerRichText"] = "RichText",
            ["SpeakerSmartText"] = "SmartText",
            ["SpeakerFont"] = "Font",
        }, {SpeakerText});
        
        useMapping({
            ["SpeakerBackgroundColor3"] = "BackgroundColor3",
            ["SpeakerRoundness"] = "Roundness",
            ["SpeakerRotation"] = "Rotation",
        }, {SpeakerContainer})
        
        useMapping({"ZIndex"},{Container})

        useEffect(function()
            SpeakerContainer.ZIndex = self.ZIndex+1;
            SpeakerText.ZIndex = SpeakerContainer.ZIndex+1;
        end,{"ZIndex"})
        -- useEffect(function()
        --     SpeakerText.Text = self.Text;
        -- end,{"SpeakerText"})

        useComponents({
            Container = Container;
            FatherComponent = Container:GetGUIRef();
        })
    end;
end

return DialogBox;