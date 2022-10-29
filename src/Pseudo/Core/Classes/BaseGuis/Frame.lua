local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);


local StrokeExpand = 7;
local StrokeExpandTweenTime = .2;

--[=[
@class Frame

Similar to the ROBLOX's Frame but with extended properties and functions.
]=]

local Frame = {
	
	Name = "Frame";
	ClassName = "Frame";
	Roundness = UDim.new(0,0);
	
	HoverEffect = Enumeration.HoverEffect.None;
	ActiveBehaviour = Enumeration.ActiveBehaviour.None;
	ActiveColor3 = Color3.fromRGB(255, 56, 59);
	Padding = UDim2.new(0);

	ToolTip = "";
};

local ActiveFrame;
--//
function Frame:SetFrameActive(set)
	--print(self);
end;


Frame.__inherits = {"GUI","BaseGui"}

local GlobalToolTip;
local CurrentActiveFrame;


function Frame:_Render(App)
	--local t = tick();
	
	local FrameObject = Instance.new("Frame", self:GetRef());
	FrameObject.Name = "$l_Frame";
	
	local Stroke = Instance.new("UIStroke", FrameObject);
	Stroke.Name = "$l_stroke";
	
	local Round = Instance.new("UICorner", FrameObject);
	Round.Name = "$l_round";
	

	--[=[
		@prop MouseEnter PHeSignal
		@within Frame
	]=]
	self:AddEventListener("MouseEnter",true,FrameObject.MouseEnter);
	--[=[
		@prop MouseLeave PHeSignal
		@within Frame
	]=]
	self:AddEventListener("MouseLeave",true,FrameObject.MouseLeave);
	--[=[
		@prop MouseMoved PHeSignal
		@within Frame
	]=]
	self:AddEventListener("MouseMoved",true,FrameObject.MouseMoved);
	--[=[
		@prop MouseWheelForward PHeSignal
		@within Frame
	]=]
	self:AddEventListener("MouseWheelForward",true,FrameObject.MouseWheelForward);
	--[=[
		@prop MouseWheelBackward PHeSignal
		@within Frame
	]=]
	self:AddEventListener("MouseWheelBackward",true,FrameObject.MouseWheelBackward);
	--[=[
		@prop InputBegan PHeSignal
		@within Frame
	]=]
	self:AddEventListener("InputBegan",true,FrameObject.InputBegan);
	--[=[
		@prop InputEnded PHeSignal
		@within Frame
	]=]
	self:AddEventListener("InputEnded",true,FrameObject.InputEnded);
	--[=[
		@prop InputChanged PHeSignal
		@within Frame
	]=]
	self:AddEventListener("InputChanged",true,FrameObject.InputChanged);

	

	local function getGlobalToolTip()
		if(GlobalToolTip)then return GlobalToolTip;end;
		local newTip = App.new("ToolTip");
		newTip.RevealOnMouseEnter = false;
		newTip.IdleTimeRequired=0;
		local Text = App.new("Text", newTip);
		Text.Size = UDim2.new(0);
		Text.Text = ""
		Text.AutomaticSize = Enum.AutomaticSize.XY;
		Text.BackgroundTransparency = 1;
		GlobalToolTip = {
			txt = Text;
			tip = newTip;
		};
		return GlobalToolTip;
	end
	
	FrameObject.MouseEnter:Connect(function()
		if(self.ToolTip == "")then return end;
		local ToolTip = getGlobalToolTip();
		local txt = ToolTip.txt;
		local tip = ToolTip.tip;
		txt.Text = self.ToolTip;
		tip.Parent = self;
		tip:_Show();
	end);
	FrameObject.MouseLeave:Connect(function()
		if(GlobalToolTip)then
			GlobalToolTip.tip:_Hide();
		end
	end);

	local Padding;
	
	return {
		["Padding"] = function(v)
			if(v == UDim2.new(0))then
				if(Padding)then
					Padding:Destroy();
				end
			else
				if(not Padding)then
					Padding = Instance.new("UIPadding");
					Padding.Parent = FrameObject;
				end;
				Padding.PaddingLeft = UDim.new(0,v.X.Scale);
				Padding.PaddingTop = UDim.new(0,v.X.Offset);
				Padding.PaddingRight = UDim.new(0,v.Y.Scale);
				Padding.PaddingBottom = UDim.new(0,v.Y.Offset);
			end
		end;
		["StrokeThickness"] = function(v)
			--print("Triggered");
			Stroke.Thickness = v;
		end,["StrokeColor3"] = function(v)
			Stroke.Color = v;
		end,["StrokeTransparency"] = function(v)
			Stroke.Transparency = v;
		end,["Roundness"] = function(v)
			Round.CornerRadius = v;
		end,["Active"] = function(v)
			--print("Triggered");	
		end,["Disabled"] = function(v)
			if(v)then
				FrameObject.BackgroundColor3 = Theme.getCurrentTheme().Disabled;
			else
				FrameObject.BackgroundColor3 = self.BackgroundColor3;
			end
		end,["BackgroundColor3"] = function(v)
			if(self.Disabled)then return end;
			FrameObject.BackgroundColor3 = v;
		end,
	
		
		_Mapping = {
			[FrameObject]={
				"Position","Size","Visible","BackgroundTransparency","ZIndex","AnchorPoint","AutomaticSize","BorderSizePixel",
				"ClipsDescendants","Rotation";
			}
		};
		_Components = {
			FatherComponent = FrameObject;
			-- _Appender = Frame:GET("Instance");
			Frame = FrameObject;
			Stroke = Stroke;
			Round = Round;
			--_Appender = Frame;
		}

	};
	
end;


return Frame
