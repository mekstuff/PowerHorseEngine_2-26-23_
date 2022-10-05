--[[
local PowerHorseEngineModule = game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine");
local PowerHorseEngine = require(PowerHorseEngineModule);
local SerializationService = PowerHorseEngine:GetService("SerializationService");
local _LF = require(PowerHorseEngineModule:WaitForChild("Util"):WaitForChild("POST"):WaitForChild("LOCALFILES"):WaitForChild(".LF"));

local newPrompt = PowerHorseEngine.new("Prompt",game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("GUITesting"));
newPrompt.Header = 'Awesome';
newPrompt.Body = "This is actually really cool ngl!";


print(newPrompt:SerializePropsAsync());


for _,serialized in pairs(_LF)do
	local Deserialized = SerializationService:DeserializeTable(serialized);
	local new = PowerHorseEngine.new(Deserialized.ClassName);
	new:DeserializePropsAsync(Deserialized,true)
end;
]]