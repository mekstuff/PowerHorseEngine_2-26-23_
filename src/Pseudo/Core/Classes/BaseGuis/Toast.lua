local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local Toast = {
	Name = "Toast";
	ClassName = "Toast";
	CloseButtonVisible = false;
	HeaderTextSize = 18;
	HeaderTextColor3 = Theme.getCurrentTheme().Text;
	CanvasImage = "";
	IconImage = "";
	xMax = 200;
	Size = UDim2.fromOffset(200);
	AutomaticSize = Enum.AutomaticSize.Y;
	Header = "Toast";
	Body = "";
	BodyTextColor3 = Theme.getCurrentTheme().Text;
	BodyTextSize = 15;
	Subheader = "";
	CanCollapse = false;
	BackgroundColor3 = Color3.fromRGB(18, 18, 18);
	StrokeTransparency = 1;
	Roundness = UDim.new(0);
	Padding = Vector2.new(5,5);
	--Size =
};
Toast.__inherits = {"GUI","BaseGui"}


function Toast:_Render(App)
	
--[[
	local Wrapper = Instance.new("Frame", self:GetRef());
	Wrapper.BackgroundTransparency = 1;
	Wrapper.AutomaticSize = Enum.AutomaticSize.XY;
]]
	
	
	local ToastWrapper = App.new("Frame");
	ToastWrapper.ActiveBehaviour = Enumeration.ActiveBehaviour.None;
	ToastWrapper.AutomaticSize = Enum.AutomaticSize.XY;
	
	local Padding = Instance.new("UIPadding",ToastWrapper:GetGUIRef());
	Padding.Name = "SpaceAround";

	local SubToastWrapper = Instance.new("Frame");
	SubToastWrapper.Size = UDim2.new(0);
 
	ToastWrapper.Parent = self:GetRef();
	SubToastWrapper.Parent = (ToastWrapper:GetGUIRef());
	local HeaderText, SubheaderText, BodyText = App.new("Text"),App.new("Text"),App.new("Text");
	HeaderText.RichText=true;SubheaderText.RichText=true;
	--BodyText.SmartText=true;


	HeaderText.Name = "Header";
	HeaderText.TextXAlignment = Enum.TextXAlignment.Left;
	HeaderText.TextTruncate = Enum.TextTruncate.AtEnd;
	HeaderText.BackgroundTransparency = 1;
	HeaderText.Font = Theme.getCurrentTheme().Font
	SubheaderText.TextXAlignment = Enum.TextXAlignment.Left;
	SubheaderText.TextScaled = true;
	SubheaderText.BackgroundTransparency = 1;
	SubheaderText.Font = Enum.Font.SourceSans;
	SubheaderText.TextTransparency = .2;
	SubheaderText.Visible = false;
	BodyText.Name = "Body";
	BodyText.BackgroundTransparency = 1;
	BodyText.TextXAlignment = Enum.TextXAlignment.Left;
	BodyText.TextYAlignment = Enum.TextYAlignment.Top;
	BodyText.TextWrapped = true;
	--BodyText.TextSize = 14;

	local CanvasImage = App.new("Image", SubToastWrapper);
	CanvasImage.ScaleType = Enum.ScaleType.Fit;
	CanvasImage.Position = UDim2.new(0,0,0,5)
	CanvasImage.BackgroundTransparency = 1;

	local IconImage = App.new("Image", SubToastWrapper);
	IconImage.ScaleType = Enum.ScaleType.Fit;
	IconImage.BackgroundTransparency = 1;


	SubToastWrapper.AutomaticSize = Enum.AutomaticSize.XY;
	SubToastWrapper.BackgroundTransparency = 1;

	HeaderText.Parent = (SubToastWrapper);SubheaderText.Parent = (SubToastWrapper);BodyText.Parent = (SubToastWrapper);
	


	local TransparencyGradient = Instance.new("UIGradient", ToastWrapper:GET("Frame"));
	TransparencyGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0.2),
		NumberSequenceKeypoint.new(1, 0.65)
	};
	
	local AfterContainer = App.new("Frame",SubToastWrapper);
	AfterContainer.Name = "_After";
	AfterContainer.Position = UDim2.new(0,0,1,5);
	AfterContainer.Size = UDim2.new(1);
	AfterContainer.BackgroundTransparency = 1;AfterContainer.StrokeTransparency = 1;
	AfterContainer.AutomaticSize = Enum.AutomaticSize.XY;
	
	local CloseBtn;
	
	local autosizing=false;
	local function autoSize()
		if(autosizing)then print("already autosizing") return end;
		autosizing=true;
		IconImage.Size = UDim2.fromOffset(20,20);
		if(CloseBtn)then CloseBtn.Size = UDim2.fromOffset(20,20);end;

		CanvasImage.Position = UDim2.new(0,0,0,5);
		CanvasImage.Size = UDim2.fromOffset(45,45);


		if(not self.CloseButtonVisible)then
			if(CloseBtn)then
				CloseBtn.Size = UDim2.new(0)end;
		else

			CloseBtn.Position = UDim2.fromOffset(self.xMax);
		end

		if(self.IconImage == "")then
			IconImage.Size = UDim2.new(0);
		else
			local iconimagepos = UDim2.fromOffset(self.xMax-IconImage:GetAbsoluteSize().X,5);
			if(self.CloseButtonVisible)then
				iconimagepos = iconimagepos+UDim2.fromOffset(0,CloseBtn:GetAbsoluteSize().Y);
			end;
			IconImage.Position = iconimagepos;
		end

		if(self.CanvasImage == "")then
			CanvasImage.Size = UDim2.new(0)+UDim2.fromOffset(0, CanvasImage.Size.Y.Offset);
		end

		HeaderText.Position = UDim2.new(0, self.CanvasImage ~= "" and CanvasImage:GetAbsoluteSize().X+5 or 0, 0, self.CanvasImage ~= "" and 5 or 0);
		HeaderText.Size = self.Header ~= "" and UDim2.fromOffset(self.xMax-HeaderText.Size.X.Offset,CanvasImage:GetAbsoluteSize().Y/2) or UDim2.new(0);
		
		local BodyY = 0;
		if(self.CanvasImage ~= "")then
			BodyY = CanvasImage:GetAbsoluteSize().Y+10;
		elseif(self.Header ~= "")then
			BodyY = (HeaderText:GetAbsoluteSize().Y+5);
		end
		

		if(self.Header == "" and self.Subheader == "") then
			if(self.CanvasImage == "") then
				CanvasImage.Size = UDim2.new(0)+UDim2.fromOffset(0,IconImage.Size.Y.Offset);
			else
				CanvasImage.Position = UDim2.fromOffset((SubToastWrapper.AbsoluteSize.X/2)-(CanvasImage:GetAbsoluteSize().X/2) ,CanvasImage.Position.Y.Offset);
			end
		end;
		

		BodyText.Position = UDim2.fromOffset(0, BodyY)
	
		local TargetSizeBody = BodyText:GetTextSizeFromTextService(self.Body, BodyText.TextSize, BodyText.Font, Vector2.new(self.xMax, math.huge));


		local bodsSubtr = self.IconImage and IconImage:GetAbsoluteSize().X or (self.CloseButtonVisible and CloseBtn:GetAbsoluteSize().X or 0);


		BodyText.Text = self.Body;
		BodyText.Size = UDim2.fromOffset(self.xMax -bodsSubtr  , TargetSizeBody.Y);
		autosizing=false;
	end;
	
	return {
		--["Size"] = function()
			
		--end,
 		["xMax"] = function()
			autoSize();
		end,
		["Body"] = function(Value)
			autoSize();
		end,["BodyTextSize"] = function(Value)
			autoSize();	
		end,["BodyTextColor3"] = function(Value)
			BodyText.TextColor3 = Value;	
		end,
		
		["Padding"] = function(Value)
			Padding.PaddingLeft = UDim.new(0,self.Padding.X);
			Padding.PaddingRight = UDim.new(0,self.Padding.X);
			Padding.PaddingTop = UDim.new(0,self.Padding.Y);
			Padding.PaddingBottom = UDim.new(0,self.Padding.Y);	
		end,
		["HeaderTextSize"] = function(Value)
			HeaderText.TextSize = Value;
			autoSize();
		end,
		--[[ ["Subheader"] = function(Value)
			SubheaderText.Text = Value;
			--autoSize();
		end,]]
		["Header"] = function(Value)
			--HeaderText.Text = "<b>"..Value.."</b>";
			HeaderText.Text = Value;
			autoSize();
		end,["HeaderTextColor3"] = function(Value)
			HeaderText.TextColor3 = self.HeaderTextColor3
		end,
		["CanCollapse"] = function(Value)
			if(Value)then
				if(not self._dev._collapscon)then
					self._beforecollapsed = self.Body;
					self._collapsed = true;
					self.Body = string.sub(self.Body, 1,#self.Body/3).."...";
					
					self._dev._collpscon = ToastWrapper.MouseButton1Down:Connect(function()
						if(self._collapsed)then
							self._collapsed = false;
							self.Body = self._beforecollapsed;
						else
							self._beforecollapsed = self.Body;
							self._collapsed = true;
							self.Body = string.sub(self.Body, 1,#self.Body/3).."...";
						end
					end)
				end;
			else
				if(self._dev._collpscon)then
					print(self._beforecollapsed)
					if(self._beforecollpsed)then
						self.Body = self._beforecollapsed;
					end
					self._dev._collpscon:Disconnect();self._dev._collpscon=nil;
			
				end;
			end
		end,
		["CanvasImage"] = function(Value)
			CanvasImage.Image = self.CanvasImage;
			--autoSize();
		end,["IconImage"] = function(Value)
			IconImage.Image = self.IconImage;
			--autoSize();
		end,["CloseButtonVisible"] = function(Value)
			if(Value)then
				if(not CloseBtn)then
					CloseBtn = App.new("CloseButton");
					CloseBtn.Parent = SubToastWrapper;
					CloseBtn.AnchorPoint = Vector2.new(1);
					CloseBtn.Size = UDim2.fromOffset(20,20);
					self:AddEventListener("CloseButtonPressed",true, CloseBtn:GetEventListener("Activated"));
				end;
			end;
			if(CloseBtn)then CloseBtn.Visible = Value;autoSize(); 
			end;
		end,
		
	--[[
		["_All"] = function(Value)
			
			local CloseBtn = nil;

			if(self.CloseButtonVisible and CloseBtn == "XD")then
				CloseBtn = App.new("CloseButton",{
					Parent = SubToastWrapper;
					AnchorPoint = Vector2.new(1);
					Size = UDim2.fromOffset(20,20);
				});
				--CloseBtn:GetComponent("CloseBtn").TextAdjustment = App.Enumeration.Adjustment.Left;

				local CloseBtnPressedEvent = self:AddEventListener("CloseButtonPressed",true, CloseBtn:GetEventListener("Activated"));


				--self._dev.Components.Vanilla["CloseBtn"] = CloseBtn;

			end

]]


--[[
			if(self.After)then
				local After = Core.getElementObject(self.After);
				After.Parent = SubheaderText;
				After.Position = UDim2.fromScale(0,1);
			end


			
		end,]]
		_Components = {
			FatherComponent = ToastWrapper:GetGUIRef();	
			ToastWrapper = ToastWrapper;
			_Appender = AfterContainer:GetGUIRef();
			HeaderText = HeaderText;
			BodyText = BodyText;
			Gradient = TransparencyGradient;
		};
		_Mapping = {
		--[[	
			[Wrapper] = {
				"Visible","AnchorPoint","Position"
			};
		]]
			[ToastWrapper] = {
				"BackgroundColor3","BackgroundTransparency","ClipsDescendants",
				"StrokeThickness","StrokeColor3","StrokeTransparency","Roundness",
				"Visible","AnchorPoint","Position"	
			}
		};
	};
end;


return Toast
