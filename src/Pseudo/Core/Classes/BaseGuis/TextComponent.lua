local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local TextComponent = {
	Name = "TextComponent";
	ClassName = "TextComponent";
	ComponentTextAdjustment = Enumeration.Adjustment.Left;
	ComponentText = "Text Here";
	ComponentTextColor3 = Theme.getCurrentTheme().Text;
	-- ComponentTextSize = -1;
	-- ComponentSize = -1;
	ComponentTextSize = 16;
	ComponentSize = UDim2.new(-1);
	Component = "";
	Padding = 5;
	BackgroundColor3 = Theme.getCurrentTheme().Primary;
	BackgroundTransparency = 1;
	StrokeColor3 = Theme.getCurrentTheme().Background;
	StrokeTransparency = 1;
	StrokeThickness = 1.5;
	-- Size = -1;
	Size = UDim2.new(-1)
};
TextComponent.__inherits = {"BaseGui"};

local function gridRespectObject(p,n)
	local e = Instance.new("Frame");
	e.Name = n or "GridRespect";
	-- e.Size = UDim2.new(0);
	-- e.AutomaticSize = Enum.AutomaticSize.XY;
	e.BackgroundTransparency = 1;
	e.Parent = p;
	return e;
end

function TextComponent:_Render(App)
	
	local Container = App.new("Frame",self:GetRef());
	-- Container.Size = UDim2.new(0);
	-- Container.AutomaticSize = Enum.AutomaticSize.XY;
	-- Container.BackgroundTransparency = 1;
	
	local cRef = Container:GetGUIRef();
	
	local gridRespectText = gridRespectObject(cRef,"a")
	local gridRespectObject = gridRespectObject(cRef,"b")
	
	local Text = App.new("Text",gridRespectText);
	Text.Size = UDim2.new(1,0,1,0);
	-- Text.TextScaled = true;
	-- Text.AutomaticSize = Enum.AutomaticSize.XY;
	
	local list = Instance.new("UIListLayout");
	list.FillDirection = Enum.FillDirection.Horizontal;
	list.HorizontalAlignment = Enum.HorizontalAlignment.Left;
	list.VerticalAlignment = Enum.VerticalAlignment.Center;
	list.Parent = cRef;
	
	local Component;
	
	return {
		["ZIndex"] = function(Value)
			Container.ZIndex = Value;
			Text.ZIndex = Value;
			if(Component)then
				Component.ZIndex = Value;
			end
		end;
		["Padding"] = function(Value)
			list.Padding = UDim.new(0,Value)
		end,
		["ComponentTextAdjustment"] = function(v)
			if(v == Enumeration.Adjustment.Left)then
				list.FillDirection = Enum.FillDirection.Horizontal;
				list.HorizontalAlignment = Enum.HorizontalAlignment.Left;
				list.VerticalAlignment = Enum.VerticalAlignment.Center;
				gridRespectText.Name = "a";gridRespectObject.Name = "b";
			elseif(v == Enumeration.Adjustment.Right)then
				list.FillDirection = Enum.FillDirection.Horizontal;
				list.HorizontalAlignment = Enum.HorizontalAlignment.Left;
				list.VerticalAlignment = Enum.VerticalAlignment.Center;
				gridRespectText.Name = "b";gridRespectObject.Name = "a";
			elseif(v == Enumeration.Adjustment.Top)then
				list.FillDirection = Enum.FillDirection.Vertical;
				list.HorizontalAlignment = Enum.HorizontalAlignment.Center;
				list.VerticalAlignment = Enum.VerticalAlignment.Center;
				gridRespectText.Name = "a";gridRespectObject.Name = "b";
			elseif(v == Enumeration.Adjustment.Bottom)then
				list.FillDirection = Enum.FillDirection.Vertical;
				list.HorizontalAlignment = Enum.HorizontalAlignment.Center;
				list.VerticalAlignment = Enum.VerticalAlignment.Center;
				gridRespectText.Name = "b";gridRespectObject.Name = "a";
			end
		end,
		["ComponentText"] = function(v)
			Text.Text = v;
		end,
		["ComponentTextColor3"] = function(v)
			Text.TextColor3 = v;
		end,
		--[[
		["ComponentTextSize"] = function(v)
			if(v > 1)then
				Text.TextSize = v;
			end;
		end,
		["ComponentSize"] = function(v)
			if(Component and v > 1)then
				Component.Size = UDim2.fromOffset(v,v);
			end
		end,
			["ComponentTextSize"] = function(v)
			if(v ~= -1)then
				TextComponent.AutomaticSize = Enum.AutomaticSize.XY;
				TextComponent.TextSize = v;
				TextComponent.TextScaled = false;
			else
				-- TextComponent.AutomaticSize = Enum.AutomaticSize.None;
				TextComponent.TextScaled = true;
			end;
		end;
		]]
		["ComponentTextSize"] = function(v)
			if(v ~= -1)then
				Text.Size = UDim2.fromOffset(0);
				Text.AutomaticSize = Enum.AutomaticSize.XY;
				Text.TextSize = v;
				Text.TextScaled = false;
			else
				Text.Size = UDim2.fromScale(1,1);
				Text.AutomaticSize = Enum.AutomaticSize.None;
				Text.TextScaled = true;
			end;
		end;
		["Size"] = function(v)
			if(v ~= UDim2.new(-1))then
				Container.AutomaticSize = Enum.AutomaticSize.None;
				gridRespectObject.AutomaticSize = Enum.AutomaticSize.None;
				gridRespectText.AutomaticSize = Enum.AutomaticSize.None;
				gridRespectText.Size = UDim2.fromScale(.5,1);
				gridRespectObject.Size = UDim2.fromScale(.5,1);
				Container.Size = v;
			else
				gridRespectText.Size = UDim2.new(0);
				gridRespectObject.Size = UDim2.new(0);
				Container.Size = UDim2.new(0);
				gridRespectText.AutomaticSize = Enum.AutomaticSize.XY;
				gridRespectObject.AutomaticSize = Enum.AutomaticSize.XY;
				Container.AutomaticSize = Enum.AutomaticSize.XY;
			end
			-- if(v > 1)then
				
				-- self.ComponentTextSize = v;self.ComponentSize = v;
			-- end;
		end,
		
		["Component"] = function(Value)
			if(Component)then
				Component:Destroy();
				self._Components["Component"] = nil;
			end;
			if(Value ~= "")then
				local n = App.new(Value);
				--local f = gridRespectObject(cRef,"b")
				n.ZIndex = self.ZIndex;
				n.Parent = gridRespectObject;
				self._Components["Component"] = n;
				Component = n;
				self._Components["Component"] = n;
			end
		end,
		_Components = {
			FatherComponent = Container:GetGUIRef();	
			-- Text = 
		};
		_Mapping = {
			[Container]	 = {
				"Position","AnchorPoint","Visible","BackgroundColor3","BackgroundTransparency",
				"StrokeThickness","StrokeColor3","StrokeTransparency";
			}
		};
	};
end;

function TextComponent:GetComponent()
	return self:GET("Component");
end


return TextComponent
