--[=[
    @class DatePicker
]=]
local DatePicker = {
    Name = "DatePicker",
    ClassName = "DatePicker",
    Month = 1,
    Year = 2022,
    Size = UDim2.fromOffset(300,120);
};

--[=[
    @prop Month number
    @within DatePicker
]=]
--[=[
    @prop Year number
    @within DatePicker
]=]

DatePicker.__inherits = {"BaseGui","GUI"}

local SupportedMonths = {
    "January","Febuary","March","April","May","June","July","August","September","October","November","December"
};

local DaysOfTheWeek = {
    "Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"
}

function DatePicker:_Render(App)
    local Container = App.new("Frame", self:GetRef());
    local TextSlider = App.new("TextSlider",Container);
    TextSlider.Size = UDim2.new(1,0,0,30);
    local Content = App.new("Frame",Container);
    Content.Position = UDim2.fromOffset(0,TextSlider.Size.Y.Offset);
    Content.Size = UDim2.new(1,0,1,-TextSlider.Size.Y.Offset);
    Content.BackgroundColor3 = Color3.fromRGB(255);

    local ContentGrid = Instance.new("UIGridLayout", Content:GetGUIRef());
    ContentGrid.CellPadding = UDim2.fromOffset(5);
    ContentGrid.CellSize = UDim2.new(1/#DaysOfTheWeek,-ContentGrid.CellPadding.X.Offset,1)

    for i,v in pairs(DaysOfTheWeek) do
        local Section = App.new("Frame",Content);
        Section.Name = tostring(i);
        Section.SupportsRBXUIBase = true;
        Section.BackgroundColor3 = BrickColor.random().Color;
        local Lister = Instance.new("UIListLayout", Section:GetGUIRef());
        Lister.Padding = UDim.new(0,3);
        Lister.SortOrder = Enum.SortOrder.LayoutOrder;
        Lister.HorizontalAlignment = Enum.HorizontalAlignment.Center;
        local Header = App.new("Text");
        Header.Text = v:sub(1,3);
        Header.SupportsRBXUIBase = true;
        Header.Parent = Section;
    end

    TextSlider.SelectionChanged:Connect(function(txt,txtObject,id)
        -- txtObject.Text = txtObject.Text.." 2021";
        for i = 1,30 do
            local DayButton = App.new("Button");
            DayButton.ButtonFlexSizing = false;
            DayButton.Text = tostring(i);
            DayButton.Size = UDim2.new(1,0,0,30);
            DayButton.SupportsRBXUIBase = true;
            Instance.new("UIAspectRatioConstraint", DayButton:GetGUIRef())
            local dayNum:number = i%7 == 0 and 7 or i%7;
    
            DayButton.Parent = (Content:FindFirstChild(tostring(dayNum)))
        end;
    end);


    for _,v in pairs(SupportedMonths) do
        TextSlider:AddText(v);
    end;

    
    return function(Hooks)
        local useEffect,useComponents,useMapping = Hooks.useEffect, Hooks.useComponents, Hooks.useMapping;
        useMapping({
            "Size","Position","AnchorPoint","BackgroundTransparency","BackgroundColor3"
        }, {Container});

    end;
end;

function DatePicker:ShowAsync()
    
end;

return DatePicker;