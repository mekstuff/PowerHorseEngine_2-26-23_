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
	HeaderIconColor3 = Theme.getCurrentTheme().ForegroundText;
	HeaderIconAdaptsHeaderTextColor = true;
	HeaderIconSize = UDim2.fromOffset(20,20);
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

function Modal:_ApplyuseSkinPropertiesToSelf(targetSelf:any)
	targetSelf = targetSelf or self;
	local skin = self._dev.args.useSkin;
	if(targetSelf:IsA("Prompt"))then
		targetSelf.StartAnchorPoint = skin.AnchorPoint;
		targetSelf.StartPosition = skin.Position;
	end;
	if(self.__targetHeader)then
		targetSelf.Header = self.__targetHeader.Text;
		targetSelf.HeaderTextFont = self.__targetHeader.Font;
		targetSelf.HeaderTextSize = self.__targetHeader.TextSize;
		targetSelf.HeaderTextColor3 = self.__targetHeader.TextColor3;
	end
	targetSelf.AnchorPoint = skin.AnchorPoint;
	targetSelf.Position = skin.Position;
	targetSelf.BackgroundColor3 = skin.BackgroundColor3;
	targetSelf.BackgroundTransparency = skin.BackgroundTransparency;
	targetSelf.Size = skin.Size;
end
--//
function Modal:_Render(App)
	
	local args = self._dev.args;
	local useSkin = args and args.useSkin;

	local MainFrame,ModalContainer,ListLayout,CloseButton,Header,Top,Center,Bottom,Bottom_List;

	if(not useSkin)then
		MainFrame = App.new("Frame");
		MainFrame.AutomaticSize = Enum.AutomaticSize.Y;
	
		ModalContainer = MainFrame:GetGUIRef()
		ListLayout = Instance.new("UIListLayout",ModalContainer);
		ListLayout.SortOrder = Enum.SortOrder.Name;
		ListLayout.Padding = UDim.new(0,10);
		ListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left;
		ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top;

		local Padding = Instance.new("UIPadding",ModalContainer);
		Padding.PaddingTop = UDim.new(0,5);
		Padding.PaddingLeft = UDim.new(0,10);
		Padding.PaddingRight = UDim.new(0,10);
		Padding.PaddingBottom = UDim.new(0,5);
	
		Top = Instance.new("Frame", ModalContainer);
		Top.BackgroundTransparency = 1;
		Top.AutomaticSize = Enum.AutomaticSize.Y;
		Top.Size = UDim2.new(1);
		Top.Name = "A";

		Header = App.new("Button");
		Header.TextColor3 = Theme.getCurrentTheme().ForegroundText;
		Header.BackgroundTransparency = 1;
		Header.StrokeTransparency = 1;
		Header.Font = Theme.getCurrentTheme().Font;
		Header.RippleStyle = App.Enumeration.RippleStyle.None;
		Header.HoverEffect = Enumeration.HoverEffect.None; --< HoverEffect.None 
		Header.Parent = Top;

		CloseButton = App.new("CloseButton",Top);
		CloseButton.Size = UDim2.new(0,0,1);
		local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint");
		UIAspectRatioConstraint.AspectType = Enum.AspectType.ScaleWithParentSize;
		UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height;
		UIAspectRatioConstraint.Parent = CloseButton:GetGUIRef();

		Center = Instance.new("Frame", ModalContainer);
		Center.AutomaticSize = Enum.AutomaticSize.Y; --< Offset fix;
		Center.Size = UDim2.new(1);
		Center.BackgroundTransparency = 1;
		Center.Name = "C";

		Bottom = Instance.new("Frame", ModalContainer);
		Bottom.AutomaticSize = Enum.AutomaticSize.Y;
		Bottom.Name = "E";
		Bottom.Size = UDim2.new(1);
		Bottom.BackgroundTransparency = 1;
		Bottom_List = Instance.new("UIListLayout",Bottom);
		Bottom_List.Padding = UDim.new(0,5);
		Bottom_List.VerticalAlignment = Enum.VerticalAlignment.Top;
		Bottom_List.FillDirection = Enum.FillDirection.Horizontal;
		Bottom_List.SortOrder = Enum.SortOrder.Name;
		Bottom_List.Name = "FILTER_BOTTOM_LIST"
		Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Right;
	else
		-- self.Size = useSkin.Size;
		-- self.BackgroundTransparency = useSkin.BackgroundTransparency;
		MainFrame = useSkin:IsA("Pseudo") and useSkin or App:Import("Pointer")(useSkin);
		Header = MainFrame:FindFirstChild("Header") or MainFrame:FindFirstChild("$Header",true);
		self.__targetHeader = Header;
		self:_ApplyuseSkinPropertiesToSelf();
	end;

	MainFrame.Parent = self:GetRef();
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

	if(CloseButton)then
		self._dev._closebuttonconnection = CloseButton.Activated:Connect(function()
			self.ButtonClicked:Fire(CloseButton, "close");
			if(self.CloseButtonBehaviour == Enumeration.CloseButtonBehaviour.Hide)then
				self.Visible = false;
			elseif(self.CloseButtonBehaviour == Enumeration.CloseButtonBehaviour.Destroy)then
				self:Destroy();
			end
		end)
	end;

	return function (Hooks:PseudoHooks)
		local useEffect,useMapping,useComponents = Hooks.useEffect,Hooks.useMapping,Hooks.useComponents;
		
		useMapping({"Visible","BackgroundColor3","BackgroundTransparency","Size","Position",
		"AnchorPoint","Roundness","StrokeColor3","StrokeTransparency","StrokeThickness"}, {MainFrame});

		useMapping({"ZIndex"}, {MainFrame,Top,Header,CloseButton,Center,Bottom});

		useEffect(function()
			if(self._dev.__HighlightFrame)then
				self._dev.__HighlightFrame = self.ZIndex-1;
			end
		end,{"ZIndex"});

		useEffect(function()
			if(CloseButton)then				
				if(self.CloseButtonBehaviour == Enumeration.CloseButtonBehaviour.None)then
					CloseButton.Visible = false;
				else
					CloseButton.Visible = true;
				end
			end
		end,{"CloseButtonBehaviour"});

		useEffect(function()
			if(self.Body ~= "")then
				if(not self._dev.__ModalBody)then
					local txt = App.new("Text");
					txt.TextWrapped = true;
					txt.BackgroundTransparency = 1;
					txt.AutomaticSize = Enum.AutomaticSize.Y;
					txt.TextColor3 = Theme.getCurrentTheme().ForegroundText;
					txt.Size = UDim2.new(1);
					txt.TextSize = self.BodyTextSize;
					txt.Font = self.BodyTextFont;
					self._dev.__ModalBody = txt;
					self._Components["Body"]=txt;
				
					txt.Parent = self;
				end;
			end;
			if(self._dev.__ModalBody)then
				self._dev.__ModalBody.Text = self.Body;
			end;
		end,{"Body"});

		useEffect(function()
			if(self.Blurred)then
				self:_Blur();
			else
				self:_Unblur();
			end;
		end,{"Blurred"});

		useEffect(function()
			if(self.Highlighted)then
				self:_Highlight();
			else
				self:_Unhighlight();
			end;
		end,{"Highlighted"});

		useMapping({
			["Header"] = "Text",
			["HeaderTextSize"] = "TextSize",
			["HeaderTextColor3"] = "TextColor3",
			["HeaderTextFont"] = "Font",
		}, {Header});

		if(not useSkin)then
			useMapping({
				["HeaderIcon"] = "Icon",
				["HeaderIconColor3"] = "IconColor3",
				["HeaderIconSize"] = "IconSize",
			},{Header});
			useEffect(function()
				if(self.HeaderAdjustment == Enumeration.Adjustment.Left)then
					Header.Position = UDim2.new(0);
					Header.AnchorPoint = Vector2.new(0);
				else
					Header.Position = UDim2.fromScale(.5,0);
					Header.AnchorPoint = Vector2.new(.5);
				end
			end,{"HeaderAdjustment"});
			useEffect(function()
				if(self.ButtonsAdjustment == Enumeration.Adjustment.Left)then
					Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Left;
				elseif(self.ButtonsAdjustment == Enumeration.Adjustment.Center)then
					Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Center;
				else
					Bottom_List.HorizontalAlignment = Enum.HorizontalAlignment.Right;
				end;	
			end,{"ButtonsAdjustment"});
		end

		useComponents({
			_Appender = useSkin and MainFrame:GetGUIRef() or Center;
			FatherComponent = MainFrame:GetGUIRef();
			Bottom = Bottom;
			Bottom_List = Bottom_List;
			Top = Top;
			Header = Header;
			Center = Center;
			CloseButton = CloseButton;
			Wrapper = MainFrame;
			ModalContainer = ModalContainer;
			Modal = MainFrame;
		})
	end;
	
--[[
	return {
		["ZIndex"] = function(v)
			MainFrame.ZIndex = v;
			Top.ZIndex = v;
			Header.ZIndex = v;
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
			end;
			if(self._dev.__ModalBody)then
				self._dev.__ModalBody.Text = Value;
			end;
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
			Header.Text = Value;
		end,["HeaderIcon"] = function(Value)
			Header.Icon = Value;
		end,["HeaderIconAdaptsHeaderTextColor"] = function(Value)
			Header.IconAdaptsTextColor = Value;
		end,["HeaderIconColor3"] = function(Value)
			Header.IconColor3 = Value;
		end,["HeaderIconSize"] = function(Value)
			Header.IconSize = Value;
		end,
		["HeaderTextSize"] = function(Value)
			Header.TextSize = Value;
		end,
		["HeaderTextColor3"] = function(Value)
			Header.TextColor3 = Value;
			CloseButton.Color = Value;
		end,
		["HeaderTextFont"] = function(Value)
			Header.Font = Value;
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
				Header.Position = UDim2.new(0);
				Header.AnchorPoint = Vector2.new(0);
			else
				Header.Position = UDim2.fromScale(.5,0);
				Header.AnchorPoint = Vector2.new(.5);
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
		["Visible"] = function(Value)
			MainFrame.Visible = Value;
		end;
		_Components = {
			_Appender = Center;	
			FatherComponent = MainFrame:GetGUIRef();
			Bottom = Bottom;
			Bottom_List = Bottom_List;
			Top = Top;
			Header = Header;
			Center = Center;
			CloseButton = CloseButton;
			Wrapper = MainFrame;
			ModalContainer = ModalContainer;
			Modal = MainFrame;
		};
		_Mapping = {
			[MainFrame] = {
				"BackgroundColor3","BackgroundTransparency","Size","Position",
				"AnchorPoint","Roundness","StrokeColor3","StrokeTransparency","StrokeThickness"
			}
		};
	};
	]]
end;


return Modal
