local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local CoreGuiService = PowerHorseEngine:GetService("CoreGuiService");
local CustomClassService = PowerHorseEngine:GetService("CustomClassService");

local Portal = PowerHorseEngine.new("Portal",script.Parent.Parent.gui);
Portal.ZIndex = 999;

local GameActivityObject = PowerHorseEngine.new("GuiSignalBlocker",Portal);
--GameActivityObject.ZIndex = 999;
GameActivityObject.Visible = false;
GameActivityObject.Size = UDim2.new(1,0,1,36);
GameActivityObject.Position = UDim2.fromOffset(0,-36);
GameActivityObject.ShowIndicator = true;

local GameActivityClass = {
	Name = "GameActivity";
	ClassName = "GameActivity";
	Transparency = .3;	
};

function GameActivityClass:_Render()
	return{
		["Transparency"] = function(v)
			GameActivityObject.Transparency = v;
		end,	
	};
end;

function GameActivityClass:SetActive(x)
	GameActivityObject.Visible = x;
end;

local Class = CustomClassService:Create(GameActivityClass);
CoreGuiService.ShareObject("GameActivityUI", Class);

