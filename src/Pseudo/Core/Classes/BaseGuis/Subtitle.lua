local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");

local Subtitle = {
	Name = "Subtitle";
	ClassName = "Subtitle";
	MaxSubtitles = 10;
};
Subtitle.__inherits = {"BaseGui"}

function Subtitle:New(...)
	return self:new(...);
end

function Subtitle:new(Subtitle,Props,Lifetime,Priority,Header)
	local NotificationGroup = self:GET("NotificationGroup");
	local _Appender = self:GET("_Appender");
	
	local subtitleObject = self:_GetAppModule().new("SubtitleText");
	subtitleObject.Text = Subtitle or "";
	if(Props)then
		local ig = false;
		if(typeof(Props) == "number")then
			Priority = Lifetime;
			Lifetime = Props;
			ig=true;
		end
		if(typeof(Props) == "Color3")then
			Props = {
				TextColor3 = Props;
			};
		end;
		if(not ig)then
			for a,b in pairs(Props)do
				subtitleObject[a]=b;
			end
		end;
		ig=nil;
	end;
	
	if(Header and Header ~= "")then
		subtitleObject.Text = Header.."\n"..subtitleObject.Text;
	end;

	local n = NotificationGroup:SendNotification(subtitleObject,Priority,nil,Lifetime);
	subtitleObject._n=n;
	
	self._dev.__totaln+=1;
	if(self._dev.__totaln == 1)then
		TweenService:Create(_Appender, TweenInfo.new(.5), {BackgroundTransparency = 0}):Play();
	end;
	if(Lifetime)then
		delay(Lifetime,function()
			subtitleObject:Destroy();
		end);
	end
	subtitleObject:GetPropertyChangedSignal("Destroying"):Connect(function()
		self._dev.__totaln-=1;
		if(self._dev.__totaln <= 0)then
			TweenService:Create(_Appender, TweenInfo.new(.5), {BackgroundTransparency = 1}):Play();
		end
	end)
--[[
	n.Dismissed:Connect(function()
		self._dev.__totaln -=1;
		if(self._dev.__totaln <= 0)then
			--Gradient.Enabled=false;
			TweenService:Create(_Appender, TweenInfo.new(.5), {BackgroundTransparency = 1}):Play();
			
		end
	end)
]]
	--if not(self._dev._subtitles)then self._dev._subtitles = {};end;
	
	--table.insert(self._dev._subtitles,subtitleObject);
	

	
	return subtitleObject;
end


function Subtitle:_Render(App)
	self._dev.__totaln=0;
	local SubtitleBackground = Instance.new("Frame",self:GetRef());
	SubtitleBackground.BorderSizePixel = 0;
	SubtitleBackground.Size = UDim2.fromScale(1,.5);
	SubtitleBackground.Position = UDim2.fromScale(0,1);
	SubtitleBackground.AnchorPoint = Vector2.new(0,1);
	SubtitleBackground.BackgroundColor3 = Color3.fromRGB(0);
	SubtitleBackground.BackgroundTransparency = 1;
	
	local SubtitleBackground_Gradient = Instance.new("UIGradient",SubtitleBackground);
	SubtitleBackground_Gradient.Rotation = -90;
	SubtitleBackground_Gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0));
		ColorSequenceKeypoint.new(1, Color3.fromRGB(79,79,79));
	});
	SubtitleBackground_Gradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0,0);
		NumberSequenceKeypoint.new(1,1);
	});

	
	local SubtitleNotificationGroup = App.new("NotificationGroup",SubtitleBackground);
	-- SubtitleNotificationGroup:RenderOutsidePortal();
	SubtitleNotificationGroup.ContentAdjustment = Enumeration.Adjustment.Center
	SubtitleNotificationGroup.AnchorPoint = Vector2.new(0);
	SubtitleNotificationGroup.Position = UDim2.new(0);
	SubtitleNotificationGroup.Size = UDim2.new(1,0,1,-10);
	SubtitleNotificationGroup.NotificationAnimationStyle = Enumeration.NotificationAnimationStyle.Popup;

	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {
			_Appender = SubtitleBackground;
			NotificationGroup = SubtitleNotificationGroup;
			Gradient = SubtitleBackground_Gradient;
			
		};
		_Mapping = {};
	};
end;


return Subtitle
