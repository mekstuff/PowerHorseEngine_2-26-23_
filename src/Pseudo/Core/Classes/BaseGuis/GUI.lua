local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local GUI = {
	__PseudoBlocked = true;
	Name = "GUI";
	ClassName = "GUI";
	Active = true;
	AnchorPoint = Vector2.new(0,0);
	AutomaticSize = Enum.AutomaticSize.None;
	BackgroundColor3 = Theme.getCurrentTheme().Primary;
	BackgroundTransparency = 0;
	BorderSizePixel = 0;
	Position = UDim2.new(0,0,0,0);
	Rotation = 0;
	Size = UDim2.new(0,100,0,40);
	
	ClipsDescendants = false;
	StrokeColor3 = Theme.getCurrentTheme().Border;
	StrokeThickness = 1.5;
	StrokeTransparency = 1;
	

};


function GUI:_Render(App)
	return {};
end;


return GUI
