local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local SuggestiveTextInput = {
	Name = "SuggestiveTextInput";
	ClassName = "SuggestiveTextInput";
	Needle = "",
	UseCurrentWordAsNeedle = true;
	SuggestionAdornee = "**Instance";
	SuggestionList = {};
};
SuggestiveTextInput.__inherits = {"BaseGui","GUI","Text","TextInput"};


local unsupportedSuggestionID = "suggestion-id-unique"

function SuggestiveTextInput:_createSuggestionHeader(SuggestionHeader,SuggestionBody,SuggestionIcon)
	SuggestionHeader = SuggestionHeader or "";
	SuggestionBody = SuggestionBody or "";
	SuggestionIcon = SuggestionIcon or "";
	
	local App = self:_GetAppModule();
	
	local Toast = App.new("Toast");
	Toast:GET("Gradient").Enabled = false;
	Toast.BackgroundTransparency = 1;
	Toast.BackgroundColor3 = Color3.fromRGB(60, 105, 255);
	Toast.Header = SuggestionHeader;Toast.Body = SuggestionBody;Toast.CanvasImage = SuggestionIcon;
	
	
	return Toast;	
end;

--//
function SuggestiveTextInput:HighlightSuggestion(SuggestionID)
	
	if(self._dev.activeSuggestionID)then
		local targetPrev = self._dev.suggestions[self._dev.activeSuggestionID];
		if(targetPrev)then
			targetPrev.Button.BackgroundTransparency = 1;
		end;
		self._dev.activeSuggestionID = nil;
	end;
	
	local App = self:_GetAppModule();
	local target = self._dev.suggestions[SuggestionID];
	if(not target)then 
		return 
		--App:GetService("ErrorService").tossWarn(string.format("Tried to highlight suggestion with id \"%s\" but \"%s\" is not a existing suggestion id.",SuggestionID,SuggestionID))
	end;
	
	if(self._dev.activeSuggestionID == SuggestionID)then return end;
	
	local SuggestionHeader = self:GET("SuggestionHeader");
	local targetData = target.SuggestionData;
	local targetButton = target.Button;
	
	targetButton.BackgroundTransparency = 0;
	
	SuggestionHeader.Header = targetData.Header;
	SuggestionHeader.Body = targetData.Body;
	SuggestionHeader.IconImage = targetButton.Icon;
	
	self._dev.activeSuggestionID = SuggestionID;
	
end;
--//
function SuggestiveTextInput:GetSuggestionsFrom(String,LowerCharacters,Display)
	local Suggestions = {};
	String = LowerCharacters and String:lower() or String;
	for id,x in pairs(self._dev.suggestions) do
		for _,v in pairs(x.Haystack) do
			local char = LowerCharacters and v:lower() or v;
			
			local match = char:match(String);
	
			if(match)then
				Suggestions[id]=x;
				
				if(Display)then
					x.Button.Visible = true;
				end
			else
				if(Display)then
					x.Button.Visible = false;
				end
			end
		end
	end;
	return Suggestions;
end;
--//
function SuggestiveTextInput:RemoveSuggestion(SuggestionID)
	local suggestion = self._dev.suggestions[SuggestionID];
	if(suggestion)then
		suggestion.SuggestionData = nil;
		suggestion.Button:Destroy();
		self._dev.suggestions[SuggestionID]=nil;
	end;
end
--//
function SuggestiveTextInput:AddSuggestion(Suggestion,SuggestionID,SuggestionHaystack)
	local App = self:_GetAppModule();
	local ErrorService = App:GetService("ErrorService");
	
	ErrorService.assert(Suggestion and typeof(Suggestion) =="table", string.format("Table expected for suggestion, got %s",tostring(Suggestion)));
	ErrorService.assert(Suggestion.Header and typeof(Suggestion.Header) =="string", string.format("String expected for Suggest {Header}, got %s",tostring(Suggestion.Header)))
	
	Suggestion.Body = Suggestion.Body or "";
	Suggestion.Icon = Suggestion.Icon or "";
	Suggestion.Text = Suggestion.Text or Suggestion.Header;
	
	SuggestionID = SuggestionID or tostring(math.random());
	SuggestionHaystack = SuggestionHaystack or {Suggestion.Text};

	if(self._dev.suggestions[SuggestionID])then 
		return ErrorService.tossError(string.format("Tried to create suggestion with id \"%s\" but \"%s\" is already is suggestion id. each suggestion id must be unique",SuggestionID,SuggestionID))
	end;
	local Button = App.new("Button");
	Button.ButtonFlexSizing = false;
	Button.SupportsRBXUIBase = true;
	Button.Text = Suggestion.Text;
	Button.Icon = Suggestion.Icon;
	Button.Roundness = UDim.new(0);
	Button.BackgroundTransparency = 1;
	Button._dev.SuggestiveTextInput_SuggestionUID = SuggestionID;
	
	Button.MouseEnter:Connect(function()
		self:GetEventListener("SuggestionHovered"):Fire(SuggestionID)
	end);
	Button.MouseButton1Down:Connect(function()
		self:GetEventListener("SuggestionClicked"):Fire(SuggestionID)
	end)
	
	self._dev.suggestions[SuggestionID] = {
		Button = Button;
		SuggestionData = Suggestion;
		Haystack = SuggestionHaystack;
	};
	
	Button.Parent = self:GET("SuggestionsScroller");
	
	return Button,SuggestionID;
end;
--//
function SuggestiveTextInput:UpdateVisualSuggestions(String,LowerCharacters)
	return (self:GetSuggestionsFrom(String, LowerCharacters, true))
end
--//
function SuggestiveTextInput:RefreshSuggestionDisplay()
	local SuggestionList = self.SuggestionList;
	local activeIDs = {};
	
	for _,v in pairs(SuggestionList) do
		if(self._dev.suggestions[v.Id]) then
			-->Already created
			activeIDs[v.id]=true;
		else
			local btn,suggestionID = self:AddSuggestion({Header = v.Header,Body = v.Body},v.Id,v.Haystack);
			activeIDs[suggestionID]=true;
		end;
	end;
	for id,_ in pairs(self._dev.suggestions) do
		if(not activeIDs[id])then
			self:RemoveSuggestion(id)
		end
	end;
	activeIDs=nil;
	self:UpdateVisualSuggestions(self.Needle,true);
end
--//
function SuggestiveTextInput:_Render(App)
	
	--local Container = App.new("Frame",self:GetRef())
	--Container.BackgroundTransparency = 1;
	
	self:AddEventListener("SuggestionHovered",true);
	local SuggestionClicked = self:AddEventListener("SuggestionClicked",true);
	
	local TextInput = App.new("TextInput",self:GetRef());
	
	self:AddEventListener("FocusLost",true,TextInput.FocusLost);
	
	local textChanged = self:AddEventListener("TextChanged",true);
	TextInput.TextChanged:Connect(function()
		self.Text = TextInput.Text;
		textChanged:Fire();
	end);
	
	TextInput:GetPropertyChangedSignal("CurrentWord"):Connect(function()
		self.CurrentWord = TextInput.CurrentWord;
	end);TextInput:GetPropertyChangedSignal("CurrentWordStart"):Connect(function()
		self.CurrentWordStart = TextInput.CurrentWordStart;
	end);TextInput:GetPropertyChangedSignal("CurrentWordEnd"):Connect(function()
		self.CurrentWordEnd = TextInput.CurrentWordEnd;
	end);
	
	local AutoCompleteToolTip = App.new("ToolTip");
	AutoCompleteToolTip.IdleTimeRequired = 0;
	AutoCompleteToolTip.RevealOnMouseEnter = false;
	AutoCompleteToolTip.PositionBehaviour = Enumeration.PositionBehaviour.Static;
	AutoCompleteToolTip.StaticXAdjustment = Enumeration.Adjustment.Flex;
	AutoCompleteToolTip.Parent = self:GetRef();
	AutoCompleteToolTip._Adornee = TextInput;
	
	local UIListLayoutTopLevel = Instance.new("UIListLayout",AutoCompleteToolTip:GET("_Appender"));
	UIListLayoutTopLevel.SortOrder = Enum.SortOrder.LayoutOrder;
	UIListLayoutTopLevel.Padding = UDim.new(0,5);
	
	local SuggestionHeaderToast = self:_createSuggestionHeader("Suggestion?","Start typing to get suggestions!");
	SuggestionHeaderToast.Name = "B"
	SuggestionHeaderToast.Parent = AutoCompleteToolTip;
	
	
	local SuggestionsScroller = App.new("ScrollingFrame")
	SuggestionsScroller.Size = UDim2.new(0,200,0,60);
	SuggestionsScroller.Name=  "B";
	SuggestionsScroller.BackgroundTransparency = 1;
	SuggestionsScroller.Parent = AutoCompleteToolTip;
	
	SuggestionHeaderToast.SupportsRBXUIBase = true;
	SuggestionsScroller.SupportsRBXUIBase = true;
	
	local UIGrid = Instance.new("UIGridLayout",SuggestionsScroller:GetGUIRef());
	UIGrid.CellSize = UDim2.new(1,0,0,25);
	UIGrid.CellPadding = UDim2.new(0,0,0,2);
	
	
	AutoCompleteToolTip:_Show();
	
	self._dev.suggestions = {};
	self._dev.activeSuggestionID = nil;
	
	SuggestionClicked:Connect(function(SuggestionId)
		local suggestion = self._dev.suggestions[SuggestionId];
		if(suggestion)then
			TextInput.Text = TextInput.Text..suggestion.SuggestionData.Text;
			self:HighlightSuggestion();
		end 
	end);
	
	TextInput.FocusLost:Connect(function(ep)
		if(ep)then
			local active = self._dev.activeSuggestionID;
			if(active)then
				SuggestionClicked:Fire(active)
			end
		end
	end);
	
	local RenderSteppedConnection;
	local function disconnectRenderSteppedConnect()
		if(RenderSteppedConnection)then
			RenderSteppedConnection:Disconnect();RenderSteppedConnection=nil;
		end
	end;
	local lastKnwonTableTotal = 0;
	local function onRenderStepped()
		if(#self.SuggestionList ~= lastKnwonTableTotal)then
			lastKnwonTableTotal = #self.SuggestionList;
			self:RefreshSuggestionDisplay();
		end;
	end;
	
	local function autoupdateNeedle(to)
		self.Needle = to;	
	end;
	
	local autoupdateNeedleConnection;
	
	local needleConnection;
	return {
		["Needle"] = function(v)
			self:UpdateVisualSuggestions(v,true);
		end,
		--["Needle"] = function(v)
		--	if(v)then
		--		if(not needleConnection)then
		--			needleConnection = 
		--		end
		--	else
		--		if(needleConnection)then
		--			needleConnection:Disconnect();
		--			needleConnection = nil;
		--		end
		--	end
		--end,
		["UseCurrentWordAsNeedle"] = function(v)
			if(v)then
				if(not autoupdateNeedleConnection)then
					autoupdateNeedleConnection = self:GetPropertyChangedSignal("CurrentWord"):Connect(function()
						autoupdateNeedle(self.CurrentWord)
					end);
				end
			else
				if(autoupdateNeedleConnection)then
					autoupdateNeedleConnection:Disconnect();
					autoupdateNeedleConnection = nil;
				end
			end
		end,
		["SuggestionList"] = function(v)
			if(#v <= 0)then
				disconnectRenderSteppedConnect();
			else
				if(not RenderSteppedConnection)then
					lastKnwonTableTotal = #v;
					game:GetService("RunService").RenderStepped:Connect(onRenderStepped);
				end
			end;
			self:RefreshSuggestionDisplay();
		end,
		_Components = {
			FatherComponent = TextInput:GetGUIRef();	
			SuggestionsScroller = SuggestionsScroller;
			SuggestionHeader = SuggestionHeaderToast;
			--AutoCompleteToolTip = AutoCompleteToolTip;
		};
		_Mapping = {
			[TextInput] = {
				"TextColor3","TextTransparency","TextSize","TextScaled",
				"RichText","TextStrokeColor3","TextStrokeTransparency","TextWrapped",
				"Font",
				"MultiLine",
				"CursorPosition",
				"ClearTextOnFocus",
				"SelectionStart",
				"ShowNativeInput",
				"TextEditable","TextSize","TextScaled","TextXAlignment","TextYAlignment","PlaceholderText","PlaceholderTextColor3",
				--//
				"Roundness","StrokeThickness",
				"StrokeTransparency","StrokeColor3","BackgroundColor3","BackgroundTransparency",
				"Size","Position","AnchorPoint","Visible"
			}
		};
	};
end;


return SuggestiveTextInput
