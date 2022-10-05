local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local TweenService = game:GetService("TweenService");

local WipeTransition = {
	Name = "WipeTransition";
	ClassName = "WipeTransition";
	Color = Theme.getCurrentTheme().Foreground;
	TransitionSpeed = .15;
	TransitionEndSpeed = 1;
	ShowIndicator = false;
	TransitionDirection = Enumeration.TransitionDirection.TopBottom;
};
WipeTransition.__inherits = {"Transition","BaseGui"}

function WipeTransition:_TransitionIn()
	local App = self:_GetAppModule();
	local FrameRef = self:GET("Frame"):GetGUIRef();
	--local t = self.TransitionDirection.f(FrameRef,"in", TweenInfo.new(self.TransitionSpeed),UDim2.fromOffset(0,-36))
	--local t = TweenService:Create(FrameRef, TweenInfo.new(self.TransitionSpeed),{BackgroundTransparency=0});
	if(self.ShowIndicator)then
	
	end;
	--t:Play();
end;

function WipeTransition:_TransitionOut(Destroy)
	local FrameRef = self:GET("Frame"):GetGUIRef();
	--local TweenOut = TweenService:Create(FrameRef, TweenInfo.new(self.TransitionEndSpeed),{BackgroundTransparency=1});
	--TweenOut:Play();
	local TweenOut = self.TransitionDirection.f(FrameRef,"out");
	if(Destroy)then
		if(self._dev._indicator)then self._dev._indicator:Destroy();end;
		self._dev.CompetedTransitionOut = TweenOut.Completed:Connect(function()
			self:GetRef():Destroy();
		end)
	end
end;

function WipeTransition:Destroy()
	self:_TransitionOut(true);
end


function WipeTransition:_Render(App)
	
	if(not IsClient)then return {};end;
	
	local Portal = self:CreateTransitionPortal(self:GetRef());
	
	local Frame = App.new("Frame");
	Frame.BackgroundTransparency = 0;
	Frame.Size = UDim2.new(2,0,2,0);
	Frame.Position = UDim2.new(0,0,-2);
	Frame.Parent = Portal
	
	return {
		["ShowIndicator"] = function(value)
			if(value)then
				if(not self._dev._indicator)then
					local indicator = App.new("ProgressIndicator");
					indicator.Color = Theme.getCurrentTheme().ForegroundText;
					indicator.CycleSpeed = .5;
					indicator.Parent = Frame;
					self._dev._indicator = indicator;
				end;
			end;
			if(self._dev._indicator)then
				self._dev._indicator.Enabled=value;
			end
		end,
		["*Parent"] = function(Value)
			if(Value)then
				self:_TransitionIn();
			end;
		end,
		["Color"] = function(v)
			Frame.BackgroundColor3 = v;
		end,
		_Components = {
			Frame = Frame;	
			_Appender = Frame;
		};
		_Mapping = {};
	};
end;


return WipeTransition
