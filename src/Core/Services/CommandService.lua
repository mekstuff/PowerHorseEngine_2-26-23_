local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");
local TextService = PowerHorseEngine:GetService("TextService");
local module = {}

local Commands;

--local consoleOutput = ;

function module:GetCommands()
	--return require(game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PHePanel"):WaitForChild("Commands"));
	if(not Commands)then
		Commands = Engine:FetchStorageEvent("PHePanel_CommandReciever","RemoteFunctions"):InvokeServer();
	end;
	return Commands;
end

function module:ExecuteCommand(x,y,focusOnCommand)
	--consoleOutput("> Executing command...");
	
	local cmd = module:GetCommand(x);
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
		res = Engine:FetchStorageEvent("PHePanel_CommandExecutor","RemoteFunctions"):InvokeServer(module:FromStringToCommand(x));
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

function module:GetCommand(name)
	for _,x in pairs(module:GetCommands())do
		if(x.cmd:lower() == name:lower())then return x;end;
	end
end

function module:FromStringToCommand(String)
	local asWords = TextService:GetWordsFromString(String, ">","<");
	local Commands = module:GetCommands();
	local commandName = asWords[1]
	local commandVariables = {};
	for q = 2,#asWords do
		table.insert(commandVariables, asWords[q])
	end
	local targetCommand;
	local i = 0;
	return commandName,commandVariables;
end;

function module:ExecuteCmdFromStr(Str)
	return module:ExecuteCommand(module:FromStringToCommand(Str));
end;



return game:GetService("RunService"):IsServer() and require(game:GetService("ServerScriptService").PHeServer.ServerSideServices[script.Name]) or module