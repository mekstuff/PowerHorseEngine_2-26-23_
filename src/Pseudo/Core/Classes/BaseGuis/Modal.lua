local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local TweenService = game:GetService("TweenService");

--[=[
	@class Modal

	Inherits [BaseGui], [GUI]
]=]

local Modal = {
	Name = "Modal";
	ClassName = "Modal";
	BackgroundTransparency = 0;
	BackgroundColor3 = Theme.getCurrentTheme().Foreground;
	Size = UDim2.fromOffset(350,0);
	Position = UDim2.fromScale(.5,.5);
	AnchorPoint = Vector2.new(.5,.5);
	Roundness = UDim.new(0,5);
	Header = "Header";
	HeaderIcon = "";
	HeaderTextSize = 20;
	HeaderTextFont = Theme.getCurrentTheme().Font;
	HeaderTextColor3 = Theme.getCurrentTheme().ForegroundText;
	BodyTextSize = 18;
	BodyTextFont = Theme.getCurrentTheme().Font;
	HeaderAdjustment = Enumeration.Adjustment.Center;
	ButtonsAdjustment = Enumeration.Adjustment.Center;
	ButtonsScaled = true;
	Blurred = false;
	Highlighted = false;
	Body = "";
	CloseButtonBehaviour = Enumeration.CloseButtonBehaviour.Display;
};
Modal.__inherits = {"BaseGui","GUI"};



--[=[
	@prop Header string
	@within Modal
]=]
--[=[
	@prop HeaderIcon string
	@within Modal
]=]
--[=[
	@prop HeaderTextSize number
	@within Modal
]=]
--[=[
	@prop HeaderTextFont Enum.Font
	@within Modal
]=]
--[=[
	@prop HeaderTextColor3 Color3
	@within Modal
]=]
--[=[
	@prop BodyTextSize number
	@within Modal
]=]
--[=[
	@prop BodyTextFont Enum.Font
	@within Modal
]=]
--[=[
	@prop HeaderAdjustment Enumeration.Adjustment
	@within Modal
]=]
--[=[
	@prop ButtonsAdjustment Enumeration.Adjustment
	@within Modal
]=]
--[=[
	@prop ButtonsScaled boolean
	@within Modal
]=]
--[=[
	@prop Blurred boolean
	@within Modal
]=]
--[=[
	@prop Highlighted boolean
	@within Modal
]=]
--[=[
	@prop Body string
	@within Modal
]=]
--[=[
	@prop CloseButtonBehaviour Enumeration.CloseButtonBehaviour
	@within Modal
]=]

--//
function Modal:CaptureUserFocus(Pulse:number)
	Pulse = Pulse or 3;
	local PreviousHighlighted = self.Highlighted;
	self.Highlighted = true;
	-- self:_Highlight();
	local HighlightFrame = self._dev.__HighlightFrame;

	task.spawn(function()
		if(not PreviousHighlighted)then
			self._dev.__HighlightFrame.BackgroundTransparency = .4;
		end;
		local t = TweenService:Create(HighlightFrame, TweenInfo.new(.1,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,Pulse,true), {BackgroundTransparency = 1});
		t:Play();
		t.Completed:Wait();
		self.Highlighted = PreviousHighlighted;
	end)
end;
--//
function Modal:AddButton(Text,styles,ID)
	local btns = self._dev.__btns;

	if(not btns)then
		self._dev.__btns = {};
		btns = self._dev.__btns;
	end;

	local Bottom = self:GET("Bottom");
	local App = self:_GetAppModule();

	local newButton = App.new("Button");
	newButton.SupportsRBXUIBase = true
	newButton.RippleStyle = Enumeration.RippleStyle.None;
	newButton.ClickEffect = false;

	if(styles)then
		for a,b in pairs(styles)do
			newButton[a]=b;
		end
	end
	newButton.MouseButton1Up:Connect(function()
		self.ButtonClicked:Fire(newButton,ID);
	end)
	
	newButton.Text = Text or "";
	table.insert(btns,newButton)

	newButton.ZIndex = self.ZIndex;

	newButton._dev._ModalZIndexChanged = self:GetPropertyChangedSignal("ZIndex"):Connect(function()
		newButton.ZIndex = self.ZIndex;
	end);

	newButton.Parent = Bottom;

	self:GetEventListener("ButtonAdded"):Fire(newButton);
	return newButton;
end;

--//
function Modal:_Blur()
	if(not workspace.CurrentCamera)then return end;
	local blur = self._dev.__HighlightBlur;
	if(not blur)then
		local newBlur = Instance.new("BlurEffect",workspace.CurrentCamera);
		newBlur.Size = 0;
		blur = newBlur;
		self._dev.__HighlightBlur = newBlur;
	end;
	TweenService:Create(blur,TweenInfo.new(.4), {Size = 20}):Play();
end
--//
function Modal:_Unblur()
	if(not self._dev.__HighlightBlur)then return end;
	local BlurTween = TweenService:Create(self._dev.__HighlightBlur, TweenInfo.new(.4), {Size = 0});
	BlurTween:Play();
	--self.Blurred=false;
	return BlurTween;
end;

function Modal:OnHighlightClicked(callback:any)
	self:_GetAppModule():GetService("ErrorService").assert(typeof(callback) == "function", ("function expected for callback, got %s"):format(typeof(callback)));
	if(not self._OnHighlightClickedCallbacks)then
		self._OnHighlightClickedCallbacks = {};
	end;
	table.insert(self._OnHighlightClickedCallbacks, callback);
end

--//
function Modal:_Highlight()
	local HighlightFrame = self._dev.__HighlightFrame;

	if(not HighlightFrame)then
		HighlightFrame = Instance.new("TextButton");
		HighlightFrame.AutoButtonColor = false;
		HighlightFrame.Name = "HighlightFrame";
		HighlightFrame.BackgroundTransparency = 1;
		HighlightFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0);
		HighlightFrame.BorderSizePixel = 0;
		HighlightFrame.ZIndex = self.ZIndex-1;
		HighlightFrame.Text = "";
		HighlightFrame.AnchorPoint = Vector2.new(.5,.5);
		HighlightFrame.Position = UDim2.fromScale(.5,.5);
		HighlightFrame.Size = UDim2.new(1,1000,1,1000);
		HighlightFrame.Parent = self:GetRef();
		self._dev.__HighlightFrame = HighlightFrame;

		self._dev._HighlightDownEvent = HighlightFrame.MouseButton1Click:Connect(function()
			if(self._OnHighlightClickedCallbacks)then
				for _,x in pairs(self._OnHighlightClickedCallbacks) do
					x();
				end
			end
		end);
	
	end;
	
	TweenService:Create(HighlightFrame, TweenInfo.new(.4), {BackgroundTransparency = .25}):Play();
end;

--//
function Modal:_Unhighlight()
	local HighlightFrame = self._dev.__HighlightFrame;

	if(HighlightFrame)then
		TweenService:Create(HighlightFrame, TweenInfo.new(.4), {BackgroundTransparency = 1}):Play();
	end;
end;

--//
function Modal:_AdjustButtons()
	if(self._dev.__btns)then
		
		local Value = self.ButtonsScaled;
		local Bottom = self:GET("Bottom");
		local Bottom_List = self:GET("Bottom_List")
		local total = #self._dev.__btns
		for _,btn in pairs(self._dev.__btns)do

			if(Value == true) then
				btn.TextAdjustment = Enumeration.Adjustment.Center;
				btn.ButtonFlexSizing = false;
				btn.Size = UDim2.new(0,(Bottom.AbsoluteSize.X/total)-Bottom_List.Padding.Offset,0,35);	
			else
				btn.ButtonFlexSizing = true;
			end

		end
	end
end;

--//
function Modal:_Render(App)
	
	self._MainFrame = App.new("Frame", self:GetRef());
	--Modal.AutomaticSize = Enum.AutomaticSize.XY; 15/11/2021
	self._MainFrame.AutomaticSize = Enum.AutomaticSize.Y;
	local ModalContainer = self._MainFrame:GetGUIRef()
	-- Modal.StrokeTransparency = 1;
	
	local ListLayout = Instance.new("UIListLayout",ModalContainer);
	ListLayout.SortOrder = Enum.SortOrder.Name;
	ListLayout.Padding = UDim.new(0,10);
	ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
	ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top;

	local Padding = Instance.new("UIPadding",ModalContainer);
	Padding.PaddingTop = UDim.new(0,5);
	Padding.PaddingLeft = UDim.new(0,10);
	Padding.PaddingRight = UDim.new(0,10);
	Padding.PaddingBottom = UDim.new(0,5);

	local Top = Instance.new("Frame", ModalContainer);
	Top.BackgroundTransparency = 1;
	Top.AutomaticSize = Enum.AutomaticSize.Y;
	Top.Size = UDim2.new(1);
	Top.Name = "A";

	self._Header = App.new("Button");
	self._Header.TextColor3 = Theme.getCurrentTheme().ForegroundText;
	self._Header.BackgroundTransparency = 1;
	self._Header.StrokeTransparency = 1;
	self._Header.Font = Theme.getCurrentTheme().Font;
	self._Header.RippleStyle = App.Enumeration.RippleStyle.None;
	-- Header.ActiveBehaviour = App.Enumeration.ActiveBehaviour.None;
	self._Header.IconAdaptsTextColor = false;
	self._Header.HoverEffect = Enumeration.HoverEffect.None; --< HoverEffect.None 
	self._Header.Parent = Top;
	
--[=[
	@prop ButtonClicked PHeSignal
	@within Modal
]=]
	self:AddEventListener("ButtonClicked",true);
--[=[
	@prop ButtonClicked PHeSignal
	@within Modal
]=]
	self:AddEventListener("ButtonAdded",true);
	
	local CloseButton = App.new("CloseButton",Top);
	CloseButton.Size = UDim2.new(0,0,1);
	-- CloseButton.Position = UDim2.new(1)
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
	UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
	UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
	UIAspectRatioConstraint.Parent = CloseButton:GetGUIRef();

	
	self._dev._closebuttonconnection = CloseButton.Activated:Connect(function()
		self.ButtonClicked:Fire(CloseButton, "close");
		if(self.CloseButtonBehaviour == Enumeration.CloseButtonBehaviour.Hide)then
			self.Visible = false;
		elseif(self.CloseButtonBehaviour == Enumeration.CloseButtonBehaviour.Destroy)then
			self:Destroy();
		end
	end)

	local Center = Instance.new("Frame", ModalContainer);
	--Center.AutomaticSize = Enum.AutomaticSize.XY; --< For automatic size on XY (disabled because of offset bug)
	Center.AutomaticSize = Enum.AutomaticSize.Y; --< Offset fix;
	Center.Size = UDim2.new(1);
	Center.BackgroundTransparency = 1;
	Center.Name = "C";


	local Bottom = Instance.new("Frame", ModalContainer);
	Bottom.AutomaticSize = Enum.AutomaticSize.Y;
	Bottom.Name = "E";
	--Bottom.Size = UDim2.fromScale(1,0);
	Bottom.Size = UDim2.new(1);
	Bottom.BackgroundTransparency = 1;
	local Bottom_List = Instance.new("UIListLayout",Bottom);
	Bottom_List.Padding = UDim.new(0,5);
	Bottom_List.VerticalAlignment = Enum.VerticalAlignment.Top;
	Bottom_List.FillDirection = Enum.FillDirection.Horizontal;
	Bottom_List.SortOrder = Enum.SortOrder.Name;
	-- Bottom_List.
	Bottom_List.Name = "FILTER_BOTTOM_LIST"
	Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Right;
	
	--Center:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	--	--Bottom.Size = UDim2.fromOffset(Center.AbsoluteSize.X-5);
	--end)
	
	--[[
	Modal:GetGUIRef():GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		--print(Modal:GetGUIRef().AbsoluteSize);
		Bottom.Size = UDim2.fromOffset(Modal:GetGUIRef().AbsoluteSize.X-(Padding.PaddingLeft.Offset+Padding.PaddingTop.Offset));
		self:_AdjustButtons();
		--print("Update")
	end)
	]]
	

	return {
		["ZIndex"] = function(v)
			self._MainFrame.ZIndex = v;
			Top.ZIndex = v;
			self._Header.ZIndex = v;
			CloseButton.ZIndex = v;
			Center.ZIndex = v;
			Bottom.ZIndex = v;

			if(self._dev.__HighlightFrame)then
				self._dev.__HighlightFrame = v-1;
			end
			
		end;
		["CloseButtonBehaviour"] = function(v)
			if(v == Enumeration.CloseButtonBehaviour.None)then
				CloseButton.Visible = false;
			else
				CloseButton.Visible = true;
			end
		end,

		["Body"] = function(Value)
			if(Value ~= "")then
				if(not self._dev.__ModalBody)then
					local txt = App.new("Text");
					txt.TextWrapped = true;
					txt.BackgroundTransparency = 1;
					txt.AutomaticSize = Enum.AutomaticSize.Y;
					txt.TextColor3 = Theme.getCurrentTheme().ForegroundText;
					--txt.Size = self.ModalSize.X ~= 0 and  UDim2.new(1) or UDim2.fromOffset(300);
					txt.Size = UDim2.new(1);
					txt.TextSize = self.BodyTextSize;
					txt.Font = self.BodyTextFont;
					self._dev.__ModalBody = txt;	
					self._Components["Body"]=txt;
				
					txt.Parent = self;					
				end;
				--if(self._dev.__ModalBody)then self._dev.__ModalBody.Visible = false;end;
			--else
				--if(self._dev.__ModalBody)then self._dev.__ModalBody.Visible = false;end;
			end;
			if(self._dev.__ModalBody)then
				self._dev.__ModalBody.Text = Value;
			end;
		end,
		["ButtonsScaled"] = function(Value)
			-- self:_AdjustButtons();
		end,
		["Blurred"] = function(Value)
			if(Value)then
				self:_Blur();
			else
				self:_Unblur();
			end
		end,
		["Highlighted"] = function(Value)
			if(Value)then
				self:_Highlight();
			else
				self:_Unhighlight();
			end
		end,
		["Header"] = function(Value)
			self._Header.Text = Value;
		end,["HeaderIcon"] = function(Value)
			self._Header.Icon = Value;
		end,["HeaderTextSize"] = function(Value)
			self._Header.TextSize = Value;
		end,
		["HeaderTextColor3"] = function(Value)
			self._Header.TextColor3 = Value;
			CloseButton.Color = Value;
		end,
		["HeaderTextFont"] = function(Value)
			self._Header.Font = Value;
		end,["BodyTextFont"] = function(Value)
			if(self._dev.__ModalBody)then
				self._dev.__ModalBody.Font = Value;
			end
		end,
		["BodyTextSize"] = function(Value)
			if(self._dev.__ModalBody)then
				self._dev.__ModalBody.Size = Value;
			end
		end,
		["HeaderAdjustment"] = function(Value)
			if(Value == Enumeration.Adjustment.Left)then
				self._Header.Position = UDim2.new(0);
				self._Header.AnchorPoint = Vector2.new(0);
			else
				self._Header.Position = UDim2.fromScale(.5,0);
				self._Header.AnchorPoint = Vector2.new(.5);
			end
		end,
		["ButtonsAdjustment"] = function(Value)
			if(Value == Enumeration.Adjustment.Left)then
				Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Left;
			elseif(Value == Enumeration.Adjustment.Center)then
				Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			else
				Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Right;
			end;
		end,
		["Visible"] = function()
			self._MainFrame.Visible = false;
		end;
		_Components = {
			_Appender = Center;	
			FatherComponent = self._MainFrame:GetGUIRef();
			Bottom = Bottom;
			Bottom_List = Bottom_List;
			Top = Top;
			Header = self._Header;
			Center = Center;
			CloseButton = CloseButton;
			Wrapper = self._MainFrame;
			ModalContainer = ModalContainer;
			Modal = self._MainFrame;
		};
		_Mapping = {
			[self._MainFrame] = {
				"BackgroundColor3","BackgroundTransparency","Size","Position",
				"AnchorPoint","Roundness","StrokeColor3","StrokeTransparency","StrokeThickness"
			}
		};
	};
end;


return Modal
