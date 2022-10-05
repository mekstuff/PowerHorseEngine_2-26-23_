local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local TimePicker = {
	Name = "TimePicker";
	ClassName = "TimePicker";
};
TimePicker.__inherits = {"BaseGui"}

function TimePicker:_CreateSection()
    local App = self:_GetAppModule();
    local Scroller = App.new("ScrollingFrame");
    Scroller.SupportsRBXUIBase = true;
    Scroller.Size = UDim2.fromScale(1,1);
    Scroller.AutomaticCanvasSize = Enum.AutomaticSize.None;

    local UIGrid = Instance.new("UIGridLayout", Scroller:GetGUIRef());
    UIGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroller.CanvasSize = UDim2.fromOffset(UIGrid.AbsoluteContentSize.X,UIGrid.AbsoluteCellSize.Y);
    end);
    UIGrid.SortOrder = Enum.SortOrder.LayoutOrder;
    UIGrid.CellSize = UDim2.new(1,0,0,30);
    UIGrid.CellPadding = UDim2.fromOffset(0,5);
    return Scroller,UIGrid;
end

function TimePicker:_Render(App)

    local MainFrame = App.new("Frame",self:GetRef());
    local MainFrameGrid = Instance.new("UIGridLayout", MainFrame:GetGUIRef());
    MainFrameGrid.FillDirection = Enum.FillDirection.Horizontal;
    MainFrameGrid.CellSize = UDim2.new(.5,0,1,0);

    local Demo = self:_CreateSection();
    Demo.Parent = MainFrame;

    local T1 = App.new("Text", Demo);
    T1.SupportsRBXUIBase = true;
    T1.TextScaled = true;
    T1.Text = "01";


	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {
            FatherComponent = MainFrame;
        };
		_Mapping = {};
	};
end;


return TimePicker
