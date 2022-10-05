local Theme = require(script.Parent.Parent.Parent.Theme);

local Toast = {
    Name = "Toast",
    ClassName = "Toast",
    BackgroundColor3 = Theme.getCurrentTheme().Primary;
    ActionButtonsFillDirection = Enum.FillDirection.Vertical;
    CloseButtonVisible = false;
	HeaderTextSize = 18;
	HeaderTextColor3 = Theme.getCurrentTheme().Text;
	CanvasImage = "";
	IconImage = "";
	xMax = 200;
	Size = UDim2.fromOffset(200);
	AutomaticSize = Enum.AutomaticSize.Y;
	Header = "Toast";
	Body = "";
	BodyTextColor3 = Theme.getCurrentTheme().Text;
	BodyTextSize = 16;
	Subheader = "";
	CanCollapse = false;
	-- BackgroundColor3 = Color3.fromRGB(18, 18, 18);
	StrokeTransparency = 1;
	Roundness = UDim.new(0);
    Padding = UDim2.new(5,5,5,5);
}

Toast.__inherits = {"BaseGui"};

function Toast:_Render(App)
    
    local Wrapper = App.new("Frame",self:GetRef())
    Wrapper.BackgroundColor3 = Color3.fromRGB(255);
    local WrapperList = Instance.new("UIListLayout", Wrapper:GetGUIRef());
    WrapperList.SortOrder = Enum.SortOrder.LayoutOrder;
    WrapperList.FillDirection = Enum.FillDirection.Vertical;

    local Top = App.new("Frame",Wrapper);
    Top.SupportsRBXUIBase = true;
    Top.Size = UDim2.new(1,0,0,0);
    Top.AutomaticSize = Enum.AutomaticSize.Y;
    Top.BackgroundColor3 = Color3.fromRGB(0);
    Top.BackgroundTransparency = 1;

    local TopList = Instance.new("UIListLayout", Top:GetGUIRef());
    TopList.SortOrder = Enum.SortOrder.LayoutOrder;
    TopList.FillDirection = Enum.FillDirection.Horizontal;

    local CanvasImage = App.new("Image",Top)
    CanvasImage.SupportsRBXUIBase = true;
    CanvasImage.Size = UDim2.new(1,0,0,50);
    CanvasImage.BackgroundTransparency = 1;
    -- CanvasImage.Image = "ico-mdi@maps/flight";
    CanvasImage.BackgroundColor3 = Color3.fromRGB(0,100,0)
    Instance.new("UIAspectRatioConstraint",CanvasImage:GetGUIRef());

    local Header = App.new("Button",Top);
    Header.SupportsRBXUIBase = true;
    Header.Size = UDim2.new(0);
    Header.BackgroundTransparency = 1;
    Header.Roundness = UDim.new(0);

    local ActionButtons = App.new("Frame", Top);
    ActionButtons.Size = UDim2.new(0);
    ActionButtons.AutomaticSize = Enum.AutomaticSize.XY;
    local ActionButtonsUIList = Instance.new("UIListLayout", ActionButtons:GetGUIRef());

    local Body = App.new("Text", Wrapper)
    Body.SupportsRBXUIBase = true;
    Body.Size = UDim2.new(1);
    Body.TextWrapped = true;
    Body.TextXAlignment = Enum.TextXAlignment.Left;
    Body.AutomaticSize = Enum.AutomaticSize.Y;
    Body.TextTruncate = Enum.TextTruncate.AtEnd;
    Body.BackgroundTransparency = 1;

    local ContentContainer = App.new("Frame",Wrapper);
    ContentContainer.SupportsRBXUIBase = true;
    ContentContainer.Size = UDim2.new(1,0,0,0);
    ContentContainer.BackgroundColor3 = Color3.fromRGB(0,145,0)
    ContentContainer.AutomaticSize = Enum.AutomaticSize.XY;
    ContentContainer.BackgroundTransparency = 1;

    -- local ButtonsContainer = App.new("Frame",Wrapper);
    -- ButtonsContainer.SupportsRBXUIBase = true;
    -- ButtonsContainer.Size = UDim2.new(1,0,0,30);
    -- ButtonsContainer.BackgroundColor3 = Color3.fromRGB(0,0,145);
    -- ButtonsContainer.AutomaticSize = Enum.AutomaticSize.XY;

    return {
        ["CanvasImage"] = function(x)
            CanvasImage.Image = x;
            if(x == "")then
                CanvasImage.Visible = false;
            else
                CanvasImage.Visible = true;
            end;
        end;
        ["Body"] = function(x)
            Body.Text = x;
            if(x == "")then
                Body.Visible = false;
            else
                Body.Visible = true;
            end;
        end;
        ["BodyTextSize"] = function(x)
            Body.TextSize = x;
        end;
        ["Header"] = function(x)
            Header.Text = x;
        end;
        ["HeaderTextSize"] = function(x)
            Header.TextSize = x;
        end;
        ["HeaderTextColor3"] = function(x)
            Header.TextColor3 = x;
        end;
        ["ActionButtonsFillDirection"] = function(x)
            ActionButtonsUIList.FillDirection = x;
        end;
        _Mapping = {
            [Wrapper] = {"Size","Position","AnchorPoint","Visible","AutomaticSize","Padding","Roundness","BackgroundColor3"}
        },
        _Components = {
            FatherComponent = Wrapper:GetGUIRef();
            _Appender = ContentContainer;
            Body = Body;
        }
    };

end;

return Toast;