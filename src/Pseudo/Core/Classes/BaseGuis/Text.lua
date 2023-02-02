local Theme = require(script.Parent.Parent.Parent.Theme);
local IsClient = game:GetService("RunService"):IsClient();
local SmartTextService;

local Text = {
	Name = "Text";
	ClassName = "Text";
	_RBXClassName = "TextLabel";
	Font = Theme.getCurrentTheme().Font or Enum.Font.Gotham;
	LineHeight = 1;
	RichText = false;
	Text = "";
	--TextAdjustment = Enumeration.Adjustment.
	TextColor3 = Theme.getCurrentTheme().Text;
	TextScaled = false;
	TextSize = Theme.getCurrentTheme().FontSize or 16;
	TextStrokeColor3 = Color3.fromRGB(0,0,0);
	TextStrokeTransparency = 1;
	TextStrokeThickness = 1;
	TextTransparency = 0;
	TextTruncate = Enum.TextTruncate.None;
	TextWrapped = false;
	TextXAlignment = Enum.TextXAlignment.Center;
	TextYAlignment = Enum.TextYAlignment.Center;
	SmartText = false;
	
	BackgroundTransparency = 1;
};
Text.__inherits = {"GUI","BaseGui","BaseText"};

local function clearSmartTextContainer(stc)
	if(not stc)then return end;
	for _,v in pairs(stc:GetChildren())do
		if not(v:IsA("UIGridLayout"))then
			v:Destroy();
		end;
	end
end

local function setGridToAlignment(grid,xalignment,yalignment)
	if(xalignment)then
		grid.HorizontalAlignment = Enum.HorizontalAlignment[xalignment.Name];
	end;
	if(yalignment)then
		grid.VerticalAlignment = Enum.VerticalAlignment[yalignment.Name];
	end;
end

function Text:_Render(App)
	
	
	local TextComponent = Instance.new("TextLabel");
	TextComponent.Name = "$l_Text";
	
	self:AddEventListener("InputBegan",true,TextComponent.InputBegan);
	self:AddEventListener("InputEnded",true,TextComponent.InputEnded);
	self:AddEventListener("InputChanged",true,TextComponent.InputChanged);
	
	TextComponent.Parent = self:GetRef();
	
	local SmartTextContainer;
	
	local UIStroke = Instance.new("UIStroke",TextComponent);
	UIStroke.Name = "$l_Stroke";
	
	
	local function smartTextUtil()
		if(not self.SmartText or not self._dev)then return end;
		if(not SmartTextService)then SmartTextService = App:GetService("SmartTextService");end;
		--local sm = SmartTextService:GetSmartText(v,TextComponent);
		if(not SmartTextContainer)then
			SmartTextContainer = Instance.new("Frame");
			SmartTextContainer.Name = "";
			SmartTextContainer.Size = UDim2.fromScale(1,1);
			SmartTextContainer.Transparency = 1;
			SmartTextContainer.Parent = TextComponent;
			local UIGrid = Instance.new("UIGridLayout",SmartTextContainer);
			UIGrid.FillDirection = Enum.FillDirection.Horizontal;
			UIGrid.SortOrder = Enum.SortOrder.LayoutOrder;
			UIGrid.CellSize = UDim2.fromOffset(2,16);
			UIGrid.CellPadding = UDim2.new(0);
			setGridToAlignment(UIGrid,self.TextXAlignment,self.TextYAlignment);
			self._dev.smarttextgrid = UIGrid;
		end;
		TextComponent.Text = "";
		if(IsClient)then
			clearSmartTextContainer(SmartTextContainer);
			local e = SmartTextService:GetSmartText(self.Text,TextComponent,SmartTextContainer);
			if(not e)then
				TextComponent.Text = self.Text;
			end
		end;
	end
	

	local function smartTextUpdate(prop,val)
		self:_RenderOnStep(function()
			smartTextUtil();
		end)
		
		--if(not SmartTextContainer)then return end;
		--for _,v in pairs(SmartTextContainer:GetChildren()) do
		--	--if()
		--	if(v:IsA("TextLabel"))then
		--		local TextConstraint_SmartText = v:FindFirstChild("TextConstraint-SmartText");
		--		v[prop] = val;
		--		if(prop == "TextSize")then

		--			local s = ROBLOXTextService:GetTextSize(v.Text,val,v.Font,Vector2.new(math.huge,math.huge))
		--			TextConstraint_SmartText.MinSize = Vector2.new(s.X,s.Y);
		--		end
		--	end;
		--end
	end
	
	return {
		["TextStrokeColor3"] = function(v) UIStroke.Color = v;end;
		["TextStrokeTransparency"] = function(v) UIStroke.Transparency = v;end;
		["TextStrokeThickness"] = function(v) UIStroke.Thickness = v;end;
		--[[
		["TextXAlignment"] = function(v)
			if(self._dev.smarttextgrid)then
				local grid = self._dev.smarttextgrid;
				setGridToAlignment(grid,v);
			end;
		end,["TextYAlignment"] = function(v)
			if(self._dev.smarttextgrid)then
				local grid = self._dev.smarttextgrid;
				setGridToAlignment(grid,nil,v);
			end;
		end,
		["SmartText"] = function(v)
			if(v)then
				smartTextUtil();
			else
				clearSmartTextContainer(SmartTextContainer);
				TextComponent.Text = self.Text;
			end
		end,
		["Text"] = function(v)
			if(v ~= "Text")then
				if(self.SmartText)then		
					smartTextUtil();	
				else
					clearSmartTextContainer(SmartTextContainer);
					TextComponent.Text = v;
				end
			end
		end,
		["TextColor3"] = function(v)
			--if(self.SmartText)then
				smartTextUpdate("TextColor3",v);
			--else
				TextComponent.TextColor3 = v;
			--end
		end,
		["TextTransparency"] = function(v)
			--if(self.SmartText)then
				smartTextUpdate("TextTransparency",v);
			--else
				TextComponent.TextTransparency = v;
			--end
		end,
		["TextSize"] = function(v)
			--if(self.SmartText)then
			if(self._dev.smarttextgrid)then
				self._dev.smarttextgrid.CellSize = UDim2.fromOffset(2,v);
			end
				smartTextUpdate("TextSize",v);
			--else
				TextComponent.TextSize = v;
			--end
		end,
		]]
		_Components = {
			FatherComponent = TextComponent;
			TextComponent = TextComponent;
		};
		_Mapping = {
			[TextComponent] = 
				{"Font","LineHeight","RichText","TextScaled","TextTruncate","TextWrapped",
					"Position","Size","Visible","BackgroundColor3","BackgroundTransparency","ZIndex","AnchorPoint","AutomaticSize","BorderSizePixel","LayoutOrder","ClipsDescendants",
					"Rotation",
					"Text","TextSize","TextTransparency","TextXAlignment","TextYAlignment","TextColor3",
			}
		}
	};
end;

return Text
