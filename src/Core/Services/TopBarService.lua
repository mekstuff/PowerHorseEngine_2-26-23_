local Engine = require(script.Parent.Parent.Parent.Engine);
local module = {}


function module:GetTopBar()
	local defaultsGUI = _G[Engine.Manifest.Name].GUI.Defaults;
	local defaultsGUICanvas = _G[Engine.Manifest.Name].GUI.Defaults.__Canvas;
	local TopBar = defaultsGUI.TopBar;
	if(not TopBar)then
		local Pseudo = require(script.Parent.Parent.Parent.Pseudo);
		
		local newTopBar = Pseudo.new("TopBar",{
			Parent = defaultsGUICanvas;
		});
		TopBar = newTopBar;
		defaultsGUI.TopBar = newTopBar;
	end;
	return TopBar;
end;

function module:AddButton(Icon)
	--print(module:GetTopBar())
	return module:GetTopBar():AddButton(Icon);
end

return module
