-- Written By Olanzo James @ Lanzo Inc
-- Responsible for sending replication tokens to clients.
-- Currently replication is too slow and bad, serializationservice should be optimized to drastically improve replications.
local Server = game:GetService("RunService"):IsServer();
local ReplicationEvent;
local IsRunning = game:GetService("RunService"):IsRunning();

if(Server and IsRunning)then
	ReplicationEvent = Instance.new("RemoteEvent");
	ReplicationEvent.Name = "Replicator";
	ReplicationEvent.Parent = script.Parent.Parent.Parent;
end;

local ReplicatedSuite = {};

if(Server and IsRunning)then
	game.Players.PlayerAdded:Connect(function(Plr)
		ReplicationEvent:FireClient(Plr,"rep-suite",ReplicatedSuite);
	end)
end;


--[=[
	@class ReplicationService
]=]
local ReplicationService = {}


--[=[
	@private
]=]
function ReplicationService:_FetchSuite()
	return ReplicatedSuite;
end

--[=[
	Removes the replication token from the suite
]=]
function ReplicationService.destroyReplicationToken(id:string)
	if(not IsRunning)then return end;
	ReplicationEvent:FireAllClients("remove-rep",id);
	ReplicatedSuite[id]=nil;
end;

local SupportedReplicationAncestors = {
	workspace,game:GetService("ReplicatedStorage"),game:GetService("ReplicatedFirst"),
	game:GetService("StarterGui"),game:GetService("StarterPlayer"),game:GetService("Teams"),
	game:GetService("StarterPlayer");
}
--[=[]=]
function ReplicationService.canReplicate(pseudo:any)
	local Ref = pseudo:_GetCompRef();
	for _,x in pairs(SupportedReplicationAncestors)do
		if(Ref:IsDescendantOf(x))then
			return true;
		end
	end;
	return false;
end
--[=[]=]
function ReplicationService.newReplicationToken(pseudo:any)
	local id = pseudo.__id;

	local AllowedReplication = ReplicationService.canReplicate(pseudo);

	if(AllowedReplication)then
		pseudo:GetPropertyChangedSignal():Connect(function()
			ReplicationService.ReplicatePseudo(pseudo);
		end);
		pseudo.Destroying:Connect(function()
			ReplicationService.destroyReplicationToken(id);
			id = nil;
		end)
		local propsSerialized = pseudo:SerializePropsAsync();
		ReplicatedSuite[pseudo._dev.__id]=propsSerialized;
		ReplicationEvent:FireAllClients("add-suite",pseudo._dev.__id,propsSerialized,pseudo:GetRef());
	end
end;

--[=[
	Updates the replication suite, use by the newToken, you do not need to call this method,
]=]
function ReplicationService.ReplicatePseudo(pseudo)
	local propsSerialized = pseudo:SerializePropsAsync();
	local AllowedReplication = ReplicationService.canReplicate(pseudo);
	if(not AllowedReplication)then
		ReplicationService.destroyReplicationToken(pseudo.__id);
	else
		if(not ReplicatedSuite[pseudo.__id])then
			ReplicationService.newReplicationToken(pseudo);
		else
			ReplicatedSuite[pseudo._dev.__id]=propsSerialized;
			ReplicationEvent:FireAllClients("update-suite",pseudo._dev.__id,propsSerialized,pseudo:GetRef());
		end;
	end
end;

return ReplicationService


