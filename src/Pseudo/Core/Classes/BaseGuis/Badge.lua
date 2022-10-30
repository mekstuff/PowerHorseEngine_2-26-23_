local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local TextService = game:GetService("TextService")

--[=[
	@class Badge

	Inherits [BaseGui], [Text]
]=]

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

--[=[
	@prop xAdjustment Enumeration.Adjustment
	@within Badge
]=]

Badge.__inherits = {"BaseGui"}

local function PositionButton(TextObject,xAdjustment)
	local x;
	if(xAdjustment == Enumeration.Adjustment.Left)then
		x=0 
	elseif(xAdjustment == Enumeration.Adjustment.Center)then
		x = .5;
	else
		x = 1
	end;
	TextObject.Position = UDim2.new(x, - (TextObject:GetAbsoluteSize().X/2),0,- (TextObject:GetAbsoluteSize().Y/2));
end


function Badge:_Render(App)
	
	local TextObject = App.new("Text",self:GetRef());
	TextObject.Size = UDim2.new(0);

	local Rounder = Instance.new("UICorner", TextObject:GetGUIRef())
	
	return {
		["xAdjustment"] = function(Value)
			PositionButton(TextObject,Value)
		end,
		["Text"] = function(Value)
			TextObject.Text = Value;
			local s = TextService:GetTextSize(Value, TextObject.TextSize, TextObject.Font, Vector2.new(math.huge,math.huge));
			self.Size = UDim2.fromOffset(s.X+15,s.Y+7.5);
			PositionButton(TextObject,self.xAdjustment)
		end,
		["Roundness"] = function(v)
			Rounder.CornerRadius = v;
		end;
		_Components = {};
		_Mapping = {
			[TextObject] = {
				"TextScaled","Visible",
				"Size","TextColor3","StrokeTransparency","StrokeThickness","StrokeColor3","BackgroundColor3","BackgroundTransparency"
			}	
		};
	};
end;


return Badge
