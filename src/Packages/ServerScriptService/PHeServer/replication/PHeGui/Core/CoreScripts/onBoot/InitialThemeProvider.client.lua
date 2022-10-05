--A theme provider responsible for every GUI

--[[
local App = _G.App;
local PseudoService = App:GetService("PseudoService")
local BaseGuis = PseudoService:GetPseudoObjects("BaseGui");

local str = table.concat(BaseGuis, ",");



local CoreThemeProvider = App.new("ThemeProvider");
CoreThemeProvider.Name = "CoreThemeProvider";
CoreThemeProvider.ThemeFilter = str;
CoreThemeProvider.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui");
]]