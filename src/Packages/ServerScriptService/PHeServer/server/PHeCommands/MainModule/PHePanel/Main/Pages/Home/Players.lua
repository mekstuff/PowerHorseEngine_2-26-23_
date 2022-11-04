local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local State = App:Import("State");
local UserIdService = App:GetService("UserIdService");
local Theme = App:GetGlobal("Theme");
local Components = script.Parent.Parent.Parent.Components;
local PlayerComponent = require(Components.Player);
local MainModule = require(script.Parent.Parent.Parent.MainModule)

local Player = game.Players.LocalPlayer;

local fetchingPlayers=false;
local ProgressIndicator;
local Players = game:GetService("Players");

local PlayerEdit = require(script.Parent.Parent.Parent.Components.Player.PlayerEdit);

local function EditPlayer(UserId:number,clearCacheOnClose:boolean?)
	local Widget = PlayerEdit(UserId,clearCacheOnClose);
	Widget.Enabled = true;	
end

local PlayerActionMenu = {
	{
		name = "Open", id = "expand",
		func = function(_,_,UserId:number)
			EditPlayer(UserId)
		end;
	},
	{
		name = "Kick", id = "kick",
		func = function()
			
		end;
	},
	{
		name = "Ban", id = "ban", split = true,
		func = function()
			
		end;
	},
--
	{
		name = "Teleport", id = "tp",
		nested = {
			{
				name = "To Me", id = "tp/me",
				func = function(TargetName)
					MainModule.exe("Teleport "..TargetName.." "..Player.Name)
				end;
			},
			{
				name = "To Them", id = "tp/them",
				func = function(TargetName)
					MainModule.exe("Teleport "..Player.Name.." "..TargetName)
				end;
			},
			{
				name = "Server To Them", id = "tp/allthem",
				func = function()
					
				end;
			},
		},
		func = function()
			
		end;
	},
}

local idActions = {};

local function handleActionMenu(ActionMenu:any,List:table)
	for _,v in pairs(List) do
		local Action = ActionMenu:AddAction(v.name,v.id,v.icon);
		if(v.split)then
			ActionMenu:AddSplit();
		end;
		if(v.func)then
			assert(v.id, "No id given for action, no func can be given aswell."..v.name);
			idActions[v.id] = v.func;
		end
		if(v.nested)then
			handleActionMenu(Action:AddActionMenu(),v.nested);
		end
	end
end;

local function PlayerEditComponentHandler(UserId:number,Container:Instance)
	local newPlayer:Frame,_,ActionButton:Instance,name:string = PlayerComponent(UserId);
	newPlayer.Name = name;
	newPlayer.Parent = Container:GetGUIRef();
	local ActionMenu = App.new("ActionMenu", script.Parent.Parent.Parent.Components.content);
	handleActionMenu(ActionMenu,PlayerActionMenu,UserId);

	ActionMenu.ActionTriggered:Connect(function(Action)
		local func = idActions[Action.ID];
		if(func)then
			func(name,Action,UserId);
		end;
	end)
		
	ActionButton.MouseButton2Down:Connect(function()
		ActionMenu:Show();	
	end);
	
	ActionButton.MouseButton1Down:Connect(function()
		EditPlayer(UserId);
	end);
	return newPlayer;
end;

local function getPlayersForTab(Canvas,Container)
	if(not fetchingPlayers)then
		fetchingPlayers=true;
		if(not ProgressIndicator)then
			ProgressIndicator = App.new("ProgressIndicator",Canvas);
			ProgressIndicator.Color = Theme.useTheme("Text");
		end;
		
		ProgressIndicator.Enabled = true;
		
		for _,v in pairs(Container:GetChildren())do
			if(v:IsA("Frame"))then
				if(not Players:FindFirstChild(v.Name))then
					v:Destroy();
				end
			end
		end;
		
		for _,v in pairs(Players:GetPlayers())do
			if(not Container:FindFirstChild(v.Name))then
				PlayerEditComponentHandler(v.UserId,Container);
			end
		end;
		
		for i,v in pairs(Container:GetChildren())do
			if(v:IsA("Frame"))then
				local c=i%2 == 1 and Color3.fromRGB(34, 34, 34) or Color3.fromRGB(53, 53, 53);
				v:FindFirstChild("PlayerFrame"):SetAttribute("BackgroundColor3", c); 
			end;	
		end;
		
		ProgressIndicator.Enabled = false;
		fetchingPlayers=false;
	end;
end;

return {
	Name = "";
	Icon = "ico-mdi@action/supervisor_account";
	Func = function(TabGroup)
		local Frame = App.new("Frame");
	
		local PlayersContainer = App.new("ScrollingFrame",Frame);
		PlayersContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		PlayersContainer.Size = UDim2.fromScale(1,1);
		PlayersContainer.StrokeTransparency = 1;
		PlayersContainer.BackgroundTransparency = 1;

		local MainWidget = MainModule.CreateWidget();

		local SearchPlayerFilter,setSearchPlayerFilter = State("");
		local SearchPlayerState,setSearchPlayerState = State(""); --> we use State so we can use useEffect
		local SearchPlayerNoResultsVisible,setSearchPlayerNoResultsVisible = State(false);

		local NoResultsText = App.New "$Text" {
			Parent = Frame;
			Size = UDim2.new(1,0,1,0);
			TextWrapped = true;
			Visible = SearchPlayerNoResultsVisible;
		};

		SearchPlayerNoResultsVisible:useEffect(function()
			if(SearchPlayerNoResultsVisible())then
				local listenUpdateEffect = SearchPlayerFilter:useEffect(function()
					NoResultsText.Text = "No Results For \""..SearchPlayerFilter().."\".";
				end);
				return function ()
					listenUpdateEffect:Destroy();
				end
			end
		end)

		local SearchPlayersFrame = App.New "$Frame" {
			Parent = MainWidget:GET("ActionButtons");
			SupportsRBXUIBase = true;
			Size = UDim2.new(0,200,1,0);
			Visible = false;
			BackgroundTransparency = .8;
			BackgroundColor3 = Color3.fromRGB(0,0,0);
			App.New "$TextInput" {
				Name = "Filter";
				Size = UDim2.new(1,-30,1,0);
				PlaceholderText = "Search Players...";
				ClearTextOnFocus = false;
				[App.OnWhiplashEvent "FocusLost"] = function(self,ep:boolean)
					if(ep)then
						setSearchPlayerState(self.Text);
					end
				end;
				[App.OnWhiplashEvent "TextChanged"] = function(self)
					setSearchPlayerFilter(self.Text);
				end;
			},
			App.New "$Button" {
				ButtonFlexSizing = false;
				Size = UDim2.new(0,30,1,0);
				AnchorPoint = Vector2.new(1);
				Position = UDim2.new(1);
				Text = "";
				Icon = "ico-mdi@action/search";
				BackgroundTransparency = 1;
			}
		};

		SearchPlayerFilter:useEffect(function()
			local foundSomeone = false;
			local filtering = true;
			task.spawn(function()
				for _,v in pairs(PlayersContainer:GetChildren())do
					if(not filtering)then break;end;
					if(v:IsA("Frame"))then
						if(v.Name:lower():match(SearchPlayerFilter():lower()))then
							foundSomeone = true;
							v.Visible = true;
						else
							v.Visible = false;
						end;
					end;
				end;
				if(filtering and not foundSomeone)then
					--> Trigger search for external player
					setSearchPlayerState(SearchPlayerFilter());
				else
					setSearchPlayerNoResultsVisible(false);
				end
			end);
			return function ()
				filtering = false;
			end
		end)

		Instance.new("UIListLayout",PlayersContainer:GetGUIRef());
		
		TabGroup.TabSwitched:Connect(function(tabData)
			if(tabData.TabId == script.Name)then
				getPlayersForTab(Frame,PlayersContainer);
				SearchPlayersFrame.Visible = true;
			else
				SearchPlayersFrame.Visible = false;
			end
		end);

		SearchPlayerState:useEffect(function()
			local Searching = true;
			local EditComponent;
			setSearchPlayerNoResultsVisible(false);
			local UserIdSearch = UserIdService:GetUserId(SearchPlayerState()):Then(function(res)
				for _,v in pairs(PlayersContainer:GetChildren()) do
					if(not Searching)then break;end;
					if(v.Name == SearchPlayerState())then
						break;
					end;
				end
				EditComponent = PlayerEditComponentHandler(res,PlayersContainer)
			end):Catch(function()
				setSearchPlayerNoResultsVisible(true);
			end):Cancel(function()
				return --> Place Holder so we don't Catch Cancels.
			end)
			return function()
				Searching = false;
				UserIdSearch:Destroy();
				if(EditComponent)then
					EditComponent:Destroy();
				end
			end
		end);
		
		return Frame;
	end,
}