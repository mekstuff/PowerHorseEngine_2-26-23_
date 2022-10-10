local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
-- local Core_Vanilla = require(script.Parent.Parent.Parent.Vanilla);

local Button = {
	Name = "Button";
	ClassName = "Button";
	Icon = "";
	IconSize = UDim2.fromOffset(20,20);
	IconAdaptsTextColor = true;
	IconColor3 = Theme.getCurrentTheme().Text;
	Loading = false;
	TextAdjustment = Enumeration.Adjustment.Flex;
	IconAdjustment = Enumeration.Adjustment.Flex;
	ButtonFlexSizing = true;
	Roundness = UDim.new(0,4);
	
	RippleColor = Theme.getCurrentTheme().Text;
	RippleTransparency = .5;
	RippleStyle = Enumeration.RippleStyle.None; -- Enumeration.RippleStyle.Dynamic;
	RippleLifeTime = .75;
	ClickEffect = false;
	Size = UDim2.fromOffset(120,35);
	Padding = Vector2.new(5,5);
};
Button.__inherits = {"Frame","GUI","BaseGui","Text"};

local TweenService = game:GetService("TweenService");
--//

local function generateRipple(self, noAnimate)

	if(self.RippleStyle == Enumeration.RippleStyle.None)then return end;
	local Mouse = Core_Vanilla.Mouse;
	if(not Mouse)then warn("No mouse found, can't ripple") return end;
	local component = self:GetGUIRef();
	local RippleAssetID = "http://www.roblox.com/asset/?id=4560909609";

	local RippleWrapper = Instance.new("Frame", component);
	RippleWrapper.Size = UDim2.new(1,0,1,0);
	RippleWrapper.BackgroundTransparency = 1;
	RippleWrapper.ClipsDescendants = true;
	local Ripple = Instance.new("ImageLabel", RippleWrapper);
	Ripple.Size = UDim2.new(0);
	Ripple.BorderSizePixel = 0;
	Ripple.BackgroundTransparency = 1;
	Ripple.Image = RippleAssetID;
	Ripple.ImageColor3 = self.RippleColor or Theme.getCurrentTheme().Text;
	Ripple.ImageTransparency =  self.RippleTransparency;
	Ripple.ScaleType = Enum.ScaleType.Fit;


	local RippleTime = self.RippleLifeTime;
	local xAbs, yAbs = (Mouse.X - Ripple.AbsolutePosition.X), (Mouse.Y - Ripple.AbsolutePosition.Y);



	local tPosition = self.RippleStyle == Enumeration.RippleStyle.Static and  UDim2.new(.5,0,.5,0) or UDim2.new(0, xAbs,0, yAbs)
	--local tSize = UDim2.new(1, component.AbsoluteSize.X, 1, component.AbsoluteSize.Y);
	local tSize = UDim2.new(1, 400, 1, 400);
	Ripple.AnchorPoint = Vector2.new(.5,.5);	
	Ripple.Position = tPosition;

	if(not noAnimate)then
		local T = TweenService:Create(Ripple, TweenInfo.new(RippleTime), {ImageTransparency = 1, Size = tSize})
		T:Play();
		T.Completed:Wait();
		RippleWrapper:Destroy();
	else
		return Ripple;
	end;

end;

--//
function Button:AddSubButton(Button,Adjustment)
	if(Button.ClassName ~= "Button")then Core.tossWarn("AddSubButton(pseudo Button) failed. Did you pass a button as the first argument?");return;end;
	Adjustment = Adjustment or Enumeration.Adjustment.Right;
	if(not self._dev._subbtns)then self._dev._subbtns = {};end;
	
	if(not self._dev._subbtns[Adjustment])then
		self._dev._subbtns[Adjustment] = {};
		local Wrapper = Instance.new("Frame",self:GetGUIRef());
		Wrapper.Position = UDim2.new(1,15,.5);
		Wrapper.AnchorPoint = Vector2.new(0,.5);
		Wrapper.Size = UDim2.new(0,300,1,0);
		Wrapper.BackgroundTransparency = 1;
		Wrapper.Visible = false;
		local UIList = Instance.new("UIListLayout");
	
		UIList.FillDirection = Enum.FillDirection.Horizontal;
		UIList.SortOrder = Enum.SortOrder.LayoutOrder;
		UIList.Parent = Wrapper;
		UIList.Padding = UDim.new(0,13);
		UIList.VerticalAlignment = Enum.VerticalAlignment.Center;
		self._dev._subbtns[Adjustment].Wrapper = Wrapper;
	end;
	
	local RespectGrid = Instance.new("Frame");
	RespectGrid.AutomaticSize = Enum.AutomaticSize.XY;
	RespectGrid.BackgroundTransparency = 1;
	Button.Parent = RespectGrid;
	--table.insert(self._dev._subbtns[Adjustment],RespectGrid);
	RespectGrid.Parent = self._dev._subbtns[Adjustment].Wrapper;
	
	if(not self._dev.__submenulisten)then
		self._dev.__submenuexpanded = false;
		self._dev.__submenulisten = self.MouseButton1Down:Connect(function()
			if(self._dev.__submenuexpanded)then
				for _,v in pairs(self._dev._subbtns) do
					v.Wrapper.Visible = false;
				end;
				self._dev.__submenuexpanded = false;
			else
				for _,v in pairs(self._dev._subbtns) do
					v.Wrapper.Visible = true;
				end;
				self._dev.__submenuexpanded = true;
			end
		end)
	end
	
end

--//
function Button:RippleEffect()
	generateRipple(self);
end;

--//
function Button:JiggleEffect()
	if(not self._jiggling)then
		-- self._dev_lockConnection = false;
		self._jiggling = true;
		local Frame = self:GET("Frame");
		
		local TargetSize = self.Size + UDim2.fromOffset(7,7);
		
		local PopOut = self:CreateTween(TweenInfo.new(.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Size = TargetSize}, Frame:GetGUIRef());
		PopOut:Play();
		
		PopOut.Completed:Connect(function()
			
			if(self and self._dev)then
			
			local PopIn = self:CreateTween(TweenInfo.new(.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {Size = self.Size}, Frame:GetGUIRef());
			PopIn:Play();
			
			PopIn.Completed:Connect(function()
				self._jiggling = false;
			end)
			end;
		end)
		
		
		
	end
end;

function Button:_Render(App)

	local Frame = App.new("Frame", self:GetRef());
	Frame.Name = "$l_Frame";
	-- local MB1D = self:AddEventListener("MouseButton1Down", true, Frame:GetEventListener("MouseButton1Down"));
	-- local MB1U = self:AddEventListener("MouseButton1Up", true, Frame:GetEventListener("MouseButton1Up"));
	-- self:AddEventListener("MouseButton2Down", true, Frame:GetEventListener("MouseButton2Down"));
	-- self:AddEventListener("MouseButton2Up", true, Frame:GetEventListener("MouseButton2Up"));

	local ButtonEventer = Instance.new("TextButton");
	ButtonEventer.Name = "$l_PHe_BtnEventer";
	ButtonEventer.Size = UDim2.fromScale(1,1);
	ButtonEventer.BackgroundTransparency = 1;
	ButtonEventer.Text = "";
	ButtonEventer.Parent = Frame:GetGUIRef();

	local MB1D = self:AddEventListener("MouseButton1Down",true);
	local MB1U = self:AddEventListener("MouseButton1Up",true);
	local MB2D = self:AddEventListener("MouseButton2Down",true);
	local MB2U = self:AddEventListener("MouseButton2Up",true);
	local MB1C = self:AddEventListener("MouseButton1Click",true);
	local MB2C = self:AddEventListener("MouseButton2Click",true);
	
	self:AddEventListener("MouseEnter", true, Frame:GetEventListener("MouseEnter"));
	self:AddEventListener("MouseLeave", true, Frame:GetEventListener("MouseLeave"));

	local function fireEvent(e:BindableEvent,...:any):nil
		if(self.Disabled)then return end;
		e:Fire(...);
	end;


	ButtonEventer.MouseButton1Click:Connect(function(...)
		fireEvent(MB1C,...);
	end);
	ButtonEventer.MouseButton2Click:Connect(function(...)
		fireEvent(MB2C,...);
	end);
	ButtonEventer.MouseButton1Down:Connect(function(...)
		fireEvent(MB1D,...);
	end);
	ButtonEventer.MouseButton1Up:Connect(function(...)
		fireEvent(MB1U,...);
	end);
	ButtonEventer.MouseButton2Down:Connect(function(...)
		fireEvent(MB2D,...);
	end);
	ButtonEventer.MouseButton2Up:Connect(function(...)
		fireEvent(MB2U,...);
	end);
--[[
	MB1D:Connect(function()
		--print(self._dev._btnsize);
		
		if(self.ClickEffect and not self.ButtonFlexSizing)then
			local TargetSize = self._dev._btnsize - UDim2.fromOffset(4,4);
			self:CreateTween(TweenInfo.new(.25,Enum.EasingStyle.Quart), {Size = TargetSize}, Frame:GetGUIRef()):Play();
		end;
		self:RippleEffect();
	end);
	
	MB1U:Connect(function()
		
		--print(self._dev._btnsize);
		
		if(self.ClickEffect and not self.ButtonFlexSizing)then
			self:CreateTween(TweenInfo.new(.25,Enum.EasingStyle.Quart), {Size = self._dev._btnsize}, Frame:GetGUIRef()):Play();
		end;
	end)
	
]]
	local TextAndIconWrapper = App.new("Frame", Frame);
	TextAndIconWrapper.Name = "$l_TextAndIconWrapper"
	-- TextAndIconWrapper.BackgroundColor3 = Color3.fromRGB(255,255,255);
	TextAndIconWrapper.BackgroundTransparency = 1;
	TextAndIconWrapper.Size = UDim2.new(1,0,1,0);
	local UIList = Instance.new("UIListLayout",TextAndIconWrapper:GetGUIRef());
	UIList.FillDirection = Enum.FillDirection.Horizontal;
	UIList.SortOrder = Enum.SortOrder.Name;
	UIList.VerticalAlignment = Enum.VerticalAlignment.Center;
	UIList.Padding = UDim.new(0,5)
	UIList.Name = "$l_UIListLayout";
	--self:AddEventListener("MouseButton1Down", true,)
	
	local UIPadding = Instance.new("UIPadding",Frame:GetGUIRef());
	UIPadding.Name = "$l_UIPadding";
	-- UIPadding.PaddingLeft = UDim.new(0,5);
	-- UIPadding.PaddingRight = UDim.new(0,5);
	
	local Text = App.new("Text", TextAndIconWrapper);
	local TextRef = Text:GetGUIRef();
	Text.SupportsRBXUIBase = true;
	Text.Name = "$l_Text";
	Text.BackgroundColor3 = Color3.fromRGB(255, 85, 88)
	--Text.Name = "b";
	Text.Size = UDim2.new(0);
	Text.AutomaticSize = Enum.AutomaticSize.XY;
	Text.AnchorPoint = Vector2.new(0,.5);
	Text.Position = UDim2.fromScale(0,.5);
	Text.BackgroundTransparency = 1;
	
	--Text.Size = UDim2.new(0,5,0,0);
--[[
	local IconWrapper = App.new("Frame", TextAndIconWrapper);
	IconWrapper.Name = "$l_icon_wrapper";
	IconWrapper.SupportsRBXUIBase = true;
	IconWrapper.Position = UDim2.new(0,1,0,0);
	IconWrapper.BackgroundTransparency = .6;
	IconWrapper.BackgroundColor3 = Color3.fromRGB(0,255,0)
	IconWrapper.Size = UDim2.fromScale(1,1);
	local IconWrapperAspectRatioConstraint = Instance.new("UIAspectRatioConstraint",IconWrapper:GetGUIRef());
	IconWrapperAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
	]]
	
	local IconImage = App.new("Image", TextAndIconWrapper);
	local IconImageRef = IconImage:GetGUIRef();
	-- IconImageRef.Name = "a_l$"
	IconImage.Name = "Icon";
	IconImage.BackgroundTransparency = 1;
	IconImage.BackgroundColor3 = Color3.fromRGB(0,255,0)
	IconImage.Size = UDim2.new(1,0,1,0);
	IconImage.ScaleType = Enum.ScaleType.Fit;
	IconImage.SupportsRBXUIBase = true;
	local IconAspectRatioConstraint = Instance.new("UIAspectRatioConstraint",IconImage:GetGUIRef());
	IconAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Width
	local IconSizeConstraint = Instance.new("UISizeConstraint",IconImage:GetGUIRef());
	
	local ProgressRadial_Loading; --<Not created unless .loading = true
	
	local LeftAdjustment,CenterAdjustment,RightAdjustment = Enumeration.Adjustment.Left,Enumeration.Adjustment.Center,Enumeration.Adjustment.Right;
	local _str = "_$l";
	
	local function nameContent(content,adjustment,inf)
		if(adjustment == CenterAdjustment)then
			content.Name = "b"..inf.._str;
		elseif(adjustment == RightAdjustment)then
			content.Name = "c"..inf.._str;
		else
			content.Name = "a"..inf.._str;
		end
	end;

	local function PositionTextAndImage()
		if(self.ButtonFlexSizing)then
			IconSizeConstraint.MaxSize = Vector2.new(math.huge,self.TextSize);
		end;
		nameContent(IconImage:GetGUIRef(),self.IconAdjustment,"A");
		nameContent(Text:GetGUIRef(),self.TextAdjustment,"B");

		if(self.IconAdjustment == CenterAdjustment and self.TextAdjustment == CenterAdjustment)then
			UIList.FillDirection = Enum.FillDirection.Vertical;
			UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center;

		else
			if(self.TextAdjustment == CenterAdjustment)then
				UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			elseif(self.TextAdjustment == RightAdjustment)then
				UIList.HorizontalAlignment = Enum.HorizontalAlignment.Right;
			else
				UIList.HorizontalAlignment = Enum.HorizontalAlignment.Left;
			end
			UIList.FillDirection = Enum.FillDirection.Horizontal;	
		end
	end;


	

	--[[
	local function PositionTextAndImage()
		--print(self.IconAdjustment)
		if(self.IconAdjustment == Enumeration.Adjustment.Right)then
			IconWrapper.Name = "d";
		elseif(self.IconAdjustment == Enumeration.Adjustment.Left)then
			IconWrapper.Name = "a";
		elseif(self.IconAdjustment == Enumeration.Adjustment.Center)then
			IconWrapper.Name = "b";
		else
			IconWrapper.Name = "a";
		end;
		if(self.TextAdjustment == Enumeration.Adjustment.Right)then
			Text.Name = "c";
			Text.TextXAlignment = Enum.TextXAlignment.Right;
		elseif(self.TextAdjustment == Enumeration.Adjustment.Left)then
			Text.Name = "a";
			Text.TextXAlignment = Enum.TextXAlignment.Left;
		elseif(self.TextAdjustment == Enumeration.Adjustment.Center)then
			Text.Name = "b";
			Text.TextXAlignment = Enum.TextXAlignment.Center;
		else
			Text.Name = "a";
			Text.TextXAlignment = Enum.TextXAlignment.Left;
		end;
		
		if(self.IconAdjustment == Enumeration.Adjustment.Center and self.TextAdjustment == Enumeration.Adjustment.Center)then
			IconWrapper.Name = "a";
			Text.Name = "b";
			--IconWrapper.Size = UDim2.new(1,0,.3,0);
			--Text.Size = UDim2.new(1,0,.7,0);
			UIList.FillDirection = Enum.FillDirection.Vertical;
			UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center;
			
		--elseif(self.IconAdjustment == Enumeration.Adjustment.Right)then
		--	IconWrapper.Name = "c";
		
		else
			--IconWrapper.Name = "a";
			--Text.Name = "b";
			UIList.FillDirection = Enum.FillDirection.Horizontal;
			UIList.VerticalAlignment = Enum.VerticalAlignment.Center;
		end;
	end;


	-- local _lockConnection = false;
	local function update()
		if(self._jiggling)then return end;
		if(self._dev._lockConnection)then return end;
		self._dev._lockConnection = true;
		-- print("Updating icon and more")
		-- if(self.Text ~= "")then
			-- IconWrapper.Size = UDim2.fromOffset(Frame:GetGUIRef().AbsoluteSize.Y,Frame:GetGUIRef().AbsoluteSize.Y);
		-- else
			-- print("Big", self.Text)
			-- IconWrapper.Size = UDim2.fromScale(1,1);

		-- end
		-- IconWrapper.Size = self.Text ~= "" and UDim2.fromOffset(Frame:GetGUIRef().AbsoluteSize.Y,Frame:GetGUIRef().AbsoluteSize.Y) or UDim2.fromScale(1,1);
		if(not self.ButtonFlexSizing)then
			if(self.Icon ~= "")then
				Text.Size = UDim2.new(1,-Frame:GetGUIRef().AbsoluteSize.Y, 1);
				IconWrapper.Size =  UDim2.fromOffset(Frame:GetGUIRef().AbsoluteSize.Y,Frame:GetGUIRef().AbsoluteSize.Y);
			else
				if(self.Text == "")then
					IconWrapper.Size = UDim2.new(1,0,1,0);
				else
					Text.Size = UDim2.new(1,0,1);
					IconWrapper.Size =  UDim2.fromOffset(Frame:GetGUIRef().AbsoluteSize.Y,Frame:GetGUIRef().AbsoluteSize.Y);
				end
			end;
			
		else

			if(self.TextAdjustment == CenterAdjustment and self.IconAdjustment == CenterAdjustment)then
				-- print("Thisss")
				IconWrapper.Size = UDim2.new(1,0,0,self.TextSize*2)
			else
				IconWrapper.Size =  UDim2.fromOffset(Frame:GetGUIRef().AbsoluteSize.Y,Frame:GetGUIRef().AbsoluteSize.Y);
				
			end;

			-- Text.Size 
		end
		self._dev_lockConnection = false;
	end;
	self._dev._ccfr = Frame:GetGUIRef():GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		update();
	end);
]]
	return {
		["IconSize"] = function(v)
			if(v ~= UDim2.new(0))then
				IconImage.Size = v;
				IconSizeConstraint.Parent = nil;
			else
				IconSizeConstraint.Parent = IconImageRef;
			end
		end;
		["TextSize"] = function(v)
			PositionTextAndImage();
		end;
		["ZIndex"] = function(Value)
			Frame.ZIndex = Value;
			Text.ZIndex = Value;
			ButtonEventer.ZIndex = Value;
			IconImage.ZIndex = Value; 	
		end,
		_Components = {
			Text = Text;
			Icon = IconImage;
			FatherComponent = Frame:GetGUIRef();
			Frame = Frame;
		};
		_Mapping = {
			[Frame] = {
				--"AutomaticSize",
				"Active","ActiveBehaviour","ActiveColor","AnchorPoint","BackgroundColor3","BackgroundTransparency",
				"BorderSizePixel","ClipsDescendants","Disabled","FocusEffectEnabled","HoverEffect","OverlayColor3","Position",
				"Rotation","Roundness","StrokeColor3","StrokeThickness","StrokeTransparency","Visible","ToolTip";
				--"Size"	
			};
			[Text] = {
				"Text","TextScaled","TextSize","Font","TextTransparency",
				"RichText","Disabled","TextStrokeTransparency","TextStrokeThickness","TextStrokeColor3";
			
				-- "TextColor3" 
			};

		};
		["TextColor3"] = function(v)
			Text.TextColor3 = v;
			if(self.IconAdaptsTextColor)then
				IconImage.ImageColor3 = v;
			end
		end;
		["IconAdaptsTextColor"] = function(v)
			if(not v)then 
				IconImage.ImageColor3 = self.IconColor3;
			end;
		end;
		["IconColor3"] = function(v)
			if(self.IconAdaptsTextColor)then return end;
			IconImage.ImageColor3 = v
		end;
		["Padding"] = function(v)
			UIPadding.PaddingLeft, UIPadding.PaddingRight = UDim.new(0,v.X),UDim.new(0,v.X);
			UIPadding.PaddingTop, UIPadding.PaddingBottom = UDim.new(0,v.Y),UDim.new(0,v.Y);
		end;
		["Icon"] = function(v)
			if(v == "")then
				-- IconWrapper.Visible = false;
				IconImage.Visible = false;
			else
				-- IconWrapper.Visible = true;
				IconImage.Visible = true;
				IconImage.Image = v;
			end
		end;
		["Text"] = function(v)
			if(v == "")then
				-- IconWrapper.Visible = false;
				Text.Visible = false;
			else
				-- IconWrapper.Visible = true;
				Text.Visible = true;
			end
		end;
		["Size"] = function(v)
			if(not self.ButtonFlexSizing)then 
				Frame.Size = v;
			end;
		end;
		["TextAdjustment"] = function(v)
			PositionTextAndImage();
		end,
		["IconAdjustment"] = function(v)
			PositionTextAndImage();
		end,
		["ButtonFlexSizing"] = function(v)
			if(v)then
				Frame.Size = UDim2.new(0);
				Text.Size = UDim2.new(0);
				Frame.AutomaticSize = Enum.AutomaticSize.XY;
				Text.AutomaticSize = Enum.AutomaticSize.XY;
			else
				Frame.Size = self.Size;
				-- Text.AutomaticSize = Enum.AutomaticSize.None;
				Frame.AutomaticSize = Enum.AutomaticSize.None;
				-- PositionTextAndImage();
			end;
		end;
	};
end;


return Button
