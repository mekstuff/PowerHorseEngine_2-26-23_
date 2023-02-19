local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local TweenService = game:GetService("TweenService");

local ProgressRadial = {
	Name = "ProgressRadial";
	ClassName = "ProgressRadial";
	Value = 0;
	BackgroundTransparency=1;
	Size = UDim2.new(0,30,0,30);
	Color = Theme.getCurrentTheme().Text;
	Yielding = false;
};
ProgressRadial.__inherits = {"GUI","BaseGui"}

local TweenService = game:GetService("TweenService");

--//
--function ProgressRadial:Destroy()
--	self:SetYielding(false);
--	self:GetRef():Destroy();
--end

--//
function ProgressRadial:SetYielding(Yield:boolean)
	local Component = self:GET("Radial");
	local G1Image = self:GET("G1Image");
	if(Yield == true)then
		
		local Gradient2 = self:GET("Gradient2");
		Gradient2.Rotation = 90;
		G1Image.Visible = false;
		
		if(self._dev.___yielding)then return end;
		self._dev.___yielding=true;
		
		local Thread = coroutine.create(function()
			while self._dev and self._dev.___yielding do
				Component.Rotation = 0;
				local t = TweenService:Create(Component, TweenInfo.new(self._Speed,Enum.EasingStyle.Linear),{Rotation = 360})
				t:Play();
				t.Completed:Wait();
				game:GetService("RunService").RenderStepped:Wait();
			
				--Component.Rotation = (Component.Rotation+1)%360;
				--print(Component.Rotation)
				--game:GetService("RunService").RenderStepped:Wait();
			end;
		end);coroutine.resume(Thread);
	else
		G1Image.Visible = true;
		Component.Rotation = 0;
		self._dev.___yielding=false;
		--self:Render();
		self:FillValue();
	end
end;

--//
function ProgressRadial:FillValue(Value:number?,Speed:number?)
	if(not self._dev.___yielding)then
		if(not Value)then
			Value = self.Value;
		else
			self.Value = Value;
		end
		local Component = self:GET("Radial");
		Speed = Speed or .1;
		local v = self.Value;
		--local value = self.Value;
		if(self.Value > 1)then
			v = self.Value/100;
		end;
		local angle = math.clamp(v * 360, 0, 360);
		TweenService:Create(Component.G1Frame.image.gradient, TweenInfo.new(Speed), {Rotation =  math.clamp(angle, 180, 361) }):Play();
		TweenService:Create(Component.G2Frame.image.gradient, TweenInfo.new(Speed), {Rotation =  math.clamp(angle, 0, 180) }):Play();		
	end;
end;

--//
local function createGradient(p,l)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromScale(0.5, 1)
	frame.Position = UDim2.fromScale(l and 0 or 0.5, 0)
	frame.BackgroundTransparency = 1
	frame.ClipsDescendants = true
	frame.Parent = p

	local image = Instance.new("ImageLabel")
	image.BackgroundTransparency = 1
	image.Size = l and UDim2.new(2, 1, 1, 0) or UDim2.fromScale(2, 1)
	image.Position = UDim2.fromScale(l and 0 or -1, 0)
	image.Image = "rbxasset://textures/ui/Controls/RadialFill.png"
	image.Parent = frame
	image.Name = "image";

	local gradient = Instance.new("UIGradient")
	gradient.Transparency = NumberSequence.new {
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(.4999, 0),
		NumberSequenceKeypoint.new(.5, 1),
		NumberSequenceKeypoint.new(1, 1)
	};
	gradient.Rotation = l and 180 or 0
	gradient.Parent = image
	gradient.Name = "gradient";

	return gradient, frame, image
end;

function createRadial()
	local bar = Instance.new("Frame")
	bar.Name = "Bar"
	bar.Size = UDim2.fromOffset(58, 58)
	bar.AnchorPoint = Vector2.new(0.5, 0.5)
	bar.Position = UDim2.fromScale(0.5, 0.5)
	bar.BackgroundTransparency = 1

	local gradient1, g1frame, g1image = createGradient(bar, true)
	local gradient2, g2frame, g2image = createGradient(bar, false);

	g1frame.Name = "G1Frame"; g2frame.Name = "G2Frame";
	g1frame.Parent = bar; g2frame.Parent = bar;
	return bar,g1image,g2image,gradient1,gradient2;
end


function ProgressRadial:_Render(App)
	self._Speed = 1;
	local Radial,g1image,g2image,gradient1,gradient2 = createRadial();
	Radial.Parent = self:GetRef();
	return {
		["Value"] = function(Value)
			self:FillValue();
		end,
		["Yielding"] = function(Value)
			self:SetYielding(Value)
		end,
		["Color"] = function(Value)
			--Radial.
			g1image.ImageColor3 = Value;
			g2image.ImageColor3 = Value;
		end,
		["Size"] = function(Value)
			Radial.Size = Value;
			--local Combined = 
			--local tSize = Value.X.Offset+Value.Y.Offset;
			--print(tSize);
		end,

		_Mapping = {
			[Radial] = {
				"Position","AnchorPoint","Visible";
			};
		};
		_Components = {
			Radial = Radial;
			Gradient1 = gradient1;
			Gradient2 = gradient2;
			G1Image = g1image;
			G2Image = g2image;
			FatherComponent = Radial;
		};
		--_Mapping = {};
	};
end;


return ProgressRadial
