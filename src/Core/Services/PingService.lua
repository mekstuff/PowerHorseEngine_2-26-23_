local __client = game.Players.LocalPlayer;
local ErrorService = require(script.Parent.ErrorService);
local CustomClassService = require(script.Parent.CustomClassService);
local EngineInvoker = require(script.Parent.Parent.Parent.Engine):FetchStorageEvent("PingService_RequestUserPing_Event","RemoteFunctions") 
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Format = require(script.Parent.Parent.Globals.Format);

--[=[
	@class PingService

]=]

local PingServiceServer = {};
local PingService = {};

--[=[
	@class PingReader
	Pseudo returned from PingService
]=]
local PingReader;
--[=[
	@client
	@return PingReader
]=]
--[=[
	@prop Enabled boolean
	@within PingReader
]=]
--[=[
	@prop ms string
	@within PingReader
]=]
--[=[
	@prop Ping number
	@within PingReader
]=]
--[=[
	@prop UpdateInterval number
	@within PingReader
]=]
--[=[
	@prop ConnectionStatus Enumeration
	@within PingReader
]=]

function PingService:RequestUserPingAsync()
	if(not PingReader)then
		local c = {
			Name = game.Players.LocalPlayer.Name.."'s Ping";
			ClassName = "PingReader";
			Enabled = true;
			ms = "0 ms";
			Ping = 0;
			UpdateInterval = 1;
			ConnectionStatus = Enumeration.ConnectionStatus.Moderate;
		};
		function c:_Render()
			local ConnectionStatusEnums = Enumeration:GetEnums("ConnectionStatus");
			return {
				["Enabled"] = function(v)
					if(v)then
						local thread = coroutine.create(function()
							while self.Enabled do
								local tick_ = tick();
								EngineInvoker:InvokeServer();
								local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
								local p = math.floor(((tick()-tick_)/2) *1000);
								self.ms = Format(p):toNumberCommas():End().." ms";
								local l;
								for a,b in pairs(ConnectionStatusEnums)do
									if(p >= b.n)then

										if(l)then
											if(l.n < b.n)then l = b;end;
										else
											l = b;
										end;
									end;
								end;
								if(not l)then
									l = Enumeration.ConnectionStatus.Excellent;
								end;

								self.ConnectionStatus = l;
								self.Ping = p;
								
								wait(self.UpdateInterval);
					
							end;
						end);coroutine.resume(thread);
					end
				end, 
			
			};
		end
		
		local newClass = CustomClassService:CreateClassAsync(c);
	
		PingReader = newClass;		
		
	end
	return PingReader;
end


function PingServiceServer.Invoke()
	return true;
end


function PingServiceServer:RequestUserPingAsync()
	ErrorService.tossWarn("RequestUserPingAsync can only be called by the client. Use a remote event to share this information with the server.")
end;

if(__client)then return PingService else return PingServiceServer;end;
