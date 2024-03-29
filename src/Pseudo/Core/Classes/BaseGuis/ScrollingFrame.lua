local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");
local ResponsiveScrollerTInfo = TweenInfo.new(.1)


local ScrollingFrame = {
	Name = "ScrollingFrame";
	ClassName = "ScrollingFrame";
	
	ResponsiveScroller = false;
	ResponsiveScrollerBreakPoint = 20;
	ResponsiveScrollerCollapseThickness = 3;
	AutomaticCanvasSize = Enum.AutomaticSize.XY;
	BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png";
	CanvasPosition = Vector2.new(0,0);
	CanvasSize = UDim2.new(0);
	--ElasticBehaviour = Enum.ElasticBehavior.WhenScrollable;
	HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
	MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png";
	ScrollBarImageColor3 = Theme.getCurrentTheme().Secondary;
	ScrollBarImageTransparency = 0;
	ScrollBarThickness = 6;
	ScrollingDirection = Enum.ScrollingDirection.Y;
	ScrollingEnabled = true;
	TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png";
	VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
	VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right;
	BackgroundColor3 = Theme.getCurrentTheme().Primary;
	--BackgroundColor3 = Theme.getCurrentTheme().Background;
	ClipsDescendants = true;
};
ScrollingFrame.__inherits = {"BaseGui","GUI"}


function ScrollingFrame:_Render(App)
	
	local Scroller = Instance.new("ScrollingFrame",self:GetRef());
	Scroller.BorderSizePixel = 0;
	
	local PSEUDOCLASSES = App:GetService("_PSEUDOCLASSES");
	local GUIProps = PSEUDOCLASSES:GETCLASSPROPS("GUI","BaseGui");
	GUIProps["StrokeThickness"]=nil;GUIProps["StrokeTransparency"]=nil;GUIProps["StrokeColor3"]=nil;
	GUIProps["ClassName"]=nil;GUIProps["css"]=nil;GUIProps["Disabled"]=nil;GUIProps["SupportsRBXUIBase"]=nil;
	GUIProps = PSEUDOCLASSES:GETPROPSAS_STRING(GUIProps);
	
	local MouseButton1DownEvent = self:AddEventListener("MouseButton1Down",true);
	local MouseButton1UpEvent = self:AddEventListener("MouseButton1Up",true);
	local MouseButton2DownEvent = self:AddEventListener("MouseButton2Down",true);
	local MouseButton2UpEvent = self:AddEventListener("MouseButton2Up",true);

	local MouseEnterEvent = self:AddEventListener("MouseEnter",true,Scroller.MouseEnter);
	self:AddEventListener("MouseLeave",true,Scroller.MouseLeave);
	self:AddEventListener("MouseMoved",true,Scroller.MouseMoved);
	self:AddEventListener("MouseWheelForward",true,Scroller.MouseWheelForward);
	self:AddEventListener("MouseWheelBackward",true,Scroller.MouseWheelBackward);
	
	Scroller.InputBegan:Connect(function(InputObject)
		if(self.Disabled)then return end;
		if(InputObject.UserInputType == Enum.UserInputType.MouseButton1)then
			MouseButton1DownEvent:Fire();
		elseif(InputObject.UserInputType == Enum.UserInputType.MouseButton2)then
			MouseButton2DownEvent:Fire();
		end
	end);Scroller.InputEnded:Connect(function(InputObject)
		if(InputObject.UserInputType == Enum.UserInputType.MouseButton1)then
			MouseButton1UpEvent:Fire();
		elseif(InputObject.UserInputType == Enum.UserInputType.MouseButton2)then
			MouseButton2UpEvent:Fire();
		end
	end)

	local ResponsiveScrollerConnection;
	local ExpandedResponsiveScrollBar = false;
	
	local function ConnectResponsiveScroller()
		Scroller.ScrollBarThickness = self.ResponsiveScrollerCollapseThickness;
		ResponsiveScrollerConnection = Scroller.InputChanged:Connect(function(input)
			if(input.UserInputType == Enum.UserInputType.MouseMovement)then
				local xv = (Scroller.AbsoluteSize.X - input.Position.X) - self.ScrollBarThickness;
				if(xv >= self.ResponsiveScrollerBreakPoint)then
					if(ExpandedResponsiveScrollBar)then
						TweenService:Create(Scroller, ResponsiveScrollerTInfo, {
							ScrollBarThickness = self.ResponsiveScrollerCollapseThickness;
						}):Play();
						ExpandedResponsiveScrollBar = false;
					end
				else
					if(not ExpandedResponsiveScrollBar)then
						TweenService:Create(Scroller, ResponsiveScrollerTInfo, {
							ScrollBarThickness = self.ScrollBarThickness;
						}):Play();
						ExpandedResponsiveScrollBar = true;
					end
				end
			end
		end);
	end;

	local function DisconnectResponsiveScroller()
		if(ResponsiveScrollerConnection)then
			ResponsiveScrollerConnection:Disconnect();
			ResponsiveScrollerConnection = nil;
		end
	end;
	
	return {
		["ScrollBarThickness"] = function(v)
			if(self.ResponsiveScroller)then
				if(ExpandedResponsiveScrollBar)then Scroller.ScrollBarThickness = v;end;
			else
				Scroller.ScrollBarThickness = v;
			end;
		end;
		["ResponsiveScroller"] = function(Value)
			if(Value)then
				ConnectResponsiveScroller();
			else
				DisconnectResponsiveScroller();
			end
		end,
		_Components = {
			FatherComponent = Scroller;	
		};
		_Mapping = {
			[Scroller] = {
			
				--"AnchorPoint","AutomaticSize","BackgroundColor3",
				--"BackgroundTransparency","LayoutOrder","Position","Rotation",
				--"Selectable","Size","SizeConstraint","Visible","ZIndex",
				"AutomaticCanvasSize","BottomImage","CanvasPosition",
				"CanvasSize","HorizontalScrollbarInset","MidImage",
				"ScrollBarImageColor3","ScrollBarImageTransparency",
				"ScrollingDirection","ScrollingEnabled",
				"TopImage","VerticalScrollBarInset","VerticalScrollBarPosition",
				unpack(GUIProps),
				
			};	
		};
	};
end;


return ScrollingFrame
