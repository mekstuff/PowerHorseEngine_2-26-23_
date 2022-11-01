-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Friday, September 23 2022 @ 08:16:26

local CommandsModule = require(script.Parent.Commands);
local MainModule = require(script.Parent.MainModule);
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");
local PowerHorseEngineContent = Engine:RequestContentFolder();
local PHeCmdsPage = PowerHorseEngineContent:WaitForChild("Config"):FindFirstChild("PHeCmdsPage");

if(Engine:RequestConfig().PHePanel and Engine:RequestConfig().PHePanel.Disabled == true)then
	return;
end;

--//Custom Pages Wrap in pcall probably?
if(PHeCmdsPage)then
	for _,v in pairs(PHeCmdsPage:GetChildren())do
		if(v:IsA("ModuleScript"))then
			v.Parent = script.Parent.MainModule.PHePanel.Main.Pages.CustomPages;
		end
	end
end



local ClientCommandData;


local function Distribute(...)
	MainModule.giveCommands(...);
end;

local MainModule = require(script.Parent.MainModule);
for _,v in pairs(game:GetService("Players"):GetPlayers())do 
	local Rank = MainModule.getUserRank(v.UserId);
	Rank = Rank or {name="Player",number = 1}
	Distribute(v,Rank)	
end;
game:GetService("Players").PlayerAdded:Connect(function(Player)
	local Rank = MainModule.getUserRank(Player.UserId);
	Distribute(Player,Rank)
end);


--//Client invoking
Engine:FetchStorageEvent("PHePanel_CommandExecutor","RemoteFunctions").OnServerInvoke = PowerHorseEngine:GetService("CommandService").InvokeClientCommand;

local CommandsToShare;

local function ShareCommands()
	if(not ClientCommandData)then
		ClientCommandData = {};
		for _,cmd in pairs(CommandsModule)do
			local desc_str = cmd.desc
			for _,x in pairs(cmd.args)do
				--desc_str = desc_str.."n ".."<"..x.var..":"..x.type.."> "..x.description;
				x.desc = x.desc or "";
				desc_str = desc_str.."\n".."<"..x.var.." : "..x.type.."> "..x.desc;
				if(x.req)then desc_str = desc_str.." *";end;
			end;
			if(cmd.alias)then
				desc_str = desc_str.."\n\nalias: "..table.concat(cmd.alias,", ");
			end;
			if(cmd.author)then
				desc_str = desc_str.."\n\nauthor: "..cmd.author;
			end;
			table.insert(ClientCommandData, {
				cmd = cmd.cmd;
				args = cmd.args;
				req = cmd.req;
				desc = cmd.desc;
				alias = cmd.alias;
				author = cmd.author;
				desc_str = desc_str;
			});
		end;
	end;
return ClientCommandData
end;

Engine:FetchStorageEvent("PHePanel_CommandReciever","RemoteFunctions").OnServerInvoke = ShareCommands;