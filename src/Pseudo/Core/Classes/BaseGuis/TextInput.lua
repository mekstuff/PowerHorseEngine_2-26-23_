local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local IsClient = game:GetService("RunService"):IsClient();
local TextService = game:GetService("TextService");
local TweenService = game:GetService("TweenService");

local TweenInfo_ = TweenInfo.new(.35,Enum.EasingStyle.Back);

--[=[
	@class TextInput
]=]
local TextInput = {
	Name = "TextInput";
	ClassName = "TextInput";
	Size = UDim2.fromOffset(120,20);
	PlaceholderText = "Text Input";
	PlaceholderTextColor3 = Color3.fromRGB(178, 178, 178);
	PlaceholderTextTransparency = 0;

	PlaceholderBehaviour = Enumeration.PlaceholderBehaviour.Default;
	Margin = Vector2.new(5,5);
	Overflow = true;
	ClipsDescendants = true;
	TextXAlignment = Enum.TextXAlignment.Left;
	
	Roundness = UDim.new(0,3);
	BackgroundTransparency = 1;
	
	CurrentWord = "";
	CurrentWordStart = -1;
	CurrentWordEnd = -1;

	MultiLine = false;
	CursorPosition = 1;
	ClearTextOnFocus = true;
	SelectionStart = -1;
	ShowNativeInput = true;
	TextEditable = true;
	
	SelectedColor3 = Theme.getCurrentTheme().Primary;
	
	StringCapture = "";
	Feedback = "";
	FeedbackColor3 = Color3.fromRGB(255, 43, 43);
	Text = "";
};

TextInput.__inherits = {"BaseGui","GUI","Frame","Text"};

--[=[
	@prop PlaceholderText string
	@within TextInput
]=]
--[=[
	@prop PlaceholderTextColor3 Color3
	@within TextInput
]=]
--[=[
	@prop PlaceholderTextTransparency number
	@within TextInput
]=]
--[=[
	@prop PlaceholderBehaviour Enumeration.PlaceholderBehaviour
	@within TextInput
]=]
--[=[
	@prop Margin Vector2
	@within TextInput
]=]
--[=[
	@prop Overflow boolean
	@within TextInput
]=]
--[=[
	@prop TextXAlignment Enum.TextXAlignment
	@within TextInput
]=]
--[=[
	@prop CurrentWord string
	@readonly
	@within TextInput
]=]
--[=[
	@prop CurrentWordStart number
	@readonly
	@within TextInput
]=]
--[=[
	@prop CurrentWordEnd number
	@readonly
	@within TextInput
]=]
--[=[
	@prop MultiLine boolean
	@within TextInput
]=]
--[=[
	@prop CursorPosition number
	@within TextInput
]=]
--[=[
	@prop SelectionStart number
	@within TextInput
]=]
--[=[
	@prop ShowNativeInput boolean
	@within TextInput
]=]
--[=[
	@prop TextEditable boolean
	@within TextInput
]=]
--[=[
	@prop SelectedColor3 Color3
	@within TextInput
]=]
--[=[
	@prop StringCapture string
	@within TextInput
]=]
--[=[
	@prop Feedback string
	@within TextInput
]=]
--[=[
	@prop FeedbackColor3 Color3
	@within TextInput
]=]
--[=[
	@prop Text string
	@within TextInput
]=]

function TextInput:_Render(App)
	local App_TextService = App:GetService("TextService");
	local AllowTextUpdate = true;
	local Wrapper = App.new("Frame", self:GetRef());
	
	local TextBox = Instance.new("TextBox",Wrapper:GetGUIRef());
	TextBox.PlaceholderText = "";
	TextBox.AnchorPoint = Vector2.new(.5,.5);
	TextBox.Position = UDim2.fromScale(.5,.5);
	TextBox.BackgroundTransparency = 1;
	
	
	--[=[
		@prop Focused PHeSignal
		@within TextInput
	]=]
	local focused = self:AddEventListener("Focused",true,TextBox.Focused);
	--[=[
		@prop FocusLost PHeSignal
		@within TextInput
	]=]
	local focuslost = self:AddEventListener("FocusLost",true,TextBox.FocusLost);
	--[=[
		@prop MouseEnter PHeSignal
		@within TextInput
	]=]
	self:AddEventListener("MouseEnter",true,TextBox.MouseEnter)
	--[=[
		@prop Mouseleave PHeSignal
		@within TextInput
	]=]
	self:AddEventListener("MouseLeave",true,TextBox.MouseLeave);
	
	
	focused:Connect(function()
		Wrapper:GET("Stroke").Color = self.SelectedColor3;
	end);
	focuslost:Connect(function()
		Wrapper:GET("Stroke").Color = self.StrokeColor3;
	end);
	
	local PlaceholderText = App.new("Text",Wrapper:GetGUIRef());
	PlaceholderText.TextTransparency = .35;
	--PlaceholderText.Size = UDim2.fromScale(1,1);
	PlaceholderText.Position = UDim2.fromScale(.5,.5);
	PlaceholderText.AnchorPoint = Vector2.new(.5,.5);
	PlaceholderText.BackgroundTransparency = 1;
	PlaceholderText.TextTruncate = Enum.TextTruncate.AtEnd;

	local TextChanged = self:AddEventListener("TextChanged",true);
	
	
	local updatingWord = false;
	local function UpdateWord()
		if(updatingWord)then return end;
		updatingWord = true;		
		if(TextBox.CursorPosition == -1)then
			if(self.CurrentWordStart ~= -1)then
				--self.CurrentWordStart =-1;
				--self.CurrentWordEnd =-1;
				--self.CurrentWord = "";
			end;
		else
			local Text = TextBox.Text;
			local CursorPosition = TextBox.CursorPosition;
			local WordAtPos,WordAtPos_start,WordAtPos_end = App_TextService:GetWordAtPosition(Text,CursorPosition);
			self.CurrentWord = WordAtPos;
			self.CurrentWordStart = WordAtPos_start;
			self.CurrentWordEnd = WordAtPos_end;
		end;
		updatingWord = false;
	end
	
	TextBox:GetPropertyChangedSignal("CursorPosition"):Connect(function()
		game:GetService("RunService").RenderStepped:Wait();
		if(TextBox.SelectionStart == -1)then
			UpdateWord();
		end;
	end);
	
	TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		--local t = "";
		if(self.StringCapture ~= "")then
			local gsub = string.gsub(TextBox.Text, self.StringCapture,self._StringCaptureReplace or "");
		
			if(TextBox.Text ~= gsub)then
				TextBox.Text = gsub;
			end;
		
			return;
		end;

		if(TextBox.Text == "")then
			if(self.PlaceholderBehaviour == Enumeration.PlaceholderBehaviour.Default)then	
				PlaceholderText.Visible = true;
			elseif(self.PlaceholderBehaviour == Enumeration.PlaceholderBehaviour.Margin)then
				PlaceholderText.TextTruncate = Enum.TextTruncate.AtEnd;
				TweenService:Create(PlaceholderText:GetGUIRef(),TweenInfo_,{Position = UDim2.fromScale(.5,.5)}):Play();
			end;
		else
			if(self.PlaceholderBehaviour == Enumeration.PlaceholderBehaviour.Default)then	
				PlaceholderText.Visible = false;
			elseif(self.PlaceholderBehaviour == Enumeration.PlaceholderBehaviour.Margin)then
				PlaceholderText.TextTruncate = Enum.TextTruncate.None;
				TweenService:Create(PlaceholderText:GetGUIRef(),TweenInfo_,{Position = UDim2.fromScale(.5,-.5)}):Play();
			end;
		end;
	
		
		if(AllowTextUpdate)then
			AllowTextUpdate = false;
			self.Text = TextBox.Text;
			--print("u")
			AllowTextUpdate = true;
		end;
		if(IsClient)then
			--game:GetService('RunService').RenderStepped:Wait();
		end;
		
		TextChanged:Fire();
	
	end);
	
	TextBox.Text = self.Text;
	
	
	--self.Text = TextBox.Text;
	

	local OverflowConnection;
	local OverflowController = function()
		local x = TextService:GetTextSize(TextBox.Text,TextBox.TextSize,TextBox.Font, Vector2.new(math.huge,math.huge)).X
		
		if(x > TextBox.AbsoluteSize.X)then
			if(TextBox.TextXAlignment ~= Enum.TextXAlignment.Right and TextBox.TextWrapped == false)then
				TextBox.TextXAlignment = Enum.TextXAlignment.Right;
				--OverflowEvent:Fire();
			end
		else
			if(TextBox.TextXAlignment ~= self.TextXAlignment)then
				TextBox.TextXAlignment = self.TextXAlignment;
			end
		end
	end;
	

	local ErrorText;
	
	return {
		["ZIndex"] = function(Value)
			Wrapper.ZIndex = Value;
			TextBox.ZIndex = Value;
			PlaceholderText.ZIndex = Value;
			if(ErrorText)then
				ErrorText.ZIndex = Value;
			end
		end;
		["PlaceholderTextColor3"] = function(Value)
			PlaceholderText.TextColor3 = Value;
		end,
		["PlaceholderTextTransparency"] = function(Value)
			PlaceholderText.TextTransparency = Value;
		end,
		["PlaceholderText"] = function(Value)
			PlaceholderText.Text = Value;
			--PlaceholderText.Text = PlaceholderText.Visible == true and Value;
		end,
		["FeedbackColor3"] = function(v)
			if(ErrorText)then
				ErrorText.TextColor3 = v;
			end
		end,
		["Feedback"] = function(Value)
			if(Value ~= "" and not ErrorText)then
				ErrorText = App.new("Text",Wrapper:GetGUIRef());
				ErrorText.Position = UDim2.new(0,0,1,2);
				ErrorText.TextColor3 = self.FeedbackColor3;
				ErrorText.TextSize = 12;
				ErrorText.BackgroundTransparency = 1;
				ErrorText.TextXAlignment = Enum.TextXAlignment.Left;
				ErrorText.TextYAlignment = Enum.TextYAlignment.Top;
				ErrorText.ZIndex = self.ZIndex;
			end;
			if(Value ~= "")then
				ErrorText.Visible = true;
				ErrorText.Text = Value;
				ErrorText.Size = UDim2.new(1,0,0,12);
			else
				if(ErrorText)then
					ErrorText.Visible = false;
					ErrorText.Size = UDim2.new(1,0);
				end
			end
		end,
		["StringCapture"] = function(Value)
			if(Value ~= "")then
				TextBox.Text = (string.gsub(TextBox.Text, self.StringCapture,self._StringCaptureReplace or ""));
			end;
		end,
		["Text"] = function(Value)
			if(AllowTextUpdate)then
				AllowTextUpdate = false;
				TextBox.Text = Value;
				AllowTextUpdate = true;
			end;
		end,
		["Overflow"] = function(Value)
			if(Value)then
				if(not OverflowConnection)then		
					OverflowConnection = TextBox:GetPropertyChangedSignal("Text"):Connect(OverflowController);
				end
			else
				if(OverflowConnection)then
					OverflowConnection:Disconnect();
					OverflowConnection = nil;
					if(TextBox.TextXAlignment ~= self.TextXAlignment)then
						TextBox.TextXAlignment = self.TextXAlignment;
					end
				end
			end
		end,
		["Margin"] = function(Value)
			TextBox.Size = UDim2.new(1,-Value.X,1,-Value.Y);
			PlaceholderText.Size = TextBox.Size;
		end,
		_Components = {
			FatherComponent = Wrapper:GetGUIRef();	
			TextBox = TextBox;
		};
		_Mapping = {
			[Wrapper] = {
				"Position","AnchorPoint","Size","Roundness","StrokeThickness",
				"StrokeTransparency","StrokeColor3","BackgroundColor3","BackgroundTransparency",
				"Visible","AutomaticSize";
			};
			[PlaceholderText] = {
				"TextSize","TextScaled","TextXAlignment","TextYAlignment","AutomaticSize";
			};
			[TextBox] = {
				"TextColor3","TextTransparency","TextSize","TextScaled",
				"RichText","TextStrokeColor3","TextStrokeTransparency","TextWrapped",
				"TextXAlignment","TextYAlignment","ClipsDescendants","Font",
				"MultiLine",
				"CursorPosition",
				"ClearTextOnFocus",
				"SelectionStart",
				"ShowNativeInput",
				"TextEditable";
				"AutomaticSize";
			};
		};
	};
end;

--[=[]=]
function TextInput:CaptureFocus(...:any)
	return self:GET("TextBox"):CaptureFocus(...);
end

return TextInput
