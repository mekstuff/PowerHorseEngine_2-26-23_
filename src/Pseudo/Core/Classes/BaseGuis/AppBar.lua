local Theme = require(script.Parent.Parent.Parent.Theme);

--[=[
    @class AppBar
]=]
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
--[=[
    @prop Text string
    @within AppBar
]=]
--[=[
    @prop TextColor3 color3
    @within AppBar
]=]
--[=[
    @prop Icon string
    @within AppBar
]=]
--[=[
    @prop Size UDim2
    @within AppBar
]=]
--[=[
    @prop BackgroundTransparency number
    @within AppBar
]=]
--[=[
    @prop BackgroundColor3 color3
    @within AppBar
]=]

AppBar.__inherits = {"BaseGui"};

function AppBar:_Render(App)

    local Enumeration = App:GetGlobal("Enumeration");
    local Container = App.new("Frame",self:GetRef());

    local Btn = App.new("Button",Container);
    Btn.ButtonFlexSizing = false;
    Btn.AnchorPoint = Vector2.new(0,.5);
    Btn.Position = UDim2.new(0,5,.5)
    Btn.Size = UDim2.new(.65,0,1,-10);
    Btn.BackgroundTransparency = 1;
    Btn.TextSize = 18
    -- Btn.TextScaled = true;
    Btn.TextAdjustment = Enumeration.Adjustment.Left;

    --[=[
        @prop ActionButtonPressed PHeSignal
        @within AppBar
    ]=]
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
