local __client = game.Players.LocalPlayer;
local ErrorService = require(script.Parent.ErrorService);
local CustomClassService = require(script.Parent.CustomClassService);
local EngineInvoker = require(script.Parent.Parent.Parent.Engine):FetchStorageEvent("PingService_RequestUserPing_Event","RemoteFunctions") 
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Format = require(script.Parent.Parent.Globals.Format);

local Client = {};
local Ping;

function Client:RequestUserPingAsync()
	if(not Ping)then
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
					
								--self.ms = tostring(p).." ms";
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
	
		Ping = newClass;		
		
	end
	return Ping;
--[[
	return {
		ms = tostring(p).." ms";
		ping = p;
		ConnectionStatus = l;
	}
	]]
end

local Server = {};

function Server.Invoke(Player)
	return true;
end

function Server:RequestUserPingAsync()
	ErrorService.tossWarn("RequestUserPingAsync can only be called by the client. Use a remote event to share this information with the server.")
end;

if(__client)then return Client else return Server;end;