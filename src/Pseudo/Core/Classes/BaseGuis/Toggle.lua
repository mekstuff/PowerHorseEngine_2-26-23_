local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local ti = TweenInfo.new(.2, Enum.EasingStyle.Back);
local TweenService = game:GetService("TweenService");

local Toggle = {
	Name = "Toggle";
	ClassName = "Toggle";
	OnIcon = "ico-mdi@navigation/check";
	OffIcon = "ico-mdi@action/highlight_off";
	OffColor3 = Color3.fromRGB(255, 80, 74);
	OnColor3 = Color3.fromRGB(110, 255, 144);
	Toggle = true;
	BackgroundColor3 = Theme.getCurrentTheme().Text;
	Size = UDim2.fromOffset(35,20);

	--BackgroundTransparency = 1;
};
Toggle.__inherits = {"BaseGui"}

function Toggle:_ToggleOff()
	
end


function Toggle:_Render(App)
	
	local Toggled = self:AddEventListener("Toggled",true)
	
	local Background = App.new("Frame");
	Background.Roundness = UDim.new(0,10);
	Background.StrokeTransparency = 1;
	--Background.BackgroundTransparency = 1;
	--Background.BackgroundColor3 = Toggle.Properties.OffColor;
	Background.Parent = self:GetRef();

	local ToggleButton = App.new("Button");
	ToggleButton.AnchorPoint = Vector2.new(0,.5);
	ToggleButton.Position = UDim2.fromScale(0,.5);
	-- ToggleButton.Size = UDim2.new(0,25,1,10);
	ToggleButton.Size = UDim2.new(1,0,1,0);
	local UIAspect = Instance.new("UIAspectRatioConstraint",ToggleButton:GetGUIRef());
	ToggleButton.Roundness = UDim.new(0,20);
	ToggleButton.StrokeTransparency = 1;
	ToggleButton.ActiveBehaviour = Enumeration.ActiveBehaviour.None;
	ToggleButton.RippleStyle = Enumeration.RippleStyle.None;
	ToggleButton.BackgroundColor3 = Color3.fromRGB(226, 226, 226);
	ToggleButton.HoverEffect = Enumeration.HoverEffect.None;
	ToggleButton.TextAdjustment = Enumeration.Adjustment.Center;
	ToggleButton.Parent = Background:GetGUIRef();
	ToggleButton.Text = "";
	ToggleButton.ButtonFlexSizing = false;
	
	ToggleButton:RemoveEventListener("MouseButton1Up","MouseButton2Down","MouseButton2Up");
	
	self._dev.__looseConnection = ToggleButton.MouseButton1Down:Connect(function()
		self.Toggle = not self.Toggle;
	end)
	
	return {
		["Toggle"] = function(Value)
			
			if(not Value)then
				local offPos = UDim2.new(0,-5, .5);
				TweenService:Create(ToggleButton:GetGUIRef(),ti, {Position = offPos}):Play();
				ToggleButton.BackgroundColor3 = self.OffColor3;
				ToggleButton.Icon = self.OffIcon;
				-- ToggleButton.Text = "✖";
				--self.__dev.Signals["Toggle"]:Fire(false,"Off");
			else
				local onPos = UDim2.new(1,-(ToggleButton:GetAbsoluteSize().X - 5), .5);
				TweenService:Create(ToggleButton:GetGUIRef(),ti, {Position = onPos}):Play();
				ToggleButton.BackgroundColor3 = self.OnColor3;
				ToggleButton.Icon = self.OnIcon;

				-- ToggleButton.Text = "✔";
				--self.__dev.Signals["Toggle"]:Fire(true,"On");
			end
			Toggled:Fire(Value);
		end,

		_Components = {
			FatherComponent = Background:GetGUIRef();	
		};
		_Mapping = {
			[Background] = {
				"BackgroundColor3","Position","AnchorPoint","Size","Visible";
			}	
		};
	};
end;


return Toggle
