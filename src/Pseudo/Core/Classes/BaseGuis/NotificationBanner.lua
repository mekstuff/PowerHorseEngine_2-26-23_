local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");

local NotificationBanner = {
	Name = "NotificationBanner";
	ClassName = "NotificationBanner";
	Position = UDim2.new(0,0,0,5);
	OffPosition = UDim2.new(0,0,-1,0);
	AnchorPoint = Vector2.new(0);
	TextSize = 30;
	Size = UDim2.new(1,0,0,30);
	TextStrokeTransparency = .35;
	--Visible = false;
};

NotificationBanner.__inherits = {"BaseGui","Text"}
--//
function NotificationBanner:Show()
	local Text = self:GET("Text");
	local TextGui = Text:GetGUIRef();
	--Text.Position = UDim2.fromScale(.5,-1);
	Text.Visible = true;
	local t = TweenService:Create(TextGui, TweenInfo.new(self._Speed), {Position = self.Position});
	t:Play();
	self._Showing = true;
end;
--//
function NotificationBanner:_getOffPosition()
	--local Text = self:GET("Text");
	return self.OffPosition;
end
--//
function NotificationBanner:Hide(noAnim)
	local Text = self:GET("Text");
	local TextGui = Text:GetGUIRef();
	if(noAnim)then
		Text.Visible = false;
		Text.Position = UDim2.new(.5,0,-1);
		return;
	end
	local t = TweenService:Create(TextGui, TweenInfo.new(self._Speed), {Position = self:_getOffPosition()});
	t:Play();
	t.Completed:Connect(function(State)
		if(State == Enum.PlaybackState.Completed)then
			Text.Visible = false;
			self._Showing = false;
		end
	end)
end
--//

function NotificationBanner:_Render(App)
	
	self._Speed = .4;
	
	local Text = App.new("Text",self:GetRef());
	Text.Visible = false;
	Text.BackgroundTransparency = 1;
	--self._Components["Text"]=Text;
	Text.Position = self.OffPosition;
	local TextGui = Text:GetGUIRef();
	local _x = true;
	
	return {
		["Position"] = function(Value)
			if(self._Showing)then
				Text.Position = Value;
			end
		end,
		["OffPosition"] = function(Value)
			if not(self._Showing)then
				Text.Position = Value;
			end
		end,
		["Visible"] = function(Value)
			if(Value)then
				self:Show();
				--Text:TweenPosition(UDim2.n)
			else
				self:Hide();
				
			end
		end,
		_Components = {
			Text = Text;	
			FatherComponent = Text;
		};
		_Mapping = {
			[Text] = {
				"Text","TextColor3","TextTransparency","SmartText",
				"TextStrokeColor3","TextStrokeTransparency","TextStrokeThickness",
				"AnchorPoint","Font","TextSize","TextScaled","Size"
			}	
		};
	};
end;


return NotificationBanner
