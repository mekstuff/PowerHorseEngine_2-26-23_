local Theme = require(script.Parent.Parent.Parent.Theme);

local GUI = {
	-- __PseudoBlocked = true;
	-- Name = "GUI";
	-- ClassName = "GUI";
	-- Active = true;
	-- AnchorPoint = Vector2.new(0,0);
	-- BackgroundColor3 = Theme.getCurrentTheme().Primary;
	-- BackgroundTransparency = 0;
	-- BorderSizePixel = 0;
	-- Position = UDim2.new(0,0,0,0);
	-- Rotation = 0;
	-- Size = UDim2.new(0,100,0,40);
	
	-- ClipsDescendants = false;
	-- StrokeColor3 = Theme.getCurrentTheme().Border;
	-- StrokeThickness = 1.5;
	-- StrokeTransparency = 1;
};

--[=[
	@class GUI
]=]

--[=[
	@prop Active boolean
	@within GUI
]=]
--[=[
	@prop AnchorPoint Vector2
	@within GUI
]=]
--[=[
	@prop AutomaticSize Enumeration
	@within GUI
]=]
--[=[
	@prop BackgroundColor3 Color3
	@within GUI
]=]
--[=[
	@prop BackgroundTransparency number
	@within GUI
]=]
--[=[
	@prop BorderSizePixel number
	@within GUI
]=]
--[=[
	@prop Position UDim2
	@within GUI
]=]
--[=[
	@prop Rotation number
	@within GUI
]=]
--[=[
	@prop ClipsDescendants boolean
	@within GUI
]=]
--[=[
	@prop StrokeColor3 Color3
	@within GUI
]=]
--[=[
	@prop StrokeThickness number
	@within GUI
]=]
--[=[
	@prop StrokeTransparency number
	@within GUI
]=]

function GUI:_Render()
	return {};
end;


return GUI
