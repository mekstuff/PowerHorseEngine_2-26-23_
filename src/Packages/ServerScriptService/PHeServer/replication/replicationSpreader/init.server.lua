--[[
	Yaxis
	Written by MightTea
	Used to enable client replications.
]]

local ReplicationSafety = script.replicationSafety;

game:GetService("Players").PlayerAdded:Connect(function(Plr)
	local rep = ReplicationSafety:Clone();
	rep.Parent = Plr:WaitForChild("PlayerGui");
end)

local cb = require(script.replicationSafetyCallback.callBack);
for _,v in pairs(game:GetService("Players"):GetPlayers())do
	cb(v);
end

script.Parent.PHeGui.Parent = game:GetService("ReplicatedFirst"):WaitForChild("PHe_POST");