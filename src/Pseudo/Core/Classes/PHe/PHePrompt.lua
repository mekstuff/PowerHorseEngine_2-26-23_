local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local PHePrompt = {
	Name = "PHePrompt";
	ClassName = "PHePrompt";
	Header = "PHe Prompt";
	--HeaderAdjustment = Enumeration.Adjustment.Center;
};
PHePrompt.__inherits = {"Prompt","Modal","BaseGui"}

--//
function PHePrompt:AddButton(...)
	if(not self._dev._linebreakB)then
		local LineBreakB = self:_GetAppModule().new("LineBreak");
		LineBreakB.Name = "D";
		LineBreakB.Parent = self:GET("Modal"):GET("ModalContainer");
		self._dev._linebreakB=true;
	end
	return self:GET("Modal"):AddButton(...);
end;
--//
function PHePrompt:_Render(App)
	
	
	local Prompt = App.new("Prompt");
	
	Prompt._isPHEPROMPTOBEJ_ECT = true;
	Prompt.Blurred=true;Prompt.Highlighted=true;
	Prompt.StartPosition = UDim2.new(.5,0,-1,0);
	
	
	local ModalContainer = Prompt:GET("Modal"):GET("ModalContainer");
	local LineBreakA = App.new("LineBreak");
	LineBreakA.Name = "B";
	LineBreakA.Parent = ModalContainer;
	
	self:AddEventListener("ButtonClicked",true,Prompt:GetEventListener("ButtonClicked"));
	
	Prompt.Parent = self:GetRef();
	
	return {
		["Level"] = function(Value)
			Prompt.Level = Value+999;
		end,
		_Components = {
			Prompt = Prompt;
			Modal = Prompt:GET("Modal");
			FatherComponent = Prompt:GetGUIRef();
			_Appender = Prompt:GET("_Appender");
		};
		_Mapping = {
			[Prompt] = {
				"BackgroundTransparency",
				"BackgroundColor",
				"Size",
				"Roundness",
				"Header",
				"HeaderIcon",
				--"HeaderTextSize",
				"ButtonsAdjustment",
				"ModalSize",
				"ButtonsScaled",
				"css","Body","CloseButtonVisible",
				--"StartPosition","StartAnchorPoint",
				"DestroyOnOverride"
			}	
		};
	};
end;


return PHePrompt
