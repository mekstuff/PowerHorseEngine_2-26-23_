local module = {}
local Player = game.Players.LocalPlayer;
local TweenService = game:GetService("TweenService");

function module.new(Sequences,defaultColor,defaultLifeTime)
	defaultColor = defaultColor or Color3.fromRGB(255,255,255);
	defaultLifeTime = defaultLifeTime or 2;
	local PlayerGui = Player and Player:WaitForChild("PlayerGui");
	local Pseudo = require(script.Parent.Parent.Parent.Pseudo);
	local Portal = Pseudo.new("Portal",PlayerGui);
	Portal.IgnoreGuiInset = true;
	Portal.ZIndex = 1000;
	
	local ItemFrame = Instance.new("Frame");
	--ItemFrame.BackgroundTransparency = 1;
	ItemFrame.BackgroundColor3 = defaultColor or Color3.fromRGB(255,255,255);
	ItemFrame.Size = UDim2.new(1,0,1,0);
	--ItemFrame.BackgroundColor3 = color;
	for _,v in pairs(Sequences)do
		local logo,color,lifetime = v.Logo or "",v.Color or defaultColor,v.Lifetime or defaultLifeTime;
		print(lifetime)
		local img;
		if(v.Triggered)then
			v.Triggered();
		end;
		if(typeof(logo) ~= "string")then
			logo.Parent = ItemFrame;
		else
			img = Instance.new("ImageLabel");
			img.Size = UDim2.new(.5,0,.5,0);
			img.ScaleType = Enum.ScaleType.Fit;
			img.AnchorPoint = Vector2.new(.5,.5);
			img.Position = UDim2.fromScale(.5,.5);
			img.Image = logo;
			img.ImageTransparency = 1;
			img.BackgroundTransparency = 1;

			img.Parent = ItemFrame;
		end

		ItemFrame.Parent = Portal:GetGUIRef();

		local AnimSpeed = math.min(1.5,lifetime/2)

		local FrameFadeIn = TweenService:Create(ItemFrame, TweenInfo.new(AnimSpeed),{BackgroundColor3 = color}):Play();
		if(img)then
			local ImgSizeIn = TweenService:Create(img, TweenInfo.new(AnimSpeed),{Size = img.Size+UDim2.fromOffset(30,30), ImageTransparency = 0}):Play();
		end;
		wait(lifetime);

		local FrameFadeOut = TweenService:Create(ItemFrame, TweenInfo.new(AnimSpeed),{BackgroundColor3 = color});
		if(img)then
			local ImgTransparencyOut = TweenService:Create(img, TweenInfo.new(AnimSpeed),{ImageTransparency = 1, Size = UDim2.fromScale(.5,.5)});
			ImgTransparencyOut:Play();
		end;
		if(v.TriggerEnded)then
			v.TriggerEnded();
		end
		FrameFadeOut:Play();
		FrameFadeOut.Completed:Wait();
		
		if(img)then
			img:Destroy();	
		end
	end;
	local t = TweenService:Create(ItemFrame, TweenInfo.new(1),{BackgroundTransparency = 1});
	t:Play();
	t.Completed:Connect(function()
		ItemFrame:Destroy();
	end)
end;

return module
