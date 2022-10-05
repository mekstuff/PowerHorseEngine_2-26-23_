local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local LineBreak = {
	Name = "LineBreak";
	ClassName = "LineBreak";
	Size = UDim2.new(.95,0,0,2);
	Position = UDim2.fromScale(.5,0);
	AnchorPoint = Vector2.new(.5);
	Color = Color3.fromRGB(255,255,255);
	Transparency = 0;
};
LineBreak.__inherits = {"BaseGui"}


function LineBreak:_Render(App)
	
	local Frame = App.new("Frame",self:GetRef());
	Frame.BorderSizePixel = 0;
	-- Frame.SupportsRBXUIBase = true;
	local Gradient = Instance.new("UIGradient",Frame:GetGUIRef());
	-- Gradient.Transparency = NumberSequence.new({
	-- 	NumberSequenceKeypoint.new(0,1),
	-- 	NumberSequenceKeypoint.new(.5,0);
	-- 	NumberSequenceKeypoint.new(1,1),
	-- });

	-- self.SupportsRBXUIBase = true;
	
	return {
		["Transparency"] = function(Value)
			Gradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0,1),
				NumberSequenceKeypoint.new(.5,Value);
				NumberSequenceKeypoint.new(1,1),
			});
		end,
		-- ["*Parent"] = function(Value)
			-- Frame.Parent = Value;
		-- end,
		["Name"] = function(Value)
			self:GetRef().Name = Value.."_linebreak_ref";
			Frame.Name = Value;
		end,
		["Color"] = function(Value)
			Gradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0,Value);
				ColorSequenceKeypoint.new(1,Value);
			})
		end,
		_Components = {
			FatherComponent = Frame;
			Line = Frame; 	
		};
		_Mapping = {
			[Frame] = {
				"Size","Position","AnchorPoint";
			}	
		};
	};
end;


return LineBreak
