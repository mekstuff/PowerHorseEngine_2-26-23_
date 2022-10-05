local module = {}

local TweenService = game:GetService("TweenService");
local CustomClassService = require(script.Parent.CustomClassService);

function module:_CreateComponents()
	local App = require(script.Parent.Parent.Parent.Pseudo);
	
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

local Waiting={};

local function e(Icon,Body,Header,Color,Lifetime)
	local n = CustomClassService:CreateClassAsync(require(script.Class));

	n.Icon = Icon or "";
	n.Body = Body or "";
	if(Color)then n.Color = Color;end;
	n.Header = Header or "";
	Lifetime = Lifetime and math.max(20,Lifetime) or 5;
	
	wait(Lifetime);
	
	n.Visible = false;
end

function module:Alert(Icon,Body,Header,Color,Lifetime)
	
	if(typeof(Icon) == "table")then
		local t = Icon;
		Icon = t.Icon;
		Body = t.Body;
		Header = t.Header;
		Color = t.Color;
		Lifetime = t.Lifetime;
	end
	
	if(#Waiting > 0)then
		table.insert(Waiting,{Icon = Icon, Body = Body, Color = Color, Lifetime = Lifetime});
		for _,v in pairs(Waiting)do
			e(v.Icon,v.Body,v.Header,v.Color,v.Lifetime);
		end;
		Waiting={};
	else
		e(Icon,Body,Header,Color,Lifetime);
	end
	
	--return n;
	
	--[[
	Color = Color or Color3.new(1,1,1);
	Icon = Icon or "";
	Body = Body or "";
	Header = Header or "";
	Lifetime = Lifetime or 7;
	
	StartInfo = StartInfo or {};
	EndInfo = EndInfo or {};
	
	StartInfo.AnchorPoint = StartInfo.AnchorPoint or Vector2.new(.5,1);
	StartInfo.Position = StartInfo.Position or UDim2.new(.5,0,1.2,0);
	
	EndInfo.AnchorPoint = EndInfo.AnchorPoint or StartInfo.AnchorPoint;
	EndInfo.Position = EndInfo.Position or UDim2.new(.5,0,.95,0);
	
	local AlertButton,ContentFrame,ContentToast = self:_CreateComponents();
	ContentToast.Header = Header;
	ContentToast.Body = Body;
	
	if(Color)then
		if(typeof(Color) == "number")then
			AlertButton.BackgroundTransparency = Color;
		else
			AlertButton.BackgroundColor3 = Color;
		end
		
	end;
	
	AlertButton.Position = EndInfo.Position;
	AlertButton.AnchorPoint = EndInfo.AnchorPoint;
	AlertButton.StrokeTransparency = 1;
	
	AlertButton.Icon = Icon;
	
	AlertButton.Parent = AlertNotificationsContainer;
	
	AlertButton:JiggleEffect();
	
	local TargetPos = EndInfo.Position - UDim2.fromOffset( (ContentFrame.Size.X.Offset/2 )+ContentFrame.Position.X.Offset/2)
	local FinalPos = TargetPos - UDim2.fromOffset(ContentFrame:GetAbsoluteSize().Y/2);
	wait(1);
	
	local _f = AlertButton:GetGUIRef();
	--TweenService:Create()
	local _t = TweenService:Create(_f, TweenInfo.new(.25), {Position = TargetPos});
	_t:Play();
	
	local _abs = ContentToast:GetAbsoluteSize();
	
	ContentFrame.Size = ContentFrame.Size + UDim2.fromOffset(0,_abs.Y) + UDim2.fromOffset(0,10);
	
	--print(ContentToast:GetAbsoluteSize())
	
	local t_con;
	t_con = _t.Completed:Connect(function()
		t_con:Disconnect();
		local _t2 = TweenService:Create(_f, TweenInfo.new(.15), {Position = FinalPos});
		_t2:Play();
		ContentFrame.Visible = true;
		wait(Lifetime);
		ContentFrame.Visible = false;
		local _t3 = TweenService:Create(_f, TweenInfo.new(.15), {Position = EndInfo.Position});
		_t3:Play();
		_t3.Completed:Wait();
		AlertButton:JiggleEffect();
		wait(.1);
		AlertButton:Destroy();
	end)
	
	return AlertButton;
	]]
end;

return module
