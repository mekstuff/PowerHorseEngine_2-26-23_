local TweenService = game:GetService("TweenService");


local Player = game.Players.LocalPlayer;
local PlayerGui = Player and Player:WaitForChild("PlayerGui");
local PHeGui = PlayerGui and PlayerGui:WaitForChild("PHeGui");

local AlertNotificationsContainer = Instance.new("Folder",PHeGui);
AlertNotificationsContainer.Name = "Alert-Notifications-Container";


local module = {
	Name = "AlertNotification";
	ClassName = "AlertNotification";
	Icon = "";
	Body = "";
	Header = "";
	Color = Color3.fromRGB(255, 255, 255);
	Visible = true; 
	Parent = workspace;
	--Lifetime =	
};


function module:_CreateComponents()
	local App = self:_GetAppModule();

	local AlertButton = App.new("Button");
	AlertButton.Size = UDim2.fromOffset(50,50);
	AlertButton.ButtonFlexSizing = false;
	AlertButton.Text = "";
	AlertButton.Roundness = UDim.new(0,35);

	local ContentFrame = App.new("Frame",AlertButton);
	ContentFrame.Position = UDim2.new(1,10,.5,0);
	ContentFrame.AnchorPoint = Vector2.new(0,.5);
	ContentFrame.StrokeTransparency = 1;
	ContentFrame.Size = UDim2.new(0,220,0,0);
	ContentFrame.Roundness = UDim.new(0,30);
	ContentFrame.BackgroundColor3 = Color3.new(1,1,1);
	ContentFrame.Visible = false;
	ContentFrame.Name = "Content-Frame";

	local ContentToast = App.new("Toast",ContentFrame);
	ContentToast.Position = UDim2.new(.5,0,0,5);
	ContentToast.AnchorPoint = Vector2.new(.5);
	--ContentToast.Header = "";
	--ContentToast.Body = "";
	ContentToast.BackgroundTransparency = 1;
	--ContentToast.CanvasImage = "rbxasset://textures/ui/Controls/TouchTapIcon@3x.png";

	local h,b = ContentToast:GET("HeaderText"),ContentToast:GET("BodyText");

	h.TextColor3 = Color3.fromRGB(0);
	b.TextColor3 = Color3.fromRGB(0);

	h.TextTransparency = .15;
	b.TextTransparency = .3;



	return AlertButton, ContentFrame, ContentToast;
end;
--//
function module:_adjustSize()
	local ContentToast = self:GET("ContentToast");
	local ContentFrame = self:GET("ContentFrame");
	local _abs = ContentToast:GetAbsoluteSize();
	ContentFrame.Size = UDim2.fromOffset(220) + UDim2.fromOffset(0,_abs.Y) + UDim2.fromOffset(0,10);
end;
--//

function module:_Show()
	local AlertButton = self:GET("AlertButton");
	local TargetPos = self._TargetPos;
	local FinalPos = self._FinalPos;
	local EndInfo = self._EndInfo;
	local ContentToast = self:GET("ContentToast");
	local ContentFrame = self:GET("ContentFrame");
	AlertButton.Visible = true;
	AlertButton:JiggleEffect();

	
	--wait(1);

	local _f = AlertButton:GetGUIRef();
	local _t = TweenService:Create(_f, TweenInfo.new(.25), {Position = TargetPos});
	_t:Play();
	
	self:_adjustSize();
	
	local t_con;
	t_con = _t.Completed:Connect(function()
		t_con:Disconnect();
		local _t2 = TweenService:Create(_f, TweenInfo.new(.15), {Position = FinalPos});
		_t2:Play();
		ContentFrame.Visible = true;

	end)
end;
--//
function module:_Hide(yieldEvent)
	
	local AlertButton = self:GET("AlertButton");
	local EndInfo = self._EndInfo;
	local ContentToast = self:GET("ContentToast");
	local ContentFrame = self:GET("ContentFrame");
	local _f = AlertButton:GetGUIRef();
	
	--wait(7);
	ContentFrame.Visible = false;
	local _t3 = TweenService:Create(_f, TweenInfo.new(.15), {Position = EndInfo.Position});
	_t3:Play();
	
	spawn(function()
		_t3.Completed:Wait();
		AlertButton:JiggleEffect();
		wait(.5);
		AlertButton.Visible = false;
	end);
	return yieldEvent and _t3.Completed;

end;
--//
function module:Destroy()
	local e = self:Hide(true);
	e:Wait();
	self:GetRef():Destroy();
end;
--//
function module:_Render()
	
	
	local EndInfo = {
		Position = UDim2.new(.5,0,.95,0);
		AnchorPoint = Vector2.new(.5,1);
	}
	
	local AlertButton,ContentFrame,ContentToast = self:_CreateComponents();
	--ContentToast.Header = Header;
	--ContentToast.Body = Body;
	
	AlertButton.Position = EndInfo.Position;
	AlertButton.AnchorPoint = EndInfo.AnchorPoint;
	AlertButton.StrokeTransparency = 1;

	--AlertButton.Icon = Icon;

	AlertButton.Parent = AlertNotificationsContainer;
	
	local TargetPos = EndInfo.Position - UDim2.fromOffset( (ContentFrame.Size.X.Offset/2 )+ContentFrame.Position.X.Offset/2)
	local FinalPos = TargetPos - UDim2.fromOffset(ContentFrame:GetAbsoluteSize().Y/2);
	
	self._EndInfo = EndInfo;
	self._FinalPos = FinalPos;



	
	return {
		["Color"] = function(v)
			AlertButton.BackgroundColor3 = v;
		end,
		["Header"] = function(v)
			ContentToast.Header = v;
			self:_adjustSize();
		end,
		["Body"] = function(v)
			ContentToast.Body = v;
			self:_adjustSize();
		end,
		["Icon"] = function(v)
			AlertButton.Icon = v;
			self:_adjustSize();
		end,
		["Visible"] = function(v)
			if(v)then
				self:_Show();
			else
				self:_Hide();
			end
		end,
		_Components = {
			AlertButton = AlertButton;
			ContentFrame = ContentFrame;
			ContentToast = ContentToast;
		};
	};
end;



return module
