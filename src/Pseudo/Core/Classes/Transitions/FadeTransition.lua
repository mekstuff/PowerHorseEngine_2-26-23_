local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local TweenService = game:GetService("TweenService");

local FadeTransition = {
	Name = "FadeTransition";
	ClassName = "FadeTransition";
	Color = Theme.getCurrentTheme().Foreground;
	TransitionSpeed = .15;
	TransitionEndSpeed = 1;
	ShowIndicator = false;
};
FadeTransition.__inherits = {"Transition","BaseGui"}

function FadeTransition:_TransitionIn()
	local App = self:_GetAppModule();
	local FrameRef = self:GET("Frame"):GetGUIRef();
	local t = TweenService:Create(FrameRef, TweenInfo.new(self.TransitionSpeed),{BackgroundTransparency=0});
	if(self.ShowIndicator)then
	
	end;
	t:Play();
end;

function FadeTransition:_TransitionOut(Destroy)
	local FrameRef = self:GET("Frame"):GetGUIRef();
	local TweenOut = TweenService:Create(FrameRef, TweenInfo.new(self.TransitionEndSpeed),{BackgroundTransparency=1});
	TweenOut:Play();
	if(Destroy)then
		if(self._dev._indicator)then self._dev._indicator:Destroy();end;
		self._dev.CompetedTransitionOut = TweenOut.Completed:Connect(function()
			self:GetRef():Destroy();
		end)
	end
end;

function FadeTransition:Destroy()
	self:_TransitionOut(true);
end


function FadeTransition:_Render(App)
	
	if(not IsClient)then return {};end;
	
	local Portal = self:CreateTransitionPortal(self:GetRef());
	
	local Frame = App.new("Frame");
	Frame.BackgroundTransparency = 1;
	Frame.Size = UDim2.new(1,0,1,36);
	Frame.Position = UDim2.fromOffset(0,-36);
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


return FadeTransition
