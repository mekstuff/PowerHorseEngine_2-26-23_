local Server = game:GetService("RunService"):IsServer();
local ReplicationEvent;
local IsRunning = game:GetService("RunService"):IsRunning();
local SerializationService = require(script.Parent.SerializationService);


if(Server and IsRunning)then
	-- if(script.Parent.Parent.Parent.Parent ~= game:GetService("ReplicatedStorage"))then
	-- 	return {
	-- 		--// Proxy functions
	-- 	}
	-- end
	-- ReplicationEvent = Instance.new("RemoteEvent",script.Parent.Parent.Parent);
	-- ReplicationEvent.Name = "Replicator";
end;


local ReplicatedSuite = {};

-- if(Server and IsRunning)then
-- 	game.Players.PlayerAdded:Connect(function(Plr)

-- 		ReplicationEvent:FireClient(Plr,"rep-suite",ReplicatedSuite);
-- 	end)
-- end;


local module = {}


local ReplicatedYieldTime = 1;

function module:_FetchSuite()
	return ReplicatedSuite;
end



--[[
if(Server)then
	for _,v in pairs(game:GetService("Players"):GetPlayers()) do
		--local thread = coroutine.create(function()
			--wait(ReplicatedYieldTime);
			ReplicationEvent:FireClient(v,"rep-suite",ReplicatedSuite);
		--end)coroutine.resume(thread);
		
	end;
end;
--]]

local function getPropValue(Value)
	if(typeof(Value) == "table")then
		
		if(not Value.PowerHorseEnumType)then
			return Value;
		end
		
		return "_&_:ENUM:"..Value.PowerHorseEnumType..":"..Value.Name;
	else
		return Value;	
	end
end

--//
function module.destroyReplicationToken(id)
	-- if(not IsRunning)then return end;
	-- ReplicationEvent:FireAllClients("remove-rep",id);
	-- ReplicatedSuite[id]=nil;
end;
--//
function module.newReplicationToken(pseudo)
	-- local props = pseudo._getCurrentPropSheetState(true,true,true);
	-- ReplicatedSuite[pseudo._dev.__id] = props;
	-- ReplicationEvent:FireAllClients("add-suite",pseudo._dev.__id,props,pseudo:GetRef());

	--[[
	local propsSerialized = pseudo:SerializePropsAsync();
	ReplicatedSuite[pseudo._dev.__id]=propsSerialized;
	ReplicationEvent:FireAllClients("add-suite",pseudo._dev.__id,propsSerialized,pseudo:GetRef());
	]]
end;
	
--[[
function module.newReplicationToken(ref,id,propSheet)
	if(not IsRunning)then return end;
	if not (Server)then warn("Replication Tokens can only be created by the server.") return end;
	
	local RepProps = {};
	
	
	for p,v in pairs(propSheet)do
		if(typeof(v) ~= "function" and  not string.match(p, "^_")) then	
			RepProps[p]=getPropValue(v);
		end
	end;
--[[
	if(propSheet._CONSTRCUTED__BY___CREATE____FUNC)then
		RepProps._CONSTRCUTED__BY___CREATE____FUNC=true;
	end;
]
	

	ReplicatedSuite[id]={
		id = id;
		props =  RepProps;
		serverRef = ref;
	};
	
	
	ReplicationEvent:FireAllClients("add-suite",ReplicatedSuite[id]);

end;
]]
--[[
function module.InterceptObjectCreate(Object,id)
	if(ReplicationEvent)then
		--NonReplicatedInstances[id]=Object;
		ReplicationEvent:FireAllClients("intercept",Object);
	end;
end;
]]
--//
function module.ReplicatePseudo(pseudo)
	
	-- local props = pseudo._getCurrentPropSheetState(true,true,true);
	-- ReplicatedSuite[pseudo._dev.__id] = props;
	-- ReplicationEvent:FireAllClients("update-suite",pseudo._dev.__id,props,pseudo:GetRef());
	
	
--[[
	local propsSerialized = pseudo:SerializePropsAsync();
	
	ReplicatedSuite[pseudo._dev.__id]=propsSerialized;
	ReplicationEvent:FireAllClients("update-suite",pseudo._dev.__id,propsSerialized,pseudo:GetRef());
]]
end;

--[[
function module.ReplicatePseudo(id,Property,Value)
	if(not IsRunning)then return end;
	if not (Server)then warn("Replications can only be distributed by the server.")end;
	if(ReplicatedSuite[id])then
		--print("Property Replication Called");
		if(ReplicatedSuite[id][Property])then ReplicatedSuite[id][Property]= getPropValue(Value);end;

		local Thread=coroutine.create(function()
			wait();
		
			ReplicationEvent:FireAllClients("update-suite",id,Property,getPropValue(Value));

		end)coroutine.resume(Thread);
			
		--end)coroutine.resume(Thread);
		
		
		--print("KK")
	end
	--ReplicationEvent:FireAllClients(PseudoInstance,Property,Value);
end
]]
return module


