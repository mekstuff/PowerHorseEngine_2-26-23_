--[[
local App = _G.App;
local MagicBuildService = App:GetService("MagicBuildService");
local Engine = App:GetGlobal("Engine");

--//Events;
local MagicBuild_ExecuteBuild = Engine:FetchStorageEvent("MagicBuild_ExecuteBuild");



--//Connectins
MagicBuild_ExecuteBuild.OnClientEvent:Connect(function(model)
	MagicBuildService.Build(model)
end)
]]