local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local Vanilla_Core = require(script.Parent.Parent.Parent.Vanilla);
local Mouse = Vanilla_Core.Mouse;

local Mod_Padding = 10;

--[=[
	@class ToolTip
]=]

local ToolTip = {
	Name = "ToolTip";
	ClassName = "ToolTip";
	ContentPadding = Vector2.new(5,5);
	Offset = Vector2.new(10,10);
	RevealOnMouseEnter = true;
	IdleTimeRequired = 1;
	PositionBehaviour = Enumeration.PositionBehaviour.FollowMouse;
	BackgroundColor3 = Theme.getCurrentTheme().Disabled;
	StaticXAdjustment = Enumeration.Adjustment.Center;
	StaticYAdjustment = Enumeration.Adjustment.Bottom;
	RespectViewport = false;
	Showing = false;
	Adornee = "**any";
	-- Adornee = "**any";
};
ToolTip.__inherits = {"GUI","BaseGui"}
--//
local function StopTrack(self)
	if(self._dev.__prevAdorneeConnectionC)then
		self._dev.__prevAdorneeConnectionC:Disconnect();
		self._dev.__prevAdorneeConnectionC = nil;
	end
end;
--//
local function DisconnectPrevAdorneeConnection(self)
	if(self._dev.__prevAdorneeConnectionA)then
		self._dev.__prevAdorneeConnectionA:Disconnect();
		self._dev.__prevAdorneeConnectionA = nil;
	end;if(self._dev.__prevAdorneeConnectionB)then
		self._dev.__prevAdorneeConnectionB:Disconnect();
		self._dev.__prevAdorneeConnectionB = nil;
	end;
	StopTrack(self);
end;
--//
local function Listen(self)
	local AdorneeObject = self.Adornee;
	--local AdorneeObject = Core.getElementObject(self.Adornee);
	DisconnectPrevAdorneeConnection(self);
	

	self._dev.__prevAdorneeConnectionA = AdorneeObject.MouseEnter:Connect(function()
		if(self.RevealOnMouseEnter)then
			self:_Show();
		end;
	end);
	self._dev.__prevAdorneeConnectionB = AdorneeObject.MouseLeave:Connect(function()
		if(self.RevealOnMouseEnter)then
			-- self:_Hide();
		end;
	end);
end;
--[=[]=]
function ToolTip:Hide(...:any)
	return self:_Hide(...);
end;
--[=[]=]
function ToolTip:Show(...:any)
	return self:_Show(...);
end;
--[=[]=]
function ToolTip:_Track()
	--local ViewportRespectiveFrame = self:GetComponent();
	local App = self:_GetAppModule();
	local Ref = self:GET("Frame");
	Ref.Position = UDim2.fromScale(.5,.5);
	Ref.AnchorPoint = Vector2.new(.5,.5);
	local PluginService = App:GetService("PluginService");
	local CoreProviderService = App:GetService("CoreProviderService");


	local function update(pos,obj)
		
		local targetPos;
		if(self.RespectViewport)then
			targetPos = Core.CalculateRespectiveRelativeViewportPosition(obj or self.Adornee, Ref, self.StaticXAdjustment,self.StaticYAdjustment,self.RespectViewport);		
		else
			targetPos = UDim2.fromOffset(pos.X+self.Offset.X,pos.Y+self.Offset.Y);	
		end;
		Ref.Position = targetPos;
	end;
	

	if(not self._dev.__prevAdorneeConnectionC)then
		if(PluginService:IsPluginMode())then
			local PluginUI = self.Parent and (self.Parent:IsA("PluginGui") and self.Parent or self.Parent:FindFirstAncestorWhichIsA("PluginGui"));
			if(PluginUI)then
				self._dev.__prevAdorneeConnectionC = game:GetService("RunService").RenderStepped:Connect(function()
					update(PluginUI:GetRelativeMousePosition())
				end)
			end
			return;
		end
		self._dev.__prevAdorneeConnectionC = game:GetService("UserInputService").InputChanged:Connect(function(input, gameProcessedEvent)
			if(input.UserInputType == Enum.UserInputType.MouseMovement)then
				update(input.Position);
			end
		end)
	end;
end;

--[=[]=]
function ToolTip:_Track_Relative(Adornee:Instance)
	if(not Adornee)then Adornee = self.Adornee;end;

	--> We use Parent if no adornee is set, so parent will be used as adornee
	Adornee = Adornee or self.Parent;

	local FrameRBX = self:GET("Frame");
	
	if(self.Adornee ~= Mouse)then
		if(not self._dev.__prevAdorneeConnectionC)then
			self._dev.__prevAdorneeConnectionC = game:GetService("RunService").RenderStepped:Connect(function()
				local BestPosition = Core.CalculateRespectiveRelativeViewportPosition(Adornee, FrameRBX, self.StaticXAdjustment,self.StaticYAdjustment,self.RespectViewport);		
				FrameRBX.Position = BestPosition;		
			end);
		end;
	else
		local BestPosition = Core.CalculateRespectiveRelativeViewportPosition(Adornee, FrameRBX, self.StaticXAdjustment,self.StaticYAdjustment,self.RespectViewport)
		FrameRBX.Position = BestPosition;
	end
end;

--[=[]=]
function ToolTip:_Show()
	local FrameRBX = self:GET("Frame");
	self._dev.__timestore___ = os.time();
	self._dev.Hovering=true;
	self.Showing = true;
	delay(self.IdleTimeRequired,function()
		if(self._dev.Hovering)then
			if ((os.time() - self._dev.__timestore___) >= self.IdleTimeRequired)then
				if(self.PositionBehaviour == Enumeration.PositionBehaviour.FollowMouse)then	
					self:_Track();
				elseif( self.PositionBehaviour == Enumeration.PositionBehaviour.Static )then
					self:_Track_Relative();
					--FrameRBX.Position = BestPosition;	
				end;
				FrameRBX.Visible = true;
			end
		end;
	end);
end;
--//
function ToolTip:_Hide()
	local FrameRBX = self:GET("Frame");
	FrameRBX.Visible = false;
	self._dev.Hovering = false;
	self.Showing = false;
	StopTrack(self);
end;

--//
function ToolTip:_UpdateAdornee()
	local FrameRBX = self:GET("Frame");
	--local Hovering=false;

	FrameRBX.Visible = false;
	if(self.Adornee and self.RevealOnMouseEnter)then
		Listen(self);	
	end;
end;

function ToolTip:_Render(App)

	local IsPluginMode = App:GetService("PluginService"):IsPluginMode();

	local Portal;
	-- if(not IsPluginMode)then
		-- print("Not plugin mode"); 
		Portal = App.new("Portal", self:GetRef());
		Portal.IgnoreGuiInset = false;	
		Portal.ResetOnSpawn = false;
		Portal.ZIndex = 10;
	-- end;


	local Frame = App.new("Frame");
	Frame.Size = UDim2.fromScale(0,0);	
	Frame.AutomaticSize = Enum.AutomaticSize.XY;
	Frame.StrokeTransparency = 1;
	Frame.Parent = Portal and Portal:GetGUIRef() or self:GetRef();
	


	local ContentsContainer = Instance.new("Frame", Frame:GetGUIRef());
	ContentsContainer.Name = "Contents Container";
	ContentsContainer.AutomaticSize = Enum.AutomaticSize.XY;
	ContentsContainer.BackgroundTransparency = 1;
	local UIPadding = Instance.new("UIPadding", ContentsContainer);
	
	return {
		["ContentPadding"] = function(Value)
			UIPadding.PaddingTop = UDim.new(0,Value.Y);
			UIPadding.PaddingBottom = UDim.new(0,Value.Y);
			UIPadding.PaddingLeft = UDim.new(0,Value.X);
			UIPadding.PaddingRight = UDim.new(0,Value.X);
		end;
		["Adornee"] = function()
			self:_UpdateAdornee();
		end,
	--[[
		["*Parent"] = function(Value)
			if(Value ~= self.Adornee)then
				self.Adornee = Value;
				self:_UpdateAdornee();
			end
		end,
		]]
		_Components = {
			Frame = Frame;
			FatherComponent = ContentsContainer;	
			-- FatherComponent = Frame;
			_Appender = ContentsContainer;
		};
		_Mapping = {
			[Frame] = {
				"BackgroundColor3","BackgroundTransparency","Roundness";
			}	
		};
	};
end;


return ToolTip
