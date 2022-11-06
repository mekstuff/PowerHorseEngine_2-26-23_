local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local TweenService = game:GetService("TweenService");

--[=[
	@class TabGroup
]=]
local TabGroup = {
	Name = "TabGroup";
	ClassName = "TabGroup";
	Size = UDim2.fromOffset(300,250);
	AutomaticSize = Enum.AutomaticSize.None;
	BackgroundColor3 = Color3.fromRGB(36, 36, 36);
	BackgroundTransparency = 1;
	HighlighterColor3 = Theme.getCurrentTheme().Text;
	HighlighterThickness = 3;
	HighlighterPadding = 3;
	--ShowTabNameWhenSelected = false;
};

-- local HighlighterThickness = 3;
-- local HighlighterPadding = 3;

TabGroup.__inherits = {"BaseGui"}

--[=[
	@param TabContent BaseGui
	@param TabName string | table -- If table, then it will be used as TabButtonProps, but you can also pass TabIcon and TabId here.
	@return Button
]=]
function TabGroup:AddTab(TabContent:Instance,TabName:string|table,TabIcon:string?,TabId:any?,TabButtonProps:table?)
	if(not TabContent)then
		return self:_GetAppModule():GetService("ErrorService").tossError("AddTab() requires the tabs content to be the first argument");
	end;

	if(typeof(TabName) == "table")then
		TabButtonProps = TabName;
		TabName = TabButtonProps.TabName;
		TabIcon = TabIcon or TabButtonProps.TabIcon;
		TabId = TabId or TabButtonProps.TabId;
		TabButtonProps.TabName = nil;
		TabButtonProps.TabIcon = nil;
		TabButtonProps.TabId = nil;
	end

	TabId = TabId or tostring(#self._dev._tabs);
	local App = self:_GetAppModule();
	local Navigator = self:GET("Navigator");
	local ContentsSection = self:GET("TabGroupContentsSection");
	local TabGroupTopSection = self:GET("TabGroupTopSection");
	local Top_List = self:GET("Top_List");
	local TabGroupTopSection_Highlighter = self:GET("TabGroupTopSection_Highlighter");
	
	if(not self._dev._tabs)then
		self._dev._tabs = {};
	end
	
	local RespectListLayout = Instance.new("Frame");
	RespectListLayout.BackgroundTransparency = 1;
	self._Components["RespectListLayout"]=RespectListLayout
	local Button = App.new("Button");
	Button.ButtonFlexSizing = false;
	Button.Size = UDim2.fromScale(1,1);
	Button.Position = UDim2.fromScale(.5,.5);
	Button.AnchorPoint = Vector2.new(.5,.5);
	Button.BackgroundTransparency = 1;
	Button.StrokeTransparency = 1;
	Button.Text = TabName or "Tab";
	Button.Icon = TabIcon or "";
	Button.Parent = RespectListLayout;
	Button.TextAdjustment = Enumeration.Adjustment.Center;
	Button.IconAdjustment = Enumeration.Adjustment.Center;
	Button.ZIndex = self.ZIndex;

	if(TabButtonProps)then
		for a,b in pairs(TabButtonProps) do
			Button[a] = b;
		end;
	end

	RespectListLayout.Parent = TabGroupTopSection:GetGUIRef();
	
	table.insert(self._dev._tabs, {
		Button = Button;
		TabContent = TabContent;
		TabName = TabName;
		TabId = TabId;
	});

	local indexValue = #self._dev._tabs - 1
	TabGroupTopSection_Highlighter.Size = UDim2.new(1/#self._dev._tabs,0,0,self.HighlighterPadding);
	Top_List.CellSize = UDim2.new(1/#self._dev._tabs,-Top_List.CellPadding.X.Offset,1,0);
	
	Button.MouseButton1Down:Connect(function()
		Navigator:NavigateTo(indexValue+1);
		
		self:GetEventListener("TabSwitched"):Fire(self._dev._tabs[indexValue+1],TabContent,Button,self._dev._currentIndex == indexValue+1 and true or false,self._dev._lastTab);
		
		self._dev._currentIndex = indexValue+1;
		self._dev._lastTab = {
			Button = Button;
			Tab = TabContent;
			TabName = TabName;
			TabId = TabId;
		}
		
	end);
	
	if(#self._dev._tabs == 1)then
		Button.MouseButton1Down:Fire();
	end
	
	Navigator:AddNavigation(TabContent,TabId);
	
	return Button;
	
end;

local function searchForInGroup(name,tabdata)
	--print(group)
end

--[=[]=]
function TabGroup:OpenTab(TabId:any)
	local found;
	for index,v in pairs(self._dev._tabs)do
		if(v.TabId == TabId)then
			self:GET("Navigator"):NavigateTo(index);
			found=true;break;
		end;
	end;
end

--//

function TabGroup:_Render(App)
	
	local TabGroupContainer = App.new("Frame", self:GetRef());
	TabGroupContainer.StrokeTransparency = 1;
	TabGroupContainer.Name = "TabGroup_Container";
	
	local TabGroupTopSection = App.new("Frame", TabGroupContainer:GetGUIRef());
	TabGroupTopSection.Size = UDim2.new(1,0,0,45);
	TabGroupTopSection.StrokeTransparency = 1;
	TabGroupTopSection.BackgroundTransparency = 1;
	TabGroupTopSection.Name = "TabGroup_Top";
	
	local TabGroupTopSection_Highlighter = App.new("Frame", TabGroupTopSection:GetGUIRef());
	TabGroupTopSection_Highlighter.Size = UDim2.new(1,0,0,self.HighlighterThickness);
	TabGroupTopSection_Highlighter.Roundness = UDim.new(0,5);
	TabGroupTopSection_Highlighter.Position = UDim2.new(0,0,1,self.HighlighterPadding);
	TabGroupTopSection_Highlighter.StrokeTransparency = 1;
	
	local Top_List = Instance.new("UIGridLayout", TabGroupTopSection:GetGUIRef());
	Top_List.SortOrder = Enum.SortOrder.LayoutOrder;
	Top_List.FillDirection = Enum.FillDirection.Horizontal;
	Top_List.CellPadding = UDim2.fromOffset(5);
	Top_List.HorizontalAlignment = Enum.HorizontalAlignment.Center;

	local TabGroupContentsSection = App.new("Frame", TabGroupContainer:GetGUIRef());
	TabGroupContentsSection.Size = UDim2.new(1,0,1,-TabGroupTopSection.Size.Y.Offset-self.HighlighterThickness-(TabGroupTopSection_Highlighter.Position.Y.Offset*2));
	TabGroupContentsSection.Position = UDim2.fromOffset(0,TabGroupTopSection.Size.Y.Offset+self.HighlighterThickness+(TabGroupTopSection_Highlighter.Position.Y.Offset*2));
	TabGroupContentsSection.StrokeTransparency = 1;
	TabGroupContentsSection.BackgroundTransparency = 1;
	TabGroupContentsSection.Name = "TabGroup_Contents";
	
	local Navigator = App.new("Navigator",TabGroupContentsSection:GetGUIRef());
	Navigator.Size = UDim2.fromScale(1,1);
	
	Navigator.Navigated:Connect(function(_,_,_,index)
		local x = (self:GET("RespectListLayout").AbsoluteSize.X+Top_List.CellPadding.X.Offset)*(index-1);
		TweenService:Create(TabGroupTopSection_Highlighter:GetGUIRef(), TweenInfo.new(Navigator.NavigationSpeed), {Position = UDim2.new(0,x,1,self.HighlighterPadding)}):Play();
	end)
	
 	self:AddEventListener("TabSwitched",true);

	return {
		["HighlighterColor3"] = function(Value)
			TabGroupTopSection_Highlighter.BackgroundColor3 = Value;
		end;
		["ZIndex"] = function(Value)
			TabGroupContainer.ZIndex = Value;
			TabGroupTopSection.ZIndex = Value;
			TabGroupTopSection_Highlighter.ZIndex = Value;
			TabGroupContentsSection.ZIndex = Value;
			Navigator.ZIndex = Value;
		end,
		_Components = {
			FatherComponent = TabGroupContainer:GetGUIRef();
			TabGroupTopSection = TabGroupTopSection;
			Top_List = Top_List;
			Navigator = Navigator;
			TabGroupContentsSection = TabGroupContentsSection;
			TabGroupTopSection_Highlighter = TabGroupTopSection_Highlighter;
			_Appender = TabGroupContentsSection:GetGUIRef();
		};
		_Mapping = {
			[TabGroupContainer] = {
				"Visible","Size","Position","AnchorPoint","BackgroundColor3","BackgroundTransparency","AutomaticSize";
			}
		};
	};
end;


return TabGroup
