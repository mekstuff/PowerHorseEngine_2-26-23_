local Enumeration = require(script.Parent.Parent.Parent.Enumeration);

--[=[
	@class DropdownButton
	inherites [Button],[BaseGui],[Frame],[GUI],[Text]
]=]
local DropdownButton = {
	Name = "DropdownButton";
	ClassName = "DropdownButton";
	IconAdjustment = Enumeration.Adjustment.Right;
	Icon = "rbxasset://textures/ui/Settings/DropDown/DropDown.png";	
	IconSize = UDim2.fromOffset(10,10);
	TextTruncate = Enum.TextTruncate.AtEnd;
	ContentSize = Vector2.new(100,100);
	Expanded = false;
};
DropdownButton.__inherits = {"Button","BaseGui","Frame","GUI","Text"};

--[=[
	@prop ContentSize Vector2
	@within DropdownButton
]=]
--[=[
	@prop Expanded boolean
	@within DropdownButton
]=]

--//
function DropdownButton:AddButton(Text,id)
	if(not self._dev._grid)then
		local grid = Instance.new("UIGridLayout",self:GET("_Appender"));
		grid.Name = "ButtonGrid";
		grid.CellPadding = UDim2.fromOffset(0,5);
		grid.FillDirection = Enum.FillDirection.Horizontal;
		grid.HorizontalAlignment = Enum.HorizontalAlignment.Left;
		--grid.CellSize = UDim2.fromOffset(self.ContentSize.X,30);
		grid.CellSize = UDim2.new(1,-6,0,30);
		self._dev._grid = grid;
		if(not self:GetEventListener("ButtonClicked"))then
			self:AddEventListener("ButtonClicked",true);
		end;
		if(self._CollapseAutomatically == nil)then self._CollapseAutomatically=true;end;
	end;
	local Button = self:_GetAppModule().new("Button");
	Button.Name = "DropdownButton";
	Button.ButtonFlexSizing = false;
	Button.TextTruncate = Enum.TextTruncate.AtEnd;
	Button.Size = UDim2.fromScale(1,1);
	Button.Roundness = UDim.new(0);
	Button.StrokeTransparency = 1;
	Button.BackgroundTransparency = 1;
	Button.Text = Text;
	Button.Name = id or Text;
	Button.Parent = self:GET("_Appender");
	Button.SupportsRBXUIBase = true;
	Button._dev.MouseEnterConnection = Button.MouseEnter:Connect(function()
		Button.BackgroundTransparency = 0;
	end);
	Button._dev.MouseExitConnection = Button.MouseLeave:Connect(function()
		Button.BackgroundTransparency = 1;
	end);
	Button._dev.MouseButton1DownConnection = Button.MouseButton1Down:Connect(function()
		self.ButtonClicked:Fire(id,Button);
		if(self._CollapseAutomatically)then
			self.Expanded = false;
		end
	end)
	return Button;
end
--//
function DropdownButton:_Render(App)
	
	local Button = App.new("Button",self:GetRef());

	
	local PSEUDOCLASSES = App:GetService("_PSEUDOCLASSES");
	
	local ButtonProps = PSEUDOCLASSES:GETCLASSPROPS(unpack(DropdownButton.__inherits))
	ButtonProps = PSEUDOCLASSES:GETPROPSAS_STRING(ButtonProps);
	
	
	local ToolTip = App.new("ToolTip",Button);
	ToolTip.RevealOnMouseEnter = false;
	ToolTip.PositionBehaviour = Enumeration.PositionBehaviour.Static;
	ToolTip.StaticXAdjustment = Enumeration.Adjustment.Flex;
	ToolTip.IdleTimeRequired = 0;
	ToolTip.ContentPadding = Vector2.new(0,0);

	local Scroller = App.new("ScrollingFrame",ToolTip);
	Scroller.BackgroundTransparency = 1;
	local xValueupd;
	
	Button.MouseButton1Down:Connect(function()
		self.Expanded = not self.Expanded;
	end)
	
	return {
		
		["Expanded"] = function(Value)
			if(Value)then
				ToolTip:_Show();
			else
				ToolTip:_Hide();
			end
		end,
		["ContentSize"] = function(Value)
			if(Value.X == -1)then
				
				if(not xValueupd)then 
					Scroller.Size = UDim2.fromOffset(Button:GetAbsoluteSize().X,Value.Y);
					xValueupd = Button:GetPropertyChangedSignal("Size"):Connect(function()
						Scroller.Size = UDim2.fromOffset(Button:GetAbsoluteSize().X,Value.Y);
					end);
					
				end;
			else
				Scroller.Size = UDim2.fromOffset(Value.X,Value.Y);
				if(xValueupd)then xValueupd:Disconnect();xValueupd=nil;end;	
			end;	
		end,
		_Components = {
			FatherComponent = Button:GetGUIRef();	
			_Appender = Scroller:GetGUIRef();
		};
		_Mapping = {
			[Button] = ButtonProps;
		};
	};
end;


return DropdownButton
