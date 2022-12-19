local Engine = require(script.Parent.Parent.Parent.Engine);
local TopBarService = {}


function TopBarService:GetTopBar()
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

function TopBarService:AddButton(Icon)
	--print(TopBarService:GetTopBar())
	return TopBarService:GetTopBar():AddButton(Icon);
end

return TopBarService
