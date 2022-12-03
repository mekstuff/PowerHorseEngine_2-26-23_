--[=[
    @class CodeService
]=]
local ServiceProvider = require(script.Parent.Parent.Providers.ServiceProvider);
local CustomClassService = ServiceProvider:LoadServiceAsync("CustomClassService");
local RunService = game:GetService("RunService");
local IsClient = RunService:IsClient();

local CodeService = {
    Name = "CodeService";
    ClassName = "CodeService";
};

function CodeService:_Render()
    local App = self:_GetAppModule();
    local Engine = App:GetGlobal("Engine");
    local CODESERVICE_COMMUNICATION = Engine:FetchStorageEvent("CODESERVICE_COMMUNICATION");
    return {};
end;


return CustomClassService:Create(CodeService);