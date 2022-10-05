local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Badge = {
	Name = "Badge";
	ClassName = "Badge";
	BackgroundColor3 = Theme.getCurrentTheme().Secondary;
	BackgroundTransparency = 0;
	Text = "1";
	TextColor3 = Theme.getCurrentTheme().Text;
	TextScaled = false;
	StrokeTransparency = 1;
	StrokeThickness = 2;
	StrokeColor3 = Theme.getCurrentTheme().Border;
	Size = UDim2.fromOffset(25,25);
	Roundness = UDim.new(0,25);
	xAdjustment = Enumeration.Adjustment.Right;
};

Badge.__inherits = {"BaseGui"}

local function PositionButton(Button,xAdjustment)
	local x;
	if(xAdjustment == Enumeration.Adjustment.Left)then
		x=0 
	elseif(xAdjustment == Enumeration.Adjustment.Center)then
		x = .5;
	else
		x = 1
	end;
	Button.Position = UDim2.new(x, - (Button:GetAbsoluteSize().X/2),0,- (Button:GetAbsoluteSize().Y/2));
end


function Badge:_Render(App)
	
	local Button = App.new("Button",self:GetRef());
	-- Button.TextAdjustment = Enumeration.Adjustment.Center;
	-- Button.ButtonFlexSizing = false;
	Button.RippleStyle = Enumeration.RippleStyle.None
	--PositionButton(Button)
--[[
	Button:GetPropertyChangedSignal("Size"):Connect(function()
		if(IsClient)then
			game:GetService("RunService").RenderStepped:Wait();
		else
			task.wait();
		end
		PositionButton(Button,self.xAdjustment);
		--Button.Position = UDim2.new(1, - (Button:GetAbsoluteSize().X/2),0,- (Button:GetAbsoluteSize().Y/2));
	end);
]]
	
	--local ParentPropertySizeChange
	
	return {
		["xAdjustment"] = function(Value)
			PositionButton(Button,Value)
		end,
		["Text"] = function(Value)
			Button.Text = Value;
			Button:JiggleEffect();
		end,
		_Components = {};
		_Mapping = {
			[Button] = {
				"Roundness","TextScaled","Visible",
				"Size","TextColor3","StrokeTransparency","StrokeThickness","StrokeColor3","BackgroundColor3","BackgroundTransparency"
			}	
		};
	};
end;


return Badge
