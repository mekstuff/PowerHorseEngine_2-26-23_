--Written By Olanzo James @ Lanzo Inc
--Responsible for handling replication tokens sent from the server.

local RS = game:GetService("ReplicatedStorage")
local PowerHorseEngine_Module = RS:WaitForChild("PowerHorseEngine");
local PowerHorseEngine = require(PowerHorseEngine_Module);
local SerializationService = PowerHorseEngine:GetService("SerializationService");
local PowerHorseEngine_Replicator:RemoteEvent = PowerHorseEngine_Module:WaitForChild("Replicator");


local ReplicatedPseudos = {};

--//
local function createReplicatedObject(id,serialData)
	local Deserialized = SerializationService:DeserializeTable(serialData);
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
	else
		local new = PowerHorseEngine.new(Deserialized.ClassName,nil);
		new._REPLICATED = id;
		for a,b in pairs(Deserialized)do
			new[a]=getValue(b);
		end;
		ReplicatedPseudos[id]=new;
	end
end;

PowerHorseEngine_Replicator.OnClientEvent:Connect(function(state,id,serial,ref)	
	if(ref)then ref:Destroy();end;
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
	end;
end)

