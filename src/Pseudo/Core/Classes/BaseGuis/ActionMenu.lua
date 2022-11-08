local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local Vanilla_Core = require(script.Parent.Parent.Parent.Vanilla);
local UIS = game:GetService("UserInputService")
local IsClient = game:GetService("RunService"):IsClient();

--[=[
@class ActionMenu
]=]
local ActionMenu = {
	Name = "ActionMenu";
	ClassName = "ActionMenu";
	AutomaticHide =  Enumeration.ActionMenuAutomaticHide.All;
	_InitialAdornee = nil;
	Showing = false;
	TextSize = 14;
};
--[=[
@prop AutomaticHide Enumeration.ActionMenuAutomaticHide
@within ActionMenu
]=]
--[=[
@prop Showing Boolean
@within ActionMenu
]=]
--[=[
@prop TextSize Number
@within ActionMenu
]=]
--[=[
Should only be used by core scripts, changing may break action menu
@prop _InitialAdornee Instance
@private
@within ActionMenu
]=]
ActionMenu.__inherits = {}

--//
local function hideAll(self)
	local Tree = self._dev.__ActionTree;local AutomaticHide = self.AutomaticHide;
	for _,v in pairs(Tree) do
		if(v._dev._Showing)then
			v:Hide();
		end
	end;
	
end;

--[=[
	Calls :Show and waits for ActionTriggered event to be fired. Will return nil if the .Showing property is set to false before the event is fired.
	@return ActionMenuAction?
	@yields
]=]
function ActionMenu:ShowAsync(...:any)
	local App = self:_GetAppModule();
	local SignalProvider = App:GetProvider("SignalProvider");
	local ShowAsyncRequest = SignalProvider.new(self.Name.."-ShowAsync");
	local AlreadyResolved = false;
	self:Show(...);
	local function DisconnectEvents()
		if(ShowAsyncRequest._dev.ActionTriggeredConnection)then
			ShowAsyncRequest._dev.ActionTriggeredConnection:Disconnect();
			ShowAsyncRequest._dev.ActionTriggeredConnection = nil;	
		end
		if(ShowAsyncRequest._dev.ShowingChangedConnection)then
			ShowAsyncRequest._dev.ShowingChangedConnection:Disconnect();
			ShowAsyncRequest._dev.ShowingChangedConnection = nil;	
		end
	end;
	ShowAsyncRequest._dev.ActionTriggeredConnection = self:GetEventListener("ActionTriggered"):Connect(function(...)
		if(not AlreadyResolved and ShowAsyncRequest._dev)then
			AlreadyResolved = true;
			DisconnectEvents();
			ShowAsyncRequest:Fire(...);
			ShowAsyncRequest:Destroy();
		end
	end);
	ShowAsyncRequest._dev.ShowingChangedConnection = self:GetPropertyChangedSignal("Showing"):Connect(function()
		if(not AlreadyResolved and ShowAsyncRequest._dev and not self.Showing)then
			AlreadyResolved = true;
			DisconnectEvents();
			ShowAsyncRequest:Fire();
			ShowAsyncRequest:Destroy();

		end
	end)
	return ShowAsyncRequest:Wait();
end;
--[=[]=]
function ActionMenu:Show(ignoreFocusLost:boolean?,CustomAdornee:any?)
	if(self._dev._Showing)then
		self:Hide();
		task.wait();
	end;
	local App = self:_GetAppModule()
	local UserKeybindService = App:GetService("UserKeybindService");
	local MainActionToolTip = self:GET("MainActionToolTip");
	
	if(CustomAdornee and CustomAdornee ~= MainActionToolTip.Adornee)then
		MainActionToolTip.StaticXAdjustment = Enumeration.Adjustment.Right;
		MainActionToolTip.StaticYAdjustment = Enumeration.Adjustment.Flex;
		MainActionToolTip.PositionBehaviour = Enumeration.PositionBehaviour.Static;
		MainActionToolTip.Adornee = CustomAdornee
		MainActionToolTip:_UpdateAdornee();
	end;
	
	if(not self._dev.EnterEventInitiated)then
		if(self._dev.__TreeContents)then
			for _,v in pairs(self._dev.__TreeContents)do
				if(not v._EnterEvent)then
					v._EnterEventA = v._Container.MouseEnter:Connect(function()
						v._Container.BackgroundTransparency = .4;
					end);
					v._EnterEventB = v._Container.MouseLeave:Connect(function()
						v._Container.BackgroundTransparency = 1;
					end)
				end
			end
		end
	end
	
	MainActionToolTip:_Show();
	self.Showing = true;
	self._dev._Showing = true;

	if(self._dev.__keybinds)then
		for _,v in pairs(self._dev.__keybinds)do
			if(not v.connection)then
				local ActionButton = v.action.ActionButton
				local connection = v.eventconnector:Connect(function()
					if(self._dev._Showing)then
						ActionButton:GetEventListener("MouseButton1Down"):Fire();
					end;
				end)
				v.connection = connection;
			end;
		end
	end;
	
	if(not ignoreFocusLost)then
		local ev;
		task.wait(.4);
		if(not self._dev._Showing)then return end;
		ev = UIS.InputBegan:Connect(function(inputObject)
			--if(not gp)then return;end;
			local UIT = inputObject.UserInputType;
			local UITS = Enum.UserInputType;
			if(UIT == UITS.MouseButton1 or UIT == UITS.MouseButton2)then
				game:GetService("RunService").RenderStepped:Wait();
				self:Hide();
				if(ev)then
					ev:Disconnect();ev=nil;
				end;
			end
		end)
	end
end;
--[=[
]=]
function ActionMenu:Hide()
	local MainActionToolTip = self:GET("MainActionToolTip");
	MainActionToolTip:_Hide();
	
	if(self._dev.__ActionTree)then
		hideAll(self);
	end;
	self.Showing = false;
	self._dev._Showing = false;
	if(self._dev.__keybinds)then
		for index,v in pairs(self._dev.__keybinds)do
			if(v.connection)then v.connection:Disconnect();v.connection=nil;end;
		end
	end;
	task.delay(5,function()
		if(not self)then return end;
		if(self._dev.EnterEventInitiated and not self._dev._Showing)then
			if(self._dev.__TreeContents)then
				for _,v in pairs(self._dev.__TreeContents)do
					if(v.EnterEventA)then v.EnterEventA:Disconnect();v.EnterEventA=nil;end;
					if(v.EnterEventB)then v.EnterEventB:Disconnect();v.EnterEventB=nil;end;
				end
			end;
		end
	end)
end;


--[=[
@class ActionMenuAction
]=]
local ActionMenuAction = {
	Name = "ActionMenuAction";
	ClassName = "ActionMenuAction";
	ID = "";
	Text = "";
	Icon = "";
};
function ActionMenuAction:_Render()
	self._ActionButton = self._dev.args;
	self:AddEventListener("OnAction",true);
	return {
		["Text"] = function(v)
			self._ActionButton.Text = v;
		end;
		["Icon"] = function(v)
			self._ActionButton.Icon = v;
		end;
	};
end
--[=[]=]
function ActionMenuAction:UpdateText(Text:string)
	self.Text = Text;
end;
--[=[]=]
function ActionMenuAction:UpdateIcon(Icon:string)
	self.Icon = Icon;
end;
--[=[
@return ActionMenu
]=]
function ActionMenuAction:AddActionMenu()
	local App = self:_GetAppModule();
	local State = App:Import("State");
	local newActionMenu = App.new("ActionMenu",nil,{_InitialAdornee = self._Container})
	newActionMenu.Parent = self._Container;
	newActionMenu.AutomaticHide = Enumeration.ActionMenuAutomaticHide.None;

	self._ParentExpandIcon.Visible = true;

	local IsHoveringActionButton,setIsHoveringActionButton = State(false);
	local IsHoveringContentFrame,setIsHoveringContentFrame = State(false);

	table.insert(self._dev,IsHoveringActionButton);
	table.insert(self._dev,IsHoveringContentFrame);
	
	newActionMenu:GET("ContentFrame").MouseEnter:Connect(function()
		if(not IsHoveringContentFrame())then
			setIsHoveringContentFrame(true);
		end
	end)
	newActionMenu:GET("ContentFrame").MouseLeave:Connect(function()
		if(IsHoveringContentFrame())then
			setIsHoveringContentFrame(false);
		end
	end)

	self._ActionButton.MouseEnter:Connect(function()
		if(not IsHoveringActionButton())then
			setIsHoveringActionButton(true);
		end
	end)
	self._ActionButton.MouseLeave:Connect(function()
		if(IsHoveringActionButton())then
			setIsHoveringActionButton(false);
		end
	end)

	IsHoveringActionButton:useEffect(function()
		if(IsHoveringActionButton() or IsHoveringContentFrame())then
			if(not newActionMenu.Showing)then
				newActionMenu:Show(nil,self._ActionButton);
			end
		else
			if(newActionMenu.Showing)then
				newActionMenu:Hide();
			end
		end
	end, {IsHoveringContentFrame});

	newActionMenu.ActionTriggered:Connect(function(...)
		self._Menu.ActionTriggered:Fire(...)
	end)
	
	return newActionMenu;
end;
--[=[]=]
function ActionMenu:AddSplit()
	local ContentFrame = self:GET("ContentFrame");
	local UIGrid = self:GET("UIGrid","RBX");

	local Line = Instance.new("Frame", ContentFrame);
	Line.BackgroundTransparency = .75;
	Line.Size = UDim2.new(1,0,0,1);
	Line.BorderSizePixel = 0;

	ContentFrame.Size = UDim2.fromOffset(UIGrid.AbsoluteContentSize.X,UIGrid.AbsoluteContentSize.Y);

end;
--[=[]=]
function ActionMenu:AddPadding(y:number)
	local ContentFrame = self:GET("ContentFrame");
	local UIGrid = self:GET("UIGrid");

	local Line = Instance.new("Frame", ContentFrame);
	Line.BackgroundTransparency = 1;
	Line.Size = UDim2.new(1,0,0,y or 5);
	Line.BorderSizePixel = 0;

	ContentFrame.Size = UDim2.fromOffset(UIGrid.AbsoluteContentSize.X,UIGrid.AbsoluteContentSize.Y);

end
--[=[]=]
function ActionMenu:AddHeader(Header:string)
	local App = self:_GetAppModule()
	local ContentFrame = self:GET("ContentFrame");
	local UIGrid = self:GET("UIGrid");

	local Text = App.new("Text")
	Text.Text = Header or "Header";
	Text.Size = UDim2.new(1,0,0,25);
		--TextSize = 20;
	Text.TextTransparency = .4;
	Text.TextTruncate = Enum.TextTruncate.AtEnd;
	Text.Parent = ContentFrame;
	

	ContentFrame.Size = UDim2.fromOffset(UIGrid.AbsoluteContentSize.X,UIGrid.AbsoluteContentSize.Y);

end
--[=[
@return ActionMenuAction
]=]
function ActionMenu:AddAction(ActionName:string,id:string,ActionIcon:string,...:any)
	--if(not ySize)then ySize = self.ContentYSize;end;
	local App = self:_GetAppModule()

	local UserKeybindService = App:GetService("UserKeybindService");

	local ContentFrame = self:GET("ContentFrame");
	local UIGrid = self:GET("UIGrid");

	local Container = Instance.new("Frame");
	Container.BackgroundTransparency = 1;

	local Fit = 10;

	local ActionRightImage = Instance.new("ImageLabel");
	ActionRightImage.Parent = Container;
	ActionRightImage.Size = UDim2.fromOffset(Fit,Fit);
	ActionRightImage.Position = UDim2.new(1,-5,.5,0);
	ActionRightImage.AnchorPoint = Vector2.new(1,.5);
	ActionRightImage.ScaleType = Enum.ScaleType.Fit;
	ActionRightImage.Image = "rbxasset://textures/DeveloperFramework/button_arrow_right.png";
	ActionRightImage.BackgroundTransparency = 1;
	ActionRightImage.Visible = false;

	local ActionButton = App.new("Button");
	ActionButton.ButtonFlexSizing = false;
	ActionButton.Name = "ActionButton";

	ActionButton.Roundness = UDim.new(0);
	ActionButton.BackgroundTransparency = 1;
	ActionButton.StrokeTransparency = 1;
	ActionButton.ActiveBehaviour = Enumeration.ActiveBehaviour.None;
	ActionButton.TextSize = self.TextSize;
	ActionButton.RippleStyle = Enumeration.RippleStyle.None;
	ActionButton.Parent = Container;
	
	local Action = App.Create(ActionMenuAction,nil,ActionButton);
	Action.Text = ActionName;
	Action.Icon = ActionIcon or "";

	local x;

	if(ContentFrame.AbsoluteSize.X < ActionButton:GetAbsoluteSize().X)then
		x = ActionButton:GetAbsoluteSize().X+Fit+10;

	else 
		x = ContentFrame.AbsoluteSize.X;
	end;

	local binds = {...};
	local bindfit=0;
	if(#binds > 0)then

		if(not self._dev.__bindsinplace)then
			bindfit = 170;

			self._dev.__bindsinplace=true;
			self._dev.__keybinds = {}; 
		end

		local KeybindText = App.new("Text");
		
		KeybindText.Text = UserKeybindService:ConvertBindsToString(...);
		KeybindText.Position = UDim2.new(1,-20,.5,0);
		KeybindText.AnchorPoint = Vector2.new(1,.5);
		KeybindText.TextXAlignment = Enum.TextXAlignment.Right;
		KeybindText.TextTransparency = .6;
		KeybindText.TextSize = 15;
		KeybindText.BackgroundTransparency = 1;

		KeybindText.Parent = Container;

		local EventConnector,_,BindableEvent = UserKeybindService:BindKeybind(...);
		local connection =  EventConnector:Connect(function()
			if(self._dev._Showing)then
				ActionButton:GetEventListener("MouseButton1Down"):Fire();
			end
		end)
		table.insert(self._dev.__keybinds, {
			action = Action,
			connection = connection,
			eventconnector = EventConnector;
			keys = ...;
			--event = event;
		});

	end

	Container.Parent = ContentFrame;
	Container.Size = UDim2.new(1,0,0,30) -- UDim2.new(1,0,0,ActionButton:GetAbsoluteSize().Y);
	ContentFrame.Size = UDim2.fromOffset(x+bindfit,UIGrid.AbsoluteContentSize.Y);
	ActionButton.Size = UDim2.fromScale(1,1);

	Action._ParentExpandIcon = ActionRightImage;
	Action._Container = Container;
	Action._Menu = self;

	id = id or tostring(math.random(1,500));

	Action.ID = id;

	if(not self._dev.__TreeContents)then
		self._dev.__TreeContents = {};
	end;

	self._dev.__TreeContents[id] = Action;

	ActionButton:AddEventListener("MouseButton1Down"):Connect(function()
		Action:GetEventListener("OnAction"):Fire();
		self:GetEventListener("ActionTriggered"):Fire(Action);
	end);

	return Action;

end;
--[=[
]=]
function ActionMenu:UpdateAllIcons(Icon:string, IgnoreList:table, Inverse:boolean)
	for _,v in pairs(self._dev.__TreeContents)do
		if(IgnoreList)then

			if( (Inverse and table.find(IgnoreList,v.ID)) or not Inverse and not(table.find(IgnoreList,v.ID)) )then
				v:UpdateIcon(Icon);
			end
		else v:UpdateIcon(Icon);
		end;
	end;
end;

--[=[
]=]
function ActionMenu:GetActions()return self._dev.__TreeContents;end;
--[=[
]=]
function ActionMenu:GetAction(Action:string)
	return self._dev.__TreeContents[Action]
end;

--[=[
]=]
function ActionMenu:AddToTree(...:any)
	local ToAdd = {...};
	if(not self._dev.__ActionTree)then self._dev.__ActionTree = {};end;

	for _,x in pairs(ToAdd)do
		table.insert(self._dev.__ActionTree, x);
		x.ActionTriggered:Connect(function(...)
			if(self.AutomaticHide == Enumeration.ActionMenuAutomaticHide.None)then return end;
			self:Hide();
			self:GetEventListener("ActionTriggered"):Fire(...);
		end);
	end;

end


function ActionMenu:_Render(App)
	
	
	
	local MainActionToolTip = App.new("ToolTip")
	MainActionToolTip.RevealOnMouseEnter = false;
	MainActionToolTip.IdleTimeRequired = 0;
	MainActionToolTip.PositionBehaviour = Enumeration.PositionBehaviour.Static;
	MainActionToolTip.StaticXAdjustment = Enumeration.Adjustment.Right;
	MainActionToolTip.StaticYAdjustment = Enumeration.Adjustment.Bottom;

	--MainActionToolTip.Parent = Vanilla_Core.Mouse;
	--MainActionToolTip.Parent = self._InitialAdornee or self:GetRef();
	MainActionToolTip.Parent = self._InitialAdornee or self:GetRef();
	MainActionToolTip.Adornee = self._InitialAdornee or Vanilla_Core.Mouse;
	MainActionToolTip:_UpdateAdornee();
	MainActionToolTip.ContentPadding = Vector2.new(0,5);
	MainActionToolTip.BackgroundColor3 = Color3.fromRGB(53, 53, 53);
	
	--[=[
		@prop ActionTriggered PHeSignal
		@within ActionMenu
	]=]
	self:AddEventListener("ActionTriggered",true)
	
	if(self._InitialAdornee)then
		MainActionToolTip.StaticXAdjustment = Enumeration.Adjustment.Right;
		MainActionToolTip.StaticYAdjustment = Enumeration.Adjustment.Flex;
	end
	--MainActionToolTip.Roundness = UDim.new(0);

	local Frame = MainActionToolTip:GET("Frame");

	--Frame.StrokeThickness = 1.5;
	Frame.StrokeColor3 = Color3.fromRGB(0);
	Frame.StrokeTransparency = 0;
	Frame.StrokeThickness = 1.5;

	MainActionToolTip:_Hide();

	local ContentFrame = Instance.new("Frame", MainActionToolTip:GET("_Appender"));
	ContentFrame.Size = UDim2.fromOffset(70,35);
	ContentFrame.BackgroundTransparency = 1;

	local UIGrid = Instance.new("UIListLayout", ContentFrame);
	UIGrid.SortOrder = Enum.SortOrder.LayoutOrder;
	
	
	return {
		_Components = {
			ContentFrame = ContentFrame;
			UIGrid = UIGrid;
			MainActionToolTip = MainActionToolTip;
		};
		_Mapping = {};
	};
end;


return ActionMenu
