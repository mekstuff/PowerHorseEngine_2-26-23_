local RunService = game:GetService("RunService");
local IsClient = RunService:IsClient();
local IsRunning = RunService:IsRunning();

--[=[
    @class Framework

    Framework is a library similar to `Knit` shipped into PowerHorseEngine.

    View `FrameworkClient` and `FrameworkServer`
]=]


if(IsClient)then
    return require(script.FrameworkClient);
else
    return require(script.FrameworkServer);
end