local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);



local Checkbox = {
	Name = "Checkbox";
	ClassName = "Checkbox";
	Icon = "rbxasset://textures/AnimationEditor/icon_checkmark.png";
	Toggle = true;
	Size = UDim2.fromOffset(25,25);
	BackgroundColor3 = Theme.getCurrentTheme().Primary;
	AutoToggle = true;
};
Checkbox.__inherits = {"BaseGui","Frame"}
--[=[
	@class Checkbox

	Inherits [BaseGui], [Frame]
]=]

--[=[
	@prop Icon string
	@within Checkbox
]=]
--[=[
	@prop Toggle boolean
	@within Checkbox
]=]
--[=[
	@prop AutoToggle boolean
	@within Checkbox
]=]


--[=[
	@param Pseudo Pseudo

	Useful for linking a component to the checkbox. For example
	having a Checkbox followed by a license agreement, you may want to allow
	the user to click the license agreeement text and trigger the toggle on the checkbox
]=]
function Checkbox:Link(Pseudo:Instance):nil
	local function trigger()
		if(not self.AutoToggle)then return end;
		self.Toggle = not self.Toggle;
	end

	local success, MouseButton1DownEvent = pcall(function()
		return Pseudo.MouseButton1Down
	end);
	if(not success)then
		local InputBegan = Pseudo:GetGUIRef().InputBegan:Connect(function(InputObject)
			if(InputObject.UserInputType == Enum.UserInputType.MouseButton1)then
				trigger();
			end
		end)
	else
		
		MouseButton1DownEvent:Connect(trigger);
	end
end;
--//
function Checkbox:_Render(App)
	
	local CheckboxButton = App.new("Button", self:GetRef());
	CheckboxButton.ButtonFlexSizing = false;
	CheckboxButton.Text = "";
	CheckboxButton.StrokeTransparency = 0;
	CheckboxButton.RippleStyle = Enumeration.RippleStyle.None;
	CheckboxButton.Padding = Vector2.new(0,0);
	--CheckboxButton.Icon = "";

	self:AddEventListener("MouseButton1Down",true,CheckboxButton.MouseButton1Down);
	self:AddEventListener("MouseButton1Up",true,CheckboxButton.MouseButton1Up);
	self:AddEventListener("MouseButton2Down",true,CheckboxButton.MouseButton2Down);
	self:AddEventListener("MouseButton2Up",true,CheckboxButton.MouseButton2Up);
	local Toggled = self:AddEventListener("Toggled",true);
	
	return {
		["AutoToggle"] = function(Value)
			if(Value)then
				if(self._dev.AutoToggleConnection)then return end;
				self._dev.AutoToggleConnection = CheckboxButton.MouseButton1Down:Connect(function()
					self.Toggle = not self.Toggle;
				end)
			else
				if(self._dev.AutoToggleConnection)then
					self._dev.AutoToggleConnection:Disconnect();
					self._dev.AutoToggleConnection = nil;
				end
			end
		end;
		--[[
		["Disabled"] = function(Value)
			if(Value)then
				CheckboxButton.BackgroundColor3 = Theme.getCurrentTheme().Disabled;
				CheckboxButton.StrokeColor3 = Theme.getCurrentTheme().Disabled;
			else
				CheckboxButton.BackgroundColor3 = self.BackgroundColor3;
				CheckboxButton.StrokeColor3 = self.BackgroundColor3;
			end
		end,
		]]
		["Toggle"] = function(Value)
			if(Value)then
				CheckboxButton.BackgroundTransparency = 0;
				CheckboxButton.Icon = self.Icon;
				CheckboxButton.StrokeThickness = 0;
				CheckboxButton.Size = self.Size;
				
			else
				CheckboxButton.BackgroundTransparency = .75;
				CheckboxButton.Icon = "";
				CheckboxButton.StrokeThickness = 2;
				CheckboxButton.Size = self.Size - UDim2.fromOffset(2,2)
			end
			Toggled:Fire(Value);
		end,

		["BackgroundColor3"] = function(Value)
			if(not self.Disabled)then
				CheckboxButton.BackgroundColor3 = Value;
				CheckboxButton.StrokeColor3 = Value;
			end
		end,
		
		_Components = {
			FatherComponent = CheckboxButton:GetGUIRef();	
		};
		_Mapping = {
			[CheckboxButton] = {
				"Position","AnchorPoint","ToolTip","Size","Roundness","Disabled","Visible","ZIndex";
			};
			
		};
	};
end;


return Checkbox
