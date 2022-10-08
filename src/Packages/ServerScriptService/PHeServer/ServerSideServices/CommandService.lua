local module = {}

local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"))
local PHeCommands = game:GetService("ServerScriptService"):WaitForChild("PHeServer"):FindFirstChild("server"):FindFirstChild("PHeCommands");
local Commands = require(PHeCommands.Commands);
local PHeCommandsMainModule = require(PHeCommands.MainModule);
local Ranks = PowerHorseEngine:GetGlobal("Engine"):RequestConfig().PHePanel.Ranks;
local PHeCommandsMainModule = require(PHeCommands.MainModule);
local UserIdService = PowerHorseEngine:GetService("UserIdService")


local CommandsQuickSearch = {}


local function getCommand(cmdName)
	cmdName = cmdName:lower();
	if(CommandsQuickSearch[cmdName])then return CommandsQuickSearch[cmdName];end;
	
	for _,cmd in pairs(Commands) do
		if(cmd.cmd:lower() == cmdName)then
			CommandsQuickSearch[cmdName]=cmd;
			return cmd;
		end
	end
	
end;

function module.getCanExecuteCommand(rankNumber,Command)
	
	if(rankNumber == Ranks[1][1])then
		return true; --> Highest rank does not need validation.
	end
	
	local cmd = getCommand(Command);
	if(not cmd)then return "internal server error: could not find command to validate.";end;
	
	cmd.req = cmd.req or 0;
	
	if(typeof(cmd.req) == "string")then
		cmd.req = PHeCommandsMainModule.getRank(cmd.req).number;
	end;
	
	if(cmd.req > rankNumber)then
		return "you do not have permission to execute this command.";
	end
	
	return true;
	
end;

function module.InvokeClientCommand(Player,cmdName,...)


	local rankData = PHeCommandsMainModule.getUserRank(Player);
	
	if(not rankData)then
		return{
			error = "internal server error: no rank data found.";
		};
	end;

	local canExecute = (module.getCanExecuteCommand(rankData.number,cmdName));
	if(canExecute ~= true)then return {error = canExecute};end;
	
	return module.executeCommand(Player,cmdName,...)
end

local function convertType(type_,myArg,PlayerExecuter)
	if(not myArg)then return end;
	local arg;
	if(type_ == "player")then
		if(myArg == "me" or myArg == "Me" and PlayerExecuter)then myArg = PlayerExecuter.Name;end;
		local targetPlayer = game:GetService("Players"):FindFirstChild(myArg);
		if(not targetPlayer)then return {success = false; error = "\""..myArg.."\" is not a valid player in the server"}end;
		arg = targetPlayer;
	elseif(type_ == "number")then
		local asNumber = tonumber(myArg);
		if(not asNumber)then return {success = false; error = "failed to parse "..myArg.." as number"};end;
		arg = asNumber;
	elseif(type_ == "vector3")then
		local v1,v2,v3 = myArg:match("%s*(%d+)%s*,%s*(%d+)%s*,%s*(%d+)%s*");
		if(not v1 or not v2 or not v3)then return {success = false; error = "failed to parse "..myArg.." as vector3"};end;
		arg = Vector3.new(v1,v2,v3);
	elseif(type_ == "boolean" or type_ == "bool")then
		if(myArg:lower() == "true")then
			arg = true;
		else
			arg = false;
		end;
	elseif(type_ == "user")then
		if(myArg == "me" or myArg == "Me" and PlayerExecuter)then myArg = PlayerExecuter.Name;end;
		if(tonumber(myArg))then myArg = tonumber(myArg);end;
		local userid = UserIdService.getUserId(myArg)
		if(not userid)then return {success = false; error = "Could not fetch user "..myArg..". User does not exist on ROBLOX"};end;
		local username = UserIdService.getUsername(userid)
		local PlayerInGame = game:GetService("Players"):FindFirstChild(username);
		arg = {
			UserId = userid;
			Name = username;
			Player = PlayerInGame;
			InGame = PlayerInGame and true or false;
		}
	else
		return myArg;
	end;
	return arg;
end

function module.executeCommand(PlayerExecuter,commandName,t)
	
	if(typeof(PlayerExecuter) ~= "string" and PlayerExecuter:IsA("Player") ) then
	else
		t = commandName;
		commandName = PlayerExecuter;
		PlayerExecuter=nil;
	end
	if(typeof(commandName) ~= "string")then
		return {
			success = false;
			error = "string expected for command name, got "..(typeof(commandName))
		}
	end
	t = typeof(t)=="table" and t or {};
	local targetCommand = getCommand(commandName);
	if(not targetCommand)then
		return {
			success = false;
			error = commandName.." is not a valid command";
		}
	end;

	local cmdArgs = targetCommand.args;
	
	local toArg = {}
	local errorsCompiled;
	local newMyArg;
	
	for i,v in pairs(cmdArgs)do
		-- local myArg = t[v.var];
		local myArg = t[i];
		if(not myArg)then
			if(v.req)then
				return {
					success = false;
					error = "Missing required argument "..tostring(i).." \""..v.var.."\""
				};
			--else
				--newMyArg = v.default
			end;
		end;
		local hasMultipleTypes = v.type:match(",")
		if(hasMultipleTypes)then
			
			for _,x in pairs(v.type:gsub(" ",""):split(",")) do
			
				local q = convertType(x,myArg,PlayerExecuter);
				if(q)then 
					if(typeof(q) == "table" and q.error)then
						errorsCompiled = errorsCompiled and errorsCompiled.."->["..q.error.."] " or "->["..q.error.."] ";
						newMyArg = nil;
					else
						newMyArg = q;break;
					end
				end
			end
		else
			newMyArg = convertType(v.type, myArg,PlayerExecuter);
			--print(newMyArg,v)
		end
		
		if(not newMyArg and errorsCompiled)then
			return {
				success = false;
				error = errorsCompiled;
			}
		end
		
		if(not newMyArg)then
			newMyArg = v.default;
		end
		
		if(typeof(newMyArg) == "table" and newMyArg.error )then
			return newMyArg;
		end
		
		
		table.insert(toArg, newMyArg);
	end;
	
	--print(toArg)
	
	local success,executed = pcall(function() return targetCommand.exe(unpack(toArg));end);
	if(not success)then
		warn(executed)
		return {
			success = false;
			error = "Internal error: "..((executed and executed --[[executed:match(":(.+)")]]) or "???") ;
		}
	
	end
	toArg=nil;
	if(not executed)then
	
		return {
			success = true;
			message = "Command didn't return any message"
		}else
		if(executed.error)then executed.success = false;end;
		return {
			success = executed.success;
			message = executed.message;
			error = executed.error;
			mColor = executed.mColor;
		};
	end
	
	
	
end

return module
