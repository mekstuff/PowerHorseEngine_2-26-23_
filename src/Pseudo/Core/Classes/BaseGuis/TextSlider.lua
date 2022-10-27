local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local UIS = game:GetService("UserInputService");
local TotalPadding = 5;

local TextSlider = {
	Name = "TextSlider";
	ClassName = "TextSlider";
	Size = UDim2.fromOffset(200,35);
	Focused = false;
};
TextSlider.__inherits = {"BaseGui"}

--//
function TextSlider:SetFocus(Focus)
	if(not Focus)then
		if(self._dev.__FocusEvents)then
			self._dev.__FocusEvents.l:Disconnect();self._dev.__FocusEvents.l=nil;
			self._dev.__FocusEvents.r:Disconnect();self._dev.__FocusEvents.r=nil;
			self._dev.__FocusEvents=nil;
		end;
	else
		if(self._dev.__FocusEvents)then print("Already Focused") return end;
		local LeftButton,RightButton = self:GET("LeftButton"),self:GET("RightButton");
		self._dev.__FocusEvents = {};
		self._dev.__FocusEvents.l = UIS.InputBegan:Connect(function(Key)
			if(Key.KeyCode == Enum.KeyCode.Left)then
				LeftButton:GetEventListener("MouseButton1Down"):Fire();
			end
		end);
		self._dev.__FocusEvents.r = UIS.InputBegan:Connect(function(Key)
			if(Key.KeyCode == Enum.KeyCode.Right)then
				RightButton:GetEventListener("MouseButton1Down"):Fire();
			end
		end)
	end
end;
--//
function TextSlider:RemoveText(Text)
	if(self._dev.TEXTS)then
		for index,v in pairs(self._dev.TEXTS) do
			if(v.Text == Text)then
				self:GET("Navigator"):RemoveNavigation(v.Text)
				table.remove(self._dev.TEXTS,index);
				break;
			end;
		end
	end
end;	
--//
function TextSlider:AddText(Text,TextSize)
	if(self._dev.TEXTS)then
		for _,v in pairs(self._dev.TEXTS) do
			if(v.Text == Text)then return end;
		end
	end

	local App = self:_GetAppModule();
	local Navigator = self:GET("Navigator");
	local TextValue = App.new("Text");
	TextValue.Text = Text;
	TextValue.Size = UDim2.fromScale(1,1);
	TextValue.TextSize = TextSize or 16;
	TextValue.TextTruncate = Enum.TextTruncate.AtEnd;
	TextValue.BackgroundTransparency = 1;

	if(not self._dev.TEXTS)then self._dev.TEXTS = {};end;

	table.insert(self._dev.TEXTS, TextValue);


	Navigator:AddNavigation(TextValue, Text);
	
	return TextValue;
end;

--//

function TextSlider:_Render(App)
	
	local Component = Instance.new("Frame",self:GetRef());
	Component.BackgroundTransparency = 1;

	local TextArea = Component:Clone();
	TextArea.Parent = Component;
	TextArea.Name = "TextArea";
	local LeftButton = App.new("Button");
	LeftButton.Text = "<";
	LeftButton.Size = UDim2.new(0,30,1,0);
	LeftButton.TextSize = 30;
	LeftButton.StrokeTransparency = 1;
	LeftButton.BackgroundTransparency = 1;
	LeftButton.ActiveBehaviour = Enumeration.ActiveBehaviour.None;
	LeftButton.Font = Enum.Font.GothamBold;
	LeftButton.TextAdjustment = Enumeration.Adjustment.Center;
	LeftButton.HoverEffect = Enumeration.HoverEffect.None;
	LeftButton.RippleStyle = Enumeration.RippleStyle.None;
	LeftButton.ButtonFlexSizing = false;
	LeftButton.Parent = Component;
	local RightButton = App.new("Button");
	RightButton.AnchorPoint = Vector2.new(1,0);
	RightButton.Position = UDim2.fromScale(1,0);
	RightButton.Text = ">";
	RightButton.Size = UDim2.new(0,30,1,0);
	RightButton.TextSize = 30;
	RightButton.StrokeTransparency = 1;
	RightButton.BackgroundTransparency = 1;
	RightButton.ActiveBehaviour = Enumeration.ActiveBehaviour.None;
	RightButton.Font = Enum.Font.GothamBold;
	RightButton.TextAdjustment = Enumeration.Adjustment.Center;
	RightButton.HoverEffect = Enumeration.HoverEffect.None;
	RightButton.RippleStyle = Enumeration.RippleStyle.None;
	RightButton.ButtonFlexSizing = false;
	RightButton.Parent = Component;

	TextArea.Position = UDim2.fromOffset(LeftButton.Size.X.Offset+TotalPadding,TotalPadding);
	TextArea.Size = UDim2.new(1,-(LeftButton.Size.X.Offset*2)-TotalPadding*2,1,-TotalPadding*2);

	local Navigator = App.new("Navigator",TextArea);
	Navigator.Size = UDim2.fromScale(1,1);
	
	self._dev.__rbd = RightButton.MouseButton1Down:Connect(function()
		Navigator:Next()
	end);
	self._dev.__lbd = LeftButton.MouseButton1Down:Connect(function()
		Navigator:Back()
	end);
	
	
	self:AddEventListener("SelectionChanged",true,Navigator.Navigated)
	
	return {
		["Focused"] = function(Value)
			self:SetFocus(Value);
		end,
		_Components = {
			LeftButton = LeftButton;
			RightButton = RightButton;
			Navigator = Navigator;
			FatherComponent = Component;
		};
		_Mapping = {
			
			[Component]={
				"Position","AnchorPoint","Size","Visible";
			}
		};
	};
end;


return TextSlider
