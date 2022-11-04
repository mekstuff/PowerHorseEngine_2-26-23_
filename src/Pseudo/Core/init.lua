local TestService = game:GetService("TestService");
local Enumeration = require(script.Parent.Parent.Enumeration);
local ServiceProvider = require(script.Parent.Parent.Core.Providers.ServiceProvider);

local chars_string="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
local chars = {};
for chars_loop_index = 1,#chars_string do
	table.insert(chars, string.sub(chars_string,chars_loop_index,chars_loop_index)) ;
end;

local TextService = game:GetService("TextService");

local module = {
	App = "Vanilla";
	Version = 0.10;
	Holder = "Belly";
	PreHolder = "Belly";
};
module.ASCIICharsSupported = chars;

function module:fromStringToTable(s)
	local chars = {};
	for chars_loop_index = 1,#s do
		table.insert(chars, string.sub(s,chars_loop_index,chars_loop_index)) ;
	end;
	return chars;
end


local ErrorService = ServiceProvider:LoadServiceAsync("ErrorService");
module.tossError = ErrorService.tossError;
module.tossWarn = ErrorService.tossWarn;
module.tossMessage = ErrorService.tossMessage;
--function module.tossError(errorshort, ...)
--	error(getErrorFromDataAndTranslate(errorshort, ...));
--end;

--function module.tossWarn(errorshort, ...)
--	warn(getErrorFromDataAndTranslate(errorshort, ...));
--end

--function module.tossMessage(errorshort, ...)
--	TestService:Message(getErrorFromDataAndTranslate(errorshort,  ...));
--end

--//
local function fix_useTextService(t)
	local i = TextService:GetTextSize(t.Text, t.TextSize, t.Font, Vector2.new(math.huge,math.huge));
	return i.X,i.Y
end;

--//
function module.InverseTable(table)
	for i = 1, math.floor(#table/2) do
		local j = #table - i + 1
		table[i], table[j] = table[j], table[i]
	end
end

--//
function module.getBoundings(...)
	local Components = {...};
	local Size = UDim2.new(0,0,0,0);

	local function AddToOffsetX(xBound)
		Size = UDim2.new(Size.X.Scale, Size.X.Offset+xBound, Size.Y.Scale, Size.Y.Offset);
	end;
	local function AddToOffsetY(yBound)
		if(Size.Y.Offset < yBound)then
			Size = UDim2.new(Size.X.Scale, Size.X.Offset, Size.Y.Scale, yBound);
		end
	end;

	for _,x in pairs(Components)do
		if(x:IsA("TextLabel"))then
			--local xBound, yBound = x.TextBounds.X, x.TextBounds.Y;
			local xBound,yBound = fix_useTextService(x);
			AddToOffsetX(xBound);
			AddToOffsetY(yBound);
		else
			local ComponentXOffset = x.AbsoluteSize.X;
			AddToOffsetX(ComponentXOffset)
		end
	end;

	return Size;
end;

function module.generateRanCod(length)
	local str="";if not length then length=15;end;
	for x = 1,length do
		local rad = chars[math.random(1,#chars)];
		str = str..rad;
	end;
	return str;
end;

--//
function module.getElementObject(obj)
	if(not obj)then return end;
	--if(not obj)then print("No Object"); return end;
	local x = typeof(obj) == "table" and obj:_GetCompRef() or obj;

	if(typeof(x) == "table" or not x)then

		--module.tossMessage("Using Appender or First Available RBX Object Because No Father Component Exists");
		local Appender = obj._Components["Appender"];
		if(not Appender)then
			Appender = obj:GetGUIRef();
		--[[
			for _,v in pairs(obj.__dev.Components["RBX"]) do
				if(typeof(v) ~= "table")then
					Appender = v;break;
				end
			end
	]]
		end;
		x = Appender;
	end
	return x;
end;

--//
function module.getAbsolutePositionFromUDim(VectorAnchorPoint,AbsoluteSize,Viewport)
	Viewport = Viewport or workspace.CurrentCamera.ViewportSize;
	VectorAnchorPoint = VectorAnchorPoint or Vector2.new(0,0);
	return Vector2.new(Viewport.X*VectorAnchorPoint.X-AbsoluteSize.X/2,Viewport.Y*VectorAnchorPoint.Y-AbsoluteSize.Y/2);
end

--//
function module.getRelativePositionInViewport(targetAbsPos, targetAbsSize, viewportSize)
	if(not viewportSize)then viewportSize = workspace.CurrentCamera.ViewportSize;end;
	local x = Enumeration.Adjustment.Left;
	local y = Enumeration.Adjustment.Bottom;
	local centerViewport = viewportSize/2

	if( (viewportSize.X - (targetAbsPos.X+targetAbsSize.X/2) ) < centerViewport.X)then
		x = Enumeration.Adjustment.Right;
	end;

	if( (viewportSize.Y - (targetAbsPos.Y+targetAbsSize.Y/2) ) > centerViewport.Y)then
		y = Enumeration.Adjustment.Bottom;
	end;

	return x,y
end;

--//
function module.CalculateComponentBoundings(Boundings, Pos, Size)
	Pos = Boundings and Boundings.AbsolutePosition or Pos;
	Size = Boundings and Boundings.AbsoluteSize or Size;

	local AnchorPointLeft = Pos.X;
	local AnchorPointRight = (Pos.X+Size.X) ;
	local AnchorPointTop = Pos.Y;
	local AnchorPointBottom = (Pos.Y+Size.Y);
	--local RelativeCenter_X = (Pos.X+(Size.X/2)) - Size.X/2;

	return {
		left = AnchorPointLeft;
		right = AnchorPointRight;
		top = AnchorPointTop;
		bottom = AnchorPointBottom;
	}
end;

--//
function module.CalculateRespectiveRelativeViewportPosition(AnchorPoint, Object, xAdjust, yAdjust, Override, IgnoreGuiInset)
	if(not xAdjust)then xAdjust = Enumeration.Adjustment.Center;end;
	if(not yAdjust)then yAdjust = Enumeration.Adjustment.Bottom;end;
	
	local x,y;
	
	AnchorPoint = module.getElementObject(AnchorPoint);Object = module.getElementObject(Object);

	local ran,reason = pcall(function() return AnchorPoint["AbsolutePosition"] end);

	local AnchorPointBounds;

	if(not ran)then
		if(string.find(reason, "PlayerMouse") or string.find(reason, "PluginMouse"))then
			AnchorPointBounds = module.CalculateComponentBoundings(nil, Vector2.new(AnchorPoint.X, AnchorPoint.Y), Vector2.new(5,5));
		end
	else
		AnchorPointBounds = module.CalculateComponentBoundings(AnchorPoint);
	end

	local AnchorPointLeft = AnchorPointBounds.left;
	local AnchorPointRight = AnchorPointBounds.right;
	local AnchorPointTop = AnchorPointBounds.top;
	local AnchorPointBottom = AnchorPointBounds.bottom;

	if(Override)then
		local ViewportSize = workspace.CurrentCamera.ViewportSize;
		if not(typeof(Override == "boolean"))then
			ViewportSize = Override;
		end;

		if(xAdjust == Enumeration.Adjustment.Right)then
			--print(AnchorPointRight+Object.AbsoluteSize.X, ViewportSize.X);
			if(AnchorPointRight+Object.AbsoluteSize.X > ViewportSize.X)then
				local _e = Enumeration.Adjustment.Left
				--module.tossMessage("xAdjustment Was Changed From ["..xAdjust.Name.."] To [".._e.Name.."] Because Of The Overwrite Argument");
				xAdjust = _e
			end
		elseif(xAdjust == Enumeration.Adjustment.Left)then
			--print(AnchorPointLeft-Object.AbsoluteSize.X)
			if(AnchorPointLeft-Object.AbsoluteSize.X < 0)then
				local _e = Enumeration.Adjustment.Right
				--module.tossMessage("xAdjustment Was Changed From ["..xAdjust.Name.."] To [".._e.Name.."] Because Of The Overwrite Argument");
				xAdjust = _e;
			end
		elseif(xAdjust == Enumeration.Adjustment.Flex)then
			--print(AnchorPointLeft-Object.AbsoluteSize.X)
			if(AnchorPointRight+Object.AbsoluteSize.X > ViewportSize.X)then
				local _e = Enumeration.Adjustment.Left
				--module.tossMessage("xAdjustment Was Changed From ["..xAdjust.Name.."] To [".._e.Name.."] Because Of The Overwrite Argument");
				xAdjust = _e;
			end
		end;



	--[[
		print(AnchorPointLeft)
		
		if(AnchorPointRight+Object.AbsoluteSize.X > ViewportSize.X)then
			local _e = Enumeration.Adjustment.Left
			--module.tossMessage("xAdjustment Was Changed From ["..xAdjust.."] To [".._e.."] Because Of The Overwrite Argument");
			xAdjust = _e
		elseif(AnchorPointLeft-Object.AbsoluteSize.X < 0)then
			local _e = Enumeration.Adjustment.Right
			--module.tossMessage("xAdjustment Was Changed From ["..xAdjust.."] To [".._e.."] Because Of The Overwrite Argument");
			xAdjust = _e;
		end
	]]
	--[[
		if(xAdjust == Enumeration.Adjustment.Right)then
			--print(AnchorPointRight+Object.AbsoluteSize.X > ViewportSize.X);
			if(AnchorPointRight+Object.AbsoluteSize.X > ViewportSize.X)then
				local _e = Enumeration.Adjustment.Left
				module.tossMessage("xAdjustment Was Changed From ["..xAdjust.."] To [".._e.."] Because Of The Overwrite Argument");
				xAdjust = _e
			end
		elseif(xAdjust == Enumeration.Adjustment.Left)then
			--print(AnchorPointLeft-Object.AbsoluteSize.X)
			if(AnchorPointLeft-Object.AbsoluteSize.X < 0)then
				local _e = Enumeration.Adjustment.Right
				module.tossMessage("xAdjustment Was Changed From ["..xAdjust.."] To [".._e.."] Because Of The Overwrite Argument");
				xAdjust = _e;
			end
		end;
	]]


		if(yAdjust == Enumeration.Adjustment.Top)then
			if(AnchorPointTop-Object.AbsoluteSize.Y < (IgnoreGuiInset and 0 or -36) )then
				local _e = Enumeration.Adjustment.Bottom
				--module.tossMessage("xAdjustment Was Changed From ["..yAdjust.."] To [".._e.."] Because Of The Overwrite Argument");
				yAdjust = _e;
			end
		elseif(yAdjust == Enumeration.Adjustment.Bottom)then

			--print(AnchorPointBottom+Object.AbsoluteSize.Y+5,ViewportSize.Y)
			if(AnchorPointBottom+Object.AbsoluteSize.Y+5 > ViewportSize.Y)then
				local _e = Enumeration.Adjustment.Top
				--module.tossMessage("xAdjustment Was Changed From ["..yAdjust.."] To [".._e.."] Because Of The Overwrite Argument");
				yAdjust = _e;
			end
		end;

	end



	if(xAdjust == Enumeration.Adjustment.Center)then
		local RelativeCenter_X = (AnchorPointLeft+(AnchorPoint.AbsoluteSize.X/2)) - Object.AbsoluteSize.X/2;
		x = RelativeCenter_X;
	elseif ( xAdjust == Enumeration.Adjustment.Left )then
		x = AnchorPointLeft-Object.AbsoluteSize.X;
	elseif ( xAdjust == Enumeration.Adjustment.Right )then
		x = AnchorPointRight;
	elseif ( xAdjust == Enumeration.Adjustment.Flex)then
		x = AnchorPointLeft;
	end;

	if(yAdjust == Enumeration.Adjustment.Top)then

		y = AnchorPointTop-Object.AbsoluteSize.Y;
	elseif(yAdjust == Enumeration.Adjustment.Center)then
		local RelativeCenter_Y = (AnchorPoint.AbsolutePosition.Y+(AnchorPoint.AbsoluteSize.Y/2)) - Object.AbsoluteSize.Y/2
		y = RelativeCenter_Y;
	elseif(yAdjust == Enumeration.Adjustment.Bottom)then
		y = AnchorPointBottom;
	elseif(yAdjust == Enumeration.Adjustment.Flex)then
		y = AnchorPointTop;
	end

	return UDim2.fromOffset(x,y);
end;

function module.getMagnitudeFromRootPart(magid, MagMax, MagMin, RootPart)
	if(not MagMin)then MagMin = 0;end;
	if(not RootPart)then
		local Player = game:GetService("Players").LocalPlayer;
		local Char = Player.Character or Player.CharacterAdded:Wait();
		RootPart = Char:WaitForChild("HumanoidRootPart");
	end
	local totalmag = (magid.Position - RootPart.Position).Magnitude;

	local Pos, InView = workspace.CurrentCamera:WorldToScreenPoint(magid.Position);
	return totalmag, (totalmag >= MagMin and totalmag <= MagMax) , InView, Pos;

end;

--//
function module.determineClientDevice()
	local UIS,GUIService = game:GetService("UserInputService"),game:GetService("GuiService");

	if(GUIService:IsTenFootInterface() and not UIS.KeyboardEnabled and UIS.KeyboardEnabled)then return Enumeration.Device.XBOX;end;

	if(UIS.KeyboardEnabled and not UIS.TouchEnabled and not UIS.GyroscopeEnabled)then return Enumeration.Device.PC;end;

	if(UIS.TouchEnabled and not UIS.GamepadEnabled and not UIS.KeyboardEnabled)then return Enumeration.Device.Mobile;end;

	return Enumeration.Device.PC;

end;
--//
function module.getScreenClampVectorForGuiComponent(GuiComponent, ScreenRelativity, WithinLineOfSight, Viewport)
	if(not Viewport)then Viewport = workspace.CurrentCamera.ViewportSize;end;

	local ComponentBounds = module.CalculateComponentBoundings(nil,ScreenRelativity,GuiComponent.AbsoluteSize);

	local function calcclip()
		--print(ComponentBounds.top > ComponentBounds.left);
	end	

--[[
	local x,y;
	
	--print(ComponentBounds.left, 0)
	local function calcclip()
		if(ComponentBounds.left < 0)then
			--x = GuiComponent.AbsoluteSize.X*GuiComponent.AnchorPoint.X;
			x = 0;
		elseif(ComponentBounds.right > Viewport.X)then
			--x = Viewport.X - GuiComponent.AbsoluteSize.X*GuiComponent.AnchorPoint.X;
			x = Viewport.X;
		else
			x = ScreenRelativity.X;
		end;
		
		if(ComponentBounds.bottom > Viewport.Y)then
			--print("Clipping bottom");
			--y = Viewport.Y-GuiComponent.AbsoluteSize.Y;
			y = Viewport.Y;
		elseif(ComponentBounds.top < 0)then
			--print("Clipping top");
			y = 0;
		else
			y = ScreenRelativity.Y;
		end
	return x,y
	end;
]]

	local x,y = calcclip()

	--print(x,y);

	--print(ComponentBounds.bottom )

--[[
	local x,y=0,0;

	if(ComponentBounds.left < ComponentBounds.top)then
		--print(Viewport.Y-Com)
		
		if(ComponentBounds.top < (Viewport.Y-ComponentBounds.top))then
			x = (math.clamp(ComponentBounds.left,0,Viewport.X-ComponentBounds.left));
		else
			x =(math.clamp(ComponentBounds.left,0,Viewport.X-ComponentBounds.left));
			y = (Viewport.Y - ComponentBounds.left)
		end
	else
		if ComponentBounds.left < (Viewport.X - ComponentBounds.left) then
			 x = 0;
			 y = math.clamp(ComponentBounds.top,0,Viewport.Y-ComponentBounds.top);
	else
			x = Viewport.X - ComponentBounds.left;
			y =math.clamp(ComponentBounds.top,0,Viewport.Y-ComponentBounds.top);
			
		end
	end;
	
	return Vector2.new(x,y);
	]]

--[[
	local function findClosestBorderPoint(x,y,Absolute)
		x = Viewport.X - x
		y = Viewport.Y - y
		local distanceToYBorder = math.min(y,Viewport.Y-y)
		local distanceToXBorder = math.min(x,Viewport.X-x)
		if distanceToYBorder < distanceToXBorder then
			if y < (Viewport.Y - y) then
				return math.clamp(x,0,Viewport.X-Absolute.X),0
			else
				return math.clamp(x,0,Viewport.X-Absolute.X),Viewport.Y - Absolute.Y
			end
		else
			if x < (Viewport.X - x) then
				return 0,math.clamp(y,0,Viewport.Y-Absolute.Y)
			else
				return Viewport.X - Absolute.X,math.clamp(y,0,Viewport.Y-Absolute.Y)
			end
		end
	end;
	
	local MarkerPosition = ScreenRelativity

	local MarkerPositionX = MarkerPosition.X - MarkerAbsolute.X
	local MarkerPositionY = MarkerPosition.Y - MarkerAbsolute.Y
	
	--local MarkerPositionX = module.CalculateComponentBoundings()

	if MarkerPosition.Z < 0 then
		MarkerPositionX,MarkerPositionY = findClosestBorderPoint(MarkerPositionX,MarkerPositionY,MarkerAbsolute)
	else
		if MarkerPositionX < 0 then
			MarkerPositionX = 0
		elseif MarkerPositionX > (Viewport.X -MarkerAbsolute.X)  then
			MarkerPositionX = Viewport.X - MarkerAbsolute.X
		end
		if MarkerPositionY < 0 then
			MarkerPositionY = 0
		elseif MarkerPositionY > (Viewport.Y -MarkerAbsolute.Y)  then
			MarkerPositionY = Viewport.Y - MarkerAbsolute.Y
		end
	end
	
	return MarkerPositionX, MarkerPositionY
]]
end;

module.PortalZIndex = 300;

return module
