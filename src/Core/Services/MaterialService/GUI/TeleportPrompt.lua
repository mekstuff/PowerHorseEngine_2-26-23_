local module = {
	Name = "UpdatePrompt";
	ClassName = "UpdatePrompt";
	Header = "Teleport";
	Teleports = {};
	Level = 1;
}


--//
local function clear(x)
	local c = x:GetChildren();
	if(#c <= 1)then return end;
	for _,v in pairs(x:GetChildren()) do
		if(not v:IsA("UIListLayout"))then 
			v:Destroy();
		end
	end
end
--//

function module:_Render()
	local App = self:_GetAppModule();

	local Prompt = App.new("Prompt");
	Prompt.Blurred = true;
	Prompt.StartPosition = UDim2.fromScale(.5,-1);
	Prompt.DestroyOnOverride = true;
	
	local ContentScroller = App.new("ScrollingFrame",Prompt);
	ContentScroller.Size = UDim2.new(.95,0,0,150);
	ContentScroller.AnchorPoint = Vector2.new(.5);
	ContentScroller.Position = UDim2.new(.5);
	ContentScroller.BackgroundTransparency = 1;

	local Grid = Instance.new("UIListLayout",ContentScroller:GetGUIRef());
	Grid.Padding = UDim.new(0,3);
	
	self._dev.prompt = Prompt;
	
	return {
		["*Parent"] = function(v)
			Prompt.Parent = v;
		end,
		["Level"] = function(v)
			Prompt.Level = v;
		end,
	
		["Version"] = function(v)
			Prompt.Header = "Update "..v;
		end,
		["Teleports"] = function(v)
			
			clear(ContentScroller:GetGUIRef());
			local Theme = App:GetGlobal("Theme").getCurrentTheme();
			local ModalHeader = Prompt:GET("Modal"):GET("Header");
			for _,v in pairs(v) do
				local hiddenSubText = v:match("^>");
				if(hiddenSubText)then
					v = string.sub(v,2,#v);
				end
				local isHeader = not (v:match("^+") or hiddenSubText) and true or false;
				local text = Instance.new("TextLabel");
				text.TextWrapped = true;
				text.Text = v;
				text.BackgroundTransparency = 1;
				text.TextColor3 = Theme.ForegroundText;
				text.Font = Theme.Font;
				text.TextSize = isHeader and ModalHeader.TextSize or ModalHeader.TextSize-12;
				text.TextTransparency = isHeader and 0 or .15;
				--text.TextXAlignment = isHeader and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left;
				text.Size = UDim2.new(1);
				text.AutomaticSize = Enum.AutomaticSize.Y;
				text.Parent = ContentScroller:GetGUIRef();
			end
		end,
	};
end


function module.new(service)
	local CustomClass = service:Create(module);

	
	return CustomClass;
end;

return module
