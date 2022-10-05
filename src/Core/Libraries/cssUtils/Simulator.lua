-- local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
-- local Enumeration = PowerHorseEngine:GetGlobal("Enumeration");

return {
	[".simulator-text"] = function(cssObject)
		cssObject:ApplyProperty({Font = Enum.Font.FredokaOne});
	end,
	[".simulator-button"] = function(cssObject)
		cssObject:ApplyProperty({TextScaled=true})
		cssObject:GetSelf():addcss("simulator-text");
	end,
	[".simulator-prompt"] = function(cssObject)
		cssObject:GetSelf():GET("Modal"):addcss("simulator-modal")
	end,
	[".simulator-modal"] = function(cssObject)
		cssObject:ApplyProperty({
			HeaderTextSize = 35;
			HeaderTextFont = Enum.Font.FredokaOne;
			BodyTextSize = 33;
			BodyTextFont = Enum.Font.FredokaOne;
		});
	
		local self = cssObject:GetSelf();

	--[[
	
		local btns = self._dev.__btns;
		if(btns)then
			for _,v in pairs(btns) do
				v:addcss("simulator-button");
			end
		end
		cssObject:Connect(self.ButtonAdded:Connect(function(btn)
			btn:addcss("simulator-button");
		end));
	]]

		local Header = self:GET("Header");
		local Wrapper = self:GET("Wrapper");
		local Top = self:GET("Top");

		local CloseButton = self:GET("CloseButton");
		local CloseButton_Btn = CloseButton:GET("Button");

		cssObject:ApplyProperty(CloseButton,{
			AnchorPoint = Vector2.new(0,.5);
			Position = UDim2.fromScale(.98,-.5);
		});
		cssObject:ApplyProperty(CloseButton_Btn,{
			BackgroundColor3 = Color3.fromRGB(255, 90, 90);
			TextTransparency = 0;
			BackgroundTransparency = 0;
			TextScaled = true;
			Roundness = UDim.new(0,30);
			Size = UDim2.fromOffset(40,40);
		})
		cssObject:ApplyProperty(Top, {
			AutomaticSize = Enum.AutomaticSize.None;
			Size = UDim2.new(1,0,0,5);	
		})
		cssObject:ApplyProperty(Wrapper, {
			StrokeThickness = 4;
			StrokeTransparency = 0;
			StrokeColor3 = Color3.fromRGB(11, 11, 33);
		});
		cssObject:ApplyProperty(Header, {
			AnchorPoint = Vector2.new(.4,.65);	
			TextStrokeColor3 = Wrapper.StrokeColor3;
			TextStrokeTransparency = Wrapper.StrokeTransparency;
			TextStrokeThickness = Wrapper.StrokeThickness;
		})
		
		local StrokeColorUpd = Wrapper:GetPropertyChangedSignal("StrokeColor3"):Connect(function()
			cssObject:ApplyProperty(Header,{
				TextStrokeColor3 = Wrapper.StrokeColor3;
			});
		end);
		local StrokeTransparencyUpd = Wrapper:GetPropertyChangedSignal("StrokeTransparency"):Connect(function()
			cssObject:ApplyProperty(Header,{
				TextStrokeTransparency = Wrapper.StrokeTransparency;
			});
		end);
		local StrokeThicknessUpd = Wrapper:GetPropertyChangedSignal("StrokeThickness"):Connect(function()
			cssObject:ApplyProperty(Header,{
				TextStrokeThickness = Wrapper.StrokeThickness;
			});
		end);
		
		cssObject:Connect(StrokeColorUpd, StrokeTransparencyUpd, StrokeThicknessUpd)
	end,
}
