local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");
local TextService = PowerHorseEngine:GetService("TextService");

--[=[
	@class CommandService
	@client
]=]
local CommandService = {}

local Commands;

--local consoleOutput = ;

--[=[]=]
function CommandService:GetCommands():table
	--return require(game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PHePanel"):WaitForChild("Commands"));
	if(not Commands)then
		Commands = Engine:FetchStorageEvent("PHePanel_CommandReciever","RemoteFunctions"):InvokeServer();
	end;
	return Commands;
end

--[=[]=]
function CommandService:ExecuteCommand(x:string,y:{[any]:any},focusOnCommand:boolean?):string?
	--consoleOutput("> Executing command...");
	
	local cmd = CommandService:GetCommand(x);
	if(cmd)then
		if(cmd.__clientSided)then
			local res = cmd.exe(unpack(y));
			if(not res)then res = {success=true;message="command did not return any messages"};end
			if(res.error)then
				_G.cmd_CommandOutput("Failed to execute command \""..(x or "???").."\". "..res.error, Color3.fromRGB(255, 71, 47),focusOnCommand);
			else
				_G.cmd_CommandOutput("Executed command \""..x.."\".", Color3.fromRGB(87, 252, 78),focusOnCommand);
			end;
			if(res.message)then
				_G.cmd_CommandOutput(res.message, res.mColor or Color3.fromRGB(75, 152, 252),focusOnCommand);
			end;
			return;
		end
	end
	
	local res;
	if(not y)then
		res = Engine:FetchStorageEvent("PHePanel_CommandExecutor","RemoteFunctions"):InvokeServer(CommandService:FromStringToCommand(x));
	end
	res = Engine:FetchStorageEvent("PHePanel_CommandExecutor","RemoteFunctions"):InvokeServer(x,y);
	--print(res)
	if(res.error)then
		_G.cmd_CommandOutput("Failed to execute command \""..(x or "???").."\". "..res.error, Color3.fromRGB(255, 71, 47),focusOnCommand);
	else
		_G.cmd_CommandOutput("Executed command \""..x.."\".", Color3.fromRGB(87, 252, 78),focusOnCommand);
	end;
	if(res.message)then
		_G.cmd_CommandOutput(res.message, res.mColor or Color3.fromRGB(75, 152, 252),focusOnCommand);
	end
	return res;
end;

--[=[]=]
function CommandService:GetCommand(name:string)
	for _,x in pairs(CommandService:GetCommands())do
		if(x.cmd:lower() == name:lower())then return x;end;
	end
end

--[=[]=]
function CommandService:FromStringToCommand(String:string):(string,{})
	local asWords = TextService:GetWordsFromString(String, ">","<");
	local Commands = CommandService:GetCommands();
	local commandName = asWords[1]
	local commandVariables = {};
	for q = 2,#asWords do
		table.insert(commandVariables, asWords[q])
	end
	local targetCommand;
	local i = 0;
	return commandName,commandVariables;
end;

--[=[]=]
function CommandService:ExecuteCmdFromStr(Str:string):string?
	return CommandService:ExecuteCommand(CommandService:FromStringToCommand(Str));
end;

-- Server Functions and props for docs

--[=[
	@function InvokeClientCommand
	@within CommandService
	@server
	@param Player Player
	@param cmdName string
	@param ... any
]=]

--[=[
	@function executeCOmmand
	@within CommandService
	@server
	@param PlayerExecuter Player
	@param commandName string
	@param t any
]=]

--[=[
	@function getCanExecuteCommand
	@within CommandService
	@server
	@param rankNumber number
	@param Command string
]=]

return game:GetService("RunService"):IsServer() and require(game:GetService("ServerScriptService").PHeServer.ServerSideServices[script.Name]) or CommandService;