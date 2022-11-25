local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
--[=[
	@class CloseButton
]=]
local CloseButton = {
	Name = "CloseButton";
	ClassName = "CloseButton";
	-- Position = UDim2.new(1,-1,0,5),
	Position = UDim2.new(1);
	AnchorPoint = Vector2.new(1);
	Size = UDim2.fromOffset(30,30);
	Color = Color3.fromRGB(229, 229, 229);
	Visible = true;
};
CloseButton.__inherits = {"BaseGui"};


function CloseButton:_Render(App)
	

	local CloseBtn = App.new("Button");
	CloseBtn.Text = "×";
	CloseBtn.TextSize = 24;
	CloseBtn.Font = Enum.Font.GothamBold;
	CloseBtn.BackgroundTransparency = 1;
	CloseBtn.StrokeTransparency = 1;
	CloseBtn.TextTransparency = .3;
	CloseBtn.TextAdjustment = Enumeration.Adjustment.Center;
	CloseBtn.ButtonFlexSizing = false;
	
	CloseBtn.Parent = self:GetRef();
	--CloseBtn.HoverEffect = Enumeration.HoverEffect.Highlight;
	--CloseBtn.RippleStyle = Enumeration.RippleStyle.None;
	--CloseBtn.ActiveBehaviour = Enumeration.ActiveBehaviour.None;
	
	--[=[
		@prop Activated PHeSignal
		@within CloseButton
		Fired whenever the CloseButton is clicked
	]=]
	self:AddEventListener("Activated",true,CloseBtn:GetEventListener("MouseButton1Down"));

	CloseBtn:RemoveEventListener("MouseButton1Up","MouseButton2Down","MouseButton2Up","MouseEnter","MouseExit");
	
	return {
		["Color"] = function(v)
			CloseBtn.TextColor3 = v;
		end,
		_Mapping = {
			[CloseBtn] = {
				"Size","Position","AnchorPoint","Visible","ZIndex";
			}
		};
		_Components = {
			Button  = CloseBtn;
			FatherComponent = CloseBtn:GetGUIRef();
		}
	};
end;


return CloseButton
