local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Format = App:GetGlobal("Format");
local SerializationService = App:GetService("SerializationService");
local SerializedData = script:FindFirstChild("info.serial");

local t;

local function getBodyForData(v)
	local Data = SerializationService:DeserializeTable(v);
	local b = "You have been temporarily suspended for "..Data.Days.." day(s) because of "..Data.Reason..".";
	local Diff = Format(os.time(),Data.TimeOfBan):toTimeDifference();
	local nt = tostring(Diff.days).." day(s) "..tostring(Diff.hours).." hours(s) "..tostring(Diff.minutes).." minute(s) and "..tostring(Diff.seconds).." second(s)";
	t = b.."\n\n~"..nt..".";
	return t;
end

local Prompt = App.new("PHePrompt");
Prompt.Header = "Account Suspended";
Prompt.Body = SerializedData and getBodyForData(SerializedData.Value) or "Waiting for data...";
Prompt:AddButton("I Understand");
Prompt.Parent = script.Parent;

Prompt:GetPropertyChangedSignal("Destroy"):Connect(function()
	game.Players.LocalPlayer:Kick(t);
end);

Prompt.ButtonClicked:Connect(function()
	Prompt:Destroy();
end)

if(not SerializedData)then
	local d = script:WaitForChild("info.serial");
	Prompt.Body = getBodyForData(d.Value);
end;