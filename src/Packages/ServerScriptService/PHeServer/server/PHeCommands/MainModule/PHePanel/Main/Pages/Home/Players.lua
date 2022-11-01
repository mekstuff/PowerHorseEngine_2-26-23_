local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Components = script.Parent.Parent.Parent.Components;
local CommandOutput = require(Components.CommandOutput);
local PlayerComponent = require(Components.Player);
local MainModule = require(script.Parent.Parent.Parent.MainModule)
local pColor = Color3.fromRGB(85, 170, 255);

local Player = game.Players.LocalPlayer;

local fetchingPlayers=false;
local ProgressIndicator;
local Players = game:GetService("Players");

local PlayerEdit = require(script.Parent.Parent.Parent.Components.Player.PlayerEdit);

local Rank = script.Parent.Parent.Parent.Parent["rank#"].Value;

local function EditPlayer(UserId)
	local Widget = PlayerEdit(UserId);
	Widget.Enabled = true;	
end

local PlayerActionMenu = {
	{
		name = "Open", id = "expand",
		func = function(Data)
			EditPlayer(Data.UserId)
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

local function getPlayersForTab(Canvas,Container)
	if(not fetchingPlayers)then
		fetchingPlayers=true;
		if(not ProgressIndicator)then
			ProgressIndicator = App.new("ProgressIndicator",Canvas);
			ProgressIndicator.Color = Color3.fromRGB(255, 255, 255);
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
				local newPlayer,Frame,ActionButton = PlayerComponent(v.UserId);
				newPlayer.Name = v.Name;
				newPlayer.Parent = Container:GetGUIRef();
				local ActionMenu = App.new("ActionMenu", script.Parent.Parent.Parent.Components.content);
				handleActionMenu(ActionMenu,PlayerActionMenu);

				ActionMenu.ActionTriggered:Connect(function(Action)
					local func = idActions[Action.ID];
					if(func)then
						func(v.Name,Action);
					end;
				end)
					
				ActionButton.MouseButton2Down:Connect(function()
					ActionMenu:Show();	
				end);
				
				ActionButton.MouseButton1Down:Connect(function()
					EditPlayer(v.UserId);
				end)
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
		local List = Instance.new("UIListLayout",PlayersContainer:GetGUIRef());
		--List.Padding = UDim.new(0,2)
		
		
		TabGroup.TabSwitched:Connect(function(tabData)
			if(tabData.TabId == script.Name)then
				getPlayersForTab(Frame,PlayersContainer)
			end
		end)
		
		return Frame;
	end,
}