--[[
local RS = game:GetService("ReplicatedStorage")
local PowerHorseEngine_Module = RS:WaitForChild("PowerHorseEngine");
local PowerHorseEngine = require(PowerHorseEngine_Module);
local SerializationService = PowerHorseEngine:GetService("SerializationService");
local Util = require(PowerHorseEngine_Module.Pseudo.Core.Util);
local PowerHorseEngine_Replicator = PowerHorseEngine_Module:WaitForChild("Replicator");


local ReplicatedPseudos = {};

--//
local function createReplicatedObject(id,serialData)
	
	
	--local Deserialized = SerializationService:DeserializeTable(serialData);
	local Deserialized = serialData;
	
	local function getValue(v)
		if(typeof(v) == "string")then
			if(v:match("^pheSerialized%-"))then
				local serial = v:gsub("^pheSerialized%-","");
				return SerializationService:DeserializeTable(serial)[1]
			end;
		end;
		return v;
	end
	
	if(ReplicatedPseudos[id])then
		for a,b in pairs(Deserialized)do
			ReplicatedPseudos[id][a]=getValue(b);
		end
		--ReplicatedPseudos[id].Name = "CD"
		--ReplicatedPseudos[id]:DeserializePropsAsync(serialData);
	else
		local new = Util.Construct(Deserialized.ClassName,nil,{_REPLICATED=id});
		for a,b in pairs(Deserialized)do
			new[a]=getValue(b);
		end;
		--new.Name = "CD";
		--new._REPLICATED = id;
		ReplicatedPseudos[id]=new;
	end
end;

PowerHorseEngine_Replicator.OnClientEvent:Connect(function(state,id,serial,ref)	
	--print("Replication Request Recieved On Client ");
	
	if(ref)then ref:Destroy();end;
	--print(ref);
	--if(ref)then ref.Name = "server-sent";end;
	if(state == "rep-suite")then
		for _id,serialized in pairs(id) do
			createReplicatedObject(_id,serialized);
		end
	elseif(state == "add-suite")then
		createReplicatedObject(id,serial);
	elseif(state == "update-suite")then
		createReplicatedObject(id,serial)
	elseif(state == "remove-rep")then
		if(ReplicatedPseudos[id])then
		
			ReplicatedPseudos[id]:Destroy();
			ReplicatedPseudos[id]=nil;
		end
	end
	--print("Took ", tick()-s," seconds to complete client replication ",state);
--[[
	local args = {...};
	
	if(state == "remove-rep")then
		local id = args[1];
		if(ReplicatedPseudos[id])then
			print("Removed a replication")
			ReplicatedPseudos[id]:Destroy();
			ReplicatedPseudos[id]=nil;
		end
	end;
	if(state == "intercept")then
		if(args[1])then
			args[1]:Destroy();
			print("Destroyed VIA Interception");
		end;
		
	end
	--//
	if(state == "rep-suite")then
		local toRep = args[1];
		local nonRepInstances = args[2];
		for _,rep in pairs(toRep)do
			createReplicatedObject(rep);
		end;
		for _,v in pairs(nonRepInstances)do
			v:Destroy();
		end;
	end;
	--//
	if(state == "add-suite")then
	
		local object = args[1];
	
		createReplicatedObject(object)

	end
	--//
	if(state == "update-suite")then
		

		local id,prop,value = args[1],args[2],args[3];
		local yield = 0;
		repeat wait() yield+=1 until ReplicatedPseudos[id] or yield > 120;

		
		if(ReplicatedPseudos[id])then
			setReplicatedValue(ReplicatedPseudos[id],prop,value);
		else
			warn("Replication property failed: Client couldn't initiate in time")
		end
	end
	]
	
end)
]]

