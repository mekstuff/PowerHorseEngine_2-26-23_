local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core_Vanilla = require(script.Parent.Parent.Parent.Vanilla)
local System = require(script.Parent.Parent.Parent.Parent.System);
local Mouse = Core_Vanilla.Mouse;
local Cam = workspace.CurrentCamera;
local UIS = game:GetService("UserInputService");

--[=[
@class Widget

A widget is a window view object. Similar to the current browser window or plugin widgets in studio.
]=]

local Widget = {
	Name = "Widget";
	ClassName = "Widget";
	MinimumSize = Vector2.new(300,250);	
	FullScreen = false;
	CloseButtonVisible = true;
	Static = false;
	WidgetColor = Theme.getCurrentTheme().Disabled;
	WidgetIcon = "";
	Required = false;
	Enabled = true;
	Roundness = UDim.new(0);
	BackgroundTransparency = 0;
	BackgroundColor3 = Theme.getCurrentTheme().Background;
	AutomaticHide = false;
	Dragging = false;
	Scaling = false;
};
Widget.__inherits = {"BaseGui"}


--[=[]=]
function Widget:GetEditableArea()
	return self:GET("WidgetContent");
end;
--//
local borderSize=1;
local function createWidgetBorder(Widget)
	local function makeFrame(Pos,Size,Anchor)
		local frame = Instance.new("Frame", Widget:GetRef());
		frame.Size = Size;
		frame.Position = Pos;
		frame.AnchorPoint = Anchor;
		frame.BackgroundColor3 = Color3.fromRGB(255,255,255);
		frame.BorderSizePixel = 0;
		frame.BackgroundTransparency = 1;
		return frame;
	end
	local top = makeFrame(UDim2.new(0), UDim2.new(1,0,0,borderSize), Vector2.new(0));	
	local bottom = makeFrame(UDim2.new(0,0,1,borderSize), UDim2.new(1,0,0,borderSize), Vector2.new(0,1));	
	local left = makeFrame(UDim2.new(0), UDim2.new(0,borderSize,1,0), Vector2.new(0,0));	
	local right = makeFrame(UDim2.new(1,borderSize), UDim2.new(0,borderSize,1,0), Vector2.new(1,0));	
	return top,right,bottom,left;	
end

--//

local GlobalWidgetsData = {};
local currFocus;
--print("Remember to update and delete global widgets from global widgets data");

local function focus_GlobalWidgetsData(to,req)

end


--//
function Widget:SetFocus(focus,req)
	
end;

--[=[]=]
function Widget:Focus(focus:boolean)
	local Portal = self:GET("Portal");
	local ActivityFrame = self:GET("ActivityFrame");
	if(focus)then
		Portal.ZIndex = self.Required and 3 or 2;
		ActivityFrame.BackgroundTransparency = 1;
	else
		Portal.ZIndex = 1;
		ActivityFrame.BackgroundTransparency = .4;
	end;
end

--[=[]=]
function Widget:Show()

	self:GET("Portal").Visible = true;
	--self:Focus(true);
end;
--[=[]=]
function Widget:Hide()
	self:GET("Portal").Visible = false;
end;
--[=[]=]
function Widget:FlashBorders(Times:number)
	Times = Times or 3;

	if(not self.__dev.__borders)then
		local topBorder, rightBorder, bottomBorder, leftBorder =  createWidgetBorder(self:GET("Widget"));
		self.__dev.__borders = {
			top = topBorder;
			right = rightBorder;
			bottom = bottomBorder;
			left = leftBorder;
		}
	end
	for _,v in pairs(self.__dev.__borders)do
		local Tween = game:GetService("TweenService"):Create(v, TweenInfo.new(.12,Enum.EasingStyle.Quart,Enum.EasingDirection.In,Times,true), {BackgroundTransparency = .1})			
		Tween:Play();	
	end;
end

--//
function Widget:_Render(App)
	local Portal = App.new("Portal", self:GetRef());
	Portal.IgnoreGuiInset = true;
	local WidgetObject = App.new("Frame")	
	WidgetObject.Parent = Portal:GetGUIRef();
	WidgetObject.StrokeTransparency = 0;
	
	local ActivityFrame = Instance.new("Frame", WidgetObject:GetGUIRef());
	ActivityFrame.Name = "__ActivityFrame";
	ActivityFrame.BackgroundTransparency = 1;
	ActivityFrame.BackgroundColor3 = Color3.fromRGB(0);
	ActivityFrame.ZIndex = 4;
	ActivityFrame.Size = UDim2.fromScale(1,1);

	local WidgetTop = App.new("Frame");
	WidgetTop.Parent = WidgetObject:GetGUIRef();
	WidgetTop.Size = UDim2.new(1,0,0,37);
	WidgetTop.BackgroundColor3 = Theme.getCurrentTheme().Disabled;
	WidgetTop.StrokeTransparency = 1;
	WidgetTop.Roundness = UDim.new(0);
	local WidgetBottom = App.new("Frame");
	WidgetBottom.Parent = WidgetObject:GetGUIRef();
	WidgetBottom.Size = UDim2.new(1,0,0,15);
	WidgetBottom.Position = UDim2.fromScale(0,1);
	WidgetBottom.AnchorPoint = Vector2.new(0,1);
	WidgetBottom.BackgroundTransparency = 1;
	WidgetBottom.StrokeTransparency = 1

	local WidgetBottom_ScaleableBtn = Instance.new("TextButton", WidgetBottom:GetGUIRef());
	WidgetBottom_ScaleableBtn.AnchorPoint = Vector2.new(1,.5);
	WidgetBottom_ScaleableBtn.Position = UDim2.new(1,15,.5,0);
	WidgetBottom_ScaleableBtn.Size = UDim2.new(0,10,0,10)
	WidgetBottom_ScaleableBtn.BorderSizePixel = 2;
	WidgetBottom_ScaleableBtn.BorderColor3 = Color3.fromRGB(0);
	WidgetBottom_ScaleableBtn.Text = "";

	local WidgetContent = App.new("Frame");
	WidgetContent.Parent = WidgetObject:GetGUIRef();
	WidgetContent.Size = UDim2.new(1,0,1,-35);
	WidgetContent.Position = UDim2.fromOffset(0,35);
	WidgetContent.BackgroundTransparency = 1
	WidgetContent.StrokeTransparency = 1;

	local WidgetTop_Header = App.new("Button");
	WidgetTop_Header.Parent = WidgetTop:GetGUIRef();
	WidgetTop_Header.Position = UDim2.new(0,10,.5,0);
	WidgetTop_Header.AnchorPoint = Vector2.new(0,.5);
	WidgetTop_Header.Size = UDim2.new(1,-35,1,0);
	WidgetTop_Header.BackgroundTransparency = 1;
	WidgetTop_Header.TextXAlignment = Enum.TextXAlignment.Left;
	WidgetTop_Header.TextTruncate = Enum.TextTruncate.AtEnd;
	WidgetTop_Header.StrokeTransparency = 1;
	WidgetTop_Header.RippleStyle = Enumeration.RippleStyle.None;

	local WidgetTop_ActionButtons = App.new("Frame", WidgetTop);
	WidgetTop_ActionButtons.Size = UDim2.new(1,-30,1,0);
	WidgetTop_ActionButtons.AnchorPoint = Vector2.new(1,.5);
	WidgetTop_ActionButtons.BackgroundTransparency = 1;
	WidgetTop_ActionButtons.Position = UDim2.new(1,-5,.5,0);
	
	local WidgetTop_ActionButtons_List = Instance.new("UIListLayout");
	WidgetTop_ActionButtons_List.HorizontalAlignment = Enum.HorizontalAlignment.Right;
	WidgetTop_ActionButtons_List.VerticalAlignment = Enum.VerticalAlignment.Center;
	WidgetTop_ActionButtons_List.Parent = WidgetTop_ActionButtons:GetGUIRef();
	WidgetTop_ActionButtons_List.SortOrder = Enum.SortOrder.LayoutOrder;
	WidgetTop_ActionButtons_List.FillDirection = Enum.FillDirection.Horizontal;

	local WidgetTop_CloseBtn = App.new("CloseButton");
	WidgetTop_CloseBtn.Name = "z1_$l";
	WidgetTop_CloseBtn.Parent = WidgetTop_ActionButtons;
	WidgetTop_CloseBtn.Position = UDim2.new(1,0,0,0);
	WidgetTop_CloseBtn.Size = UDim2.fromOffset(WidgetTop:GetAbsoluteSize().Y,WidgetTop:GetAbsoluteSize().Y); 
	WidgetTop_CloseBtn.SupportsRBXUIBase = true;

	local WidgetTop_MoveableBtn = Instance.new("TextButton", WidgetTop:GetGUIRef());
	WidgetTop_MoveableBtn.Name = "WidgetMover";
	WidgetTop_MoveableBtn.Size = UDim2.new(1,-30,1,0);
	WidgetTop_MoveableBtn.Text = "";
	WidgetTop_MoveableBtn.BackgroundTransparency = 1;
	self:AddEventListener("OnWindowCloseRequest",true,WidgetTop_CloseBtn:GetEventListener("Activated"));

	self:AddEventListener("OnWindowCloseRequest"):Connect(function()
		if(self.AutomaticHide)then self.Enabled = false;end;
	end)

	local LastAbsolutePosition_FROMBTN;
	local LastAbsoluteSize;
	local ResizeConnection;
	local UISConnection;
	local function Resize()
		local x,y = (Mouse.X-10)-LastAbsolutePosition_FROMBTN.X,(Mouse.Y-10)-LastAbsolutePosition_FROMBTN.Y;
		local X,Y = math.clamp(LastAbsoluteSize.X+x, self.MinimumSize.X, math.huge),math.clamp(LastAbsoluteSize.Y+y, self.MinimumSize.Y, math.huge)
		WidgetObject.Size = UDim2.fromOffset(X,Y);
	end;
	
	local MoveConnection;
	local MoveUISConnection;
	local NormalizedInputValue = {X=.5,Y=.5};
	local yValueForTopbar = 0;

	local function Position()
		WidgetObject.Position = UDim2.fromOffset(Mouse.X-WidgetObject:GetAbsoluteSize().X*NormalizedInputValue.X , (Mouse.Y-yValueForTopbar)+WidgetTop:GetAbsoluteSize().Y *(1-NormalizedInputValue.Y));
	end

	WidgetBottom_ScaleableBtn.MouseButton1Down:Connect(function()
		if(self.Static)then print("Static")return end;
		if(self.FullScreen)then print("Fullscreen")return end;
		LastAbsolutePosition_FROMBTN = WidgetBottom_ScaleableBtn.AbsolutePosition;
		LastAbsoluteSize = WidgetObject:GetAbsoluteSize();
		ResizeConnection = game:GetService("RunService").RenderStepped:Connect(Resize);	
		UISConnection = UIS.InputEnded:Connect(function(InputType)
		self.Scaling = true;
			if(InputType.UserInputType == Enum.UserInputType.MouseButton1)then
				UISConnection:Disconnect();
				UISConnection = nil;
				if(ResizeConnection)then
					ResizeConnection:Disconnect();
					ResizeConnection=nil;
					self.Scaling = false;
				end;
			end;
		end)
	end);

	WidgetTop_MoveableBtn.MouseButton1Down:Connect(function()
		if(self.FullScreen)then print("Fullscreen")return end;
		local DifferenceX = Mouse.X-WidgetObject:GetAbsolutePosition().X;
		local DifferenceY = Mouse.Y-WidgetObject:GetAbsolutePosition().Y;	
		NormalizedInputValue.X,NormalizedInputValue.Y = System.Processes:Normalize(DifferenceX,0,WidgetObject:GetAbsoluteSize().X),System.Processes:Normalize(DifferenceY,0,WidgetTop:GetAbsoluteSize().Y);
		self.Dragging = true;
		MoveConnection = game:GetService("RunService").RenderStepped:Connect(Position);
		MoveUISConnection = UIS.InputEnded:Connect(function(InputType)
			if(InputType.UserInputType == Enum.UserInputType.MouseButton1)then
				MoveUISConnection:Disconnect();
				MoveUISConnection = nil;
				if(MoveConnection)then
					MoveConnection:Disconnect();
					MoveConnection = nil;
					self.Dragging = false;
				end
			end;
		end)
	end)
	WidgetObject.Position = UDim2.fromOffset( (Cam.ViewportSize.X/2-WidgetObject:GetAbsoluteSize().X/2) , (Cam.ViewportSize.Y/2-WidgetObject:GetAbsoluteSize().Y/2));
	return {
		["WidgetIcon"] = function(Value)
			WidgetTop_Header.Icon = Value;
		end,["*Name"] = function(Value)
			WidgetTop_Header.Text = Value;
		end,["Roundness"] = function(Value)
			WidgetObject.Roundness = Value
		end,["WidgetColor"] = function(Value)
			WidgetTop.BackgroundColor3 = Value;
			WidgetBottom_ScaleableBtn.BackgroundColor3 = Value;
			WidgetObject.StrokeColor3 = Value;
		end,["MinimumSize"] = function(Value)
			if(WidgetObject:GetAbsoluteSize().X < Value.X)then
				WidgetObject.Size = UDim2.fromOffset(Value.X,WidgetObject:GetAbsoluteSize().Y)
			end;
			if(WidgetObject:GetAbsoluteSize().Y < Value.Y)then
				WidgetObject.Size = UDim2.fromOffset(WidgetObject:GetAbsoluteSize().X,Value.Y);
			end;
		end,
		["Enabled"] = function(Value)
			if(Value)then 
				self:Show()
			else
				self:Hide();
			end
		end,
		["Static"] = function(Value)
			WidgetBottom_ScaleableBtn.Visible = not Value;
		end,["FullScreen"] = function(Value)
			if(Value)then
				WidgetObject.Size = UDim2.fromScale(1,1);
				WidgetObject.Position = UDim2.new(0);
			else
				WidgetObject.Size = UDim2.fromOffset(self.MinimumSize.X,self.MinimumSize.Y);
			end;
		end,
		_Components = {
			Portal = Portal;
			ActivityFrame = ActivityFrame;
			WidgetContent = WidgetContent;	
			FatherComponent = WidgetContent:GetGUIRef();
			ActionButtons = WidgetTop_ActionButtons;
			WidgetObject = WidgetObject;
			WidgetTop = WidgetTop;
		};
		_Mapping = {
			[WidgetObject] = {
				"BackgroundColor3","BackgroundTransparency";
			}
		};
	};
end;

return Widget;
