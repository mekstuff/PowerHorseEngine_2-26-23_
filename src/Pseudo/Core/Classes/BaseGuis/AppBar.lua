local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local AppBar = {
	Name = "AppBar";
	ClassName = "AppBar";   
    Text = "AppBar";
    TextColor3 = Theme.getCurrentTheme().Text;
    Icon = "ico-mdi@navigation/arrow_back";
    Size = UDim2.new(1,0,0,40);
    BackgroundTransparency = 1;
    BackgroundColor3 = Theme.getCurrentTheme().Primary;
};
AppBar.__inherits = {"BaseGui"}


function AppBar:_Render(App)

    local Enumeration = App:GetGlobal("Enumeration");
    local Container = App.new("Frame",self:GetRef());
    -- Container.BackgroundTransp

    local Btn = App.new("Button",Container);
    Btn.ButtonFlexSizing = false;
    Btn.AnchorPoint = Vector2.new(0,.5);
    Btn.Position = UDim2.new(0,5,.5)
    Btn.Size = UDim2.new(.65,0,1,-10);
    Btn.BackgroundTransparency = 1;
    Btn.TextSize = 18
    -- Btn.TextScaled = true;
    Btn.TextAdjustment = Enumeration.Adjustment.Left;

    self:AddEventListener("ActionButtonPressed",true,Btn.MouseButton1Down);
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {
            FatherComponent = Container:GetGUIRef();
            Button = Btn;
        };
		_Mapping = {
            [Container] = {
                "Size","Position","AnchorPoint","Visible","BackgroundTransparency","BackgroundColor3"
            },[Btn] = {
                "Text","Icon","TextColor3"
            }
        };
	};
end;


return AppBar
