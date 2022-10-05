local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

--[=[
@class Accordion
--]=]
local Accordion = {
	Name = "Accordion";
	ClassName = "Accordion";
	Text = "Accordion";
	Icon = "";
	Font = Theme.getCurrentTheme().Font;
	TextSize = 18;
	TextColor3 = Theme.getCurrentTheme().Text;
	BackgroundTransparency = 0;
	-- ButtonColor3 = Theme.getCurrentTheme().Primary;
	BackgroundColor3 = Theme.getCurrentTheme().Primary;
	Expanded = false;
	AccordionButtonPosition = Enumeration.AccordionButtonPosition.Partial;
	AutomaticSize = Enum.AutomaticSize.None;
	ButtonSize = UDim2.new(1,0,0,30);
	AutoExpand = false;
	Size = UDim2.new(1,0,0,0);
};

Accordion.__inherits = {"BaseGui"}
--[=[
@prop Inherits BaseGui
@within Accordion
]=]
--[=[
@prop AutoExpand Boolean
@within Accordion
]=]

--[=[
Gets the button of the accordion
@return Button
]=]
function Accordion:GetButton()
	return self:GET("Button");
end

function Accordion:_Render(App)
	
	local AccordionContainer = App.new("Frame",self:GetRef());
	
	local UIList = Instance.new("UIListLayout",AccordionContainer:GetGUIRef());
	UIList.SortOrder = Enum.SortOrder.Name;
	
	local AccordionButton = App.new("Button", AccordionContainer);
	AccordionButton.Name = "A";
	AccordionButton.IconAdjustment = Enumeration.Adjustment.Left;
	AccordionButton.TextAdjustment = Enumeration.Adjustment.Left;
	AccordionButton.ButtonFlexSizing = false;
	AccordionButton.BackgroundTransparency = 1;
	AccordionButton.Roundness = UDim.new(0);

	AccordionButton.ClickEffect = false;

	self:AddEventListener("ButtonMouseEnter",true,AccordionButton.MouseEnter);
	self:AddEventListener("ButtonMouseLeave",true,AccordionButton.MouseLeave);
	
	local AccordionContent = App.new("Frame",AccordionContainer);
	AccordionContent.Name = "B";
	AccordionContent.ClipsDescendants = true;
	AccordionContent.BackgroundTransparency = 1;

	AccordionButton.SupportsRBXUIBase = true;
	AccordionContent.SupportsRBXUIBase = true;

	local function updateSize(value)
		value = value or self.Size;
		AccordionContent.Size = self.Size;
		AccordionContainer.Size = self.Size + UDim2.fromOffset(0,AccordionButton:GetGUIRef().AbsoluteSize.Y);
	end
	
	local AutoExpandConnection;
	
	local AutomaticSizeConnection;
	
	local AutoExpandButton = Instance.new("TextButton", AccordionButton:GetGUIRef());
	AutoExpandButton.BackgroundTransparency = 1;
	AutoExpandButton.Text = "";
	
	self:AddEventListener("ButtonPressed",true,AutoExpandButton.MouseButton1Down);
	
	return {
		["AutomaticSize"] = function(v)
			AccordionContent.AutomaticSize = v;
			AccordionContainer.AutomaticSize = v;
		end,

		["AutoExpand"] = function(v)
			if(v)then 
				if(AutoExpandConnection)then return end;
				if(self.Expanded)then 
					self.Icon = "ico-mdi@hardware/keyboard_arrow_down";
				else
					self.Icon = "ico-mdi@hardware/keyboard_arrow_right";
				end
				AutoExpandConnection = self.ButtonPressed:Connect(function()
					self.Expanded = not self.Expanded;
					-- if(self.Expanded)then
						-- self.Icon = "ico-mdi@hardware/keyboard_arrow_down";
					-- else
						-- self.Icon = "ico-mdi@hardware/keyboard_arrow_right"
					-- end
				end)
			else
				if(AutoExpandConnection)then
					AutoExpandConnection:Disconnect();
					AutoExpandConnection = nil;
				end
			end;
		end,
	
		["Size"] = function(v)
			if not(self.Expanded)then
				AccordionContainer.Size = UDim2.new(v.X.Scale,v.X.Offset,0,AccordionButton:GetGUIRef().AbsoluteSize.Y);
				return end;
			updateSize(v);
		end,
		["Expanded"] = function(v)
			if(v)then
				updateSize();
				AccordionContent.Visible = true;
				if(self.AutoExpand)then
					self.Icon = "ico-mdi@hardware/keyboard_arrow_down";
				end;
				-- AccordionContent.AutomaticSize = Enum.AutomaticSize.Y;
			else
				-- AccordionContent.AutomaticSize = Enum.AutomaticSize.None;
				AccordionContainer.Size = UDim2.new(self.Size.X.Scale,self.Size.X.Offset,0,AccordionButton:GetGUIRef().AbsoluteSize.Y);
				AccordionContent.Visible = false;
				if(self.AutoExpand)then
					self.Icon = "ico-mdi@hardware/keyboard_arrow_right";
				end;	
			end
		end,
		["ButtonSize"] = function(v)
			AccordionButton.Size = v;
			if(self.Expanded)then
				updateSize();
			else
				AccordionContainer.Size = UDim2.new(self.Size.X.Scale,self.Size.X.Offset,0,AccordionButton:GetGUIRef().AbsoluteSize.Y);
			end;	
		end,
		["AccordionButtonPosition"] = function(Value)
			if(Value == Enumeration.AccordionButtonPosition.Partial)then
				AutoExpandButton.Parent = AccordionButton:GetGUIRef();
				AutoExpandButton.Size = UDim2.new(0,30,.9);
				--ConnectAutoButtonListener();
			elseif(Value == Enumeration.AccordionButtonPosition.Entire)then
				AutoExpandButton.Parent = AccordionButton:GetGUIRef();
				AutoExpandButton.Size = UDim2.fromScale(1,1);
				--ConnectAutoButtonListener();
			elseif(Value == Enumeration.AccordionButtonPosition.Icon)then
				local Icon = (AccordionButton:GET("Icon"));
				AutoExpandButton.Parent = Icon:GetGUIRef();
				AutoExpandButton.Size = UDim2.fromScale(1,.9);
			else
				AutoExpandButton.Parent = AccordionButton:GetGUIRef();
				AutoExpandButton.Size = UDim2.new(0);
				--DisconnectAutoButtonListener();
			end
		end,
		_Components = {
			Button = AccordionButton;
			_Appender = AccordionContent:GetGUIRef();
			--Content = AccordionContent;
			FatherComponent = AccordionContainer:GetGUIRef();
		};
		_Mapping = {
			[AccordionContainer] = {
				"Position","AnchorPoint","Visible","BackgroundColor3","BackgroundTransparency"
			};
			[AccordionButton] = {
				"TextColor3","Icon","Text","Font","TextSize"
			}
		}
	}
	
--[[
	local AccordionButton = App.new("Button", self:GetRef());
	AccordionButton.ButtonFlexSizing = false;
	AccordionButton.ClickEffect = false;
	
	local AccordionContent = App.new("Frame",AccordionButton);
	AccordionContent.BackgroundTransparency = .5;
	AccordionContent.BackgroundColor3 = Color3.fromRGB(255);
	AccordionContent.AutomaticSize = Enum.AutomaticSize.XY;
	AccordionContent.Size = UDim2.new(1);
	AccordionContent.Position = UDim2.fromScale(0,1);
	
	local AutoExpandButton = Instance.new("TextButton", AccordionButton:GetGUIRef());
	AutoExpandButton.BackgroundTransparency = 1;
	AutoExpandButton.Text = "";
	local AutoButtonListener;
	local function ConnectAutoButtonListener()
		if(not AutoButtonListener)then
			AutoButtonListener = AutoExpandButton.MouseButton1Up:Connect(function()
				self.Expanded = not self.Expanded;
			end);
		end
	end;
	local function DisconnectAutoButtonListener()
		if(AutoButtonListener)then
			AutoButtonListener:Disconnect();AutoButtonListener=nil;
		end
	end
	
	return {
		["AutoAccordionBehaviour"] = function(Value)
			if(Value == Enumeration.AutoAccordionBehaviour.Partial)then
				AutoExpandButton.Size = UDim2.new(0,20,1);
				ConnectAutoButtonListener();
			elseif(Value == Enumeration.AutoAccordionBehaviour.Entire)then
				AutoExpandButton.Size = UDim2.fromScale(1,1);
				ConnectAutoButtonListener();
			else
				AutoExpandButton.Size = UDim2.new(0);
				DisconnectAutoButtonListener();
			end
		end,
		["Expanded"] = function(Value)
			if(Value)then 
				self:_Expand();
				
			else
				self:_Collapse();
			end
		end,
		_Components = {
			FatherComponent = AccordionButton:GetGUIRef();	
			ContentWrapper = AccordionContent;
			_Appender = AccordionContent:GetGUIRef();
		};
		_Mapping = {
			[AccordionButton] = {"Icon","Text","TextColor3","BackgroundColor3","Size","Position","AnchorPoint","Visible"}	
		};
	};
	]]
end;


return Accordion
