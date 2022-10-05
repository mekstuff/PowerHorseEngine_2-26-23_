local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TextService = game:GetService("TextService");

local DialogueGUI = {
	Name = "DialogueGUI";
	ClassName = "DialogueGUI";
	BackgroundColor3 = Color3.fromRGB(0);
	BackgroundTransparency = .45;
	Roundness = UDim.new(0,10);
	Size = UDim2.fromOffset(250,200);
	Position = UDim2.new(.5,0,1,-15);
	AnchorPoint = Vector2.new(.5,1);
	Speaker = "MightTea";
	SpeakerTextSize = 25;
	TextSize = 20;
};
DialogueGUI.__inherits = {"BaseGui","Frame","GUI"}

function DialogueGUI:NewDialogue(Text,Options,Speaker,Speed)
	local App = self:_GetAppModule();
	local DialogueModal = self:GET("DialogueModal");
	local DialogueTextContainer = self:GET("DialogueTextContainer");
	
	
	local TextComponent = App.new("Text");
	TextComponent.TextXAlignment = Enum.TextXAlignment.Left;
	TextComponent.TextYAlignment = Enum.TextYAlignment.Top;
	TextComponent.TextSize = self.TextSize;
	TextComponent.Size = UDim2.new(1);
	TextComponent.AutomaticSize = Enum.AutomaticSize.Y;
	TextComponent.TextWrapped = true;
	
	TextComponent.Parent = DialogueTextContainer;
	
	local SpaceRequired = TextService:GetTextSize(Text,TextComponent.TextSize,TextComponent.Font,Vector2.new(DialogueTextContainer:GetGUIRef().AbsoluteSize.X,DialogueTextContainer:GetGUIRef().AbsoluteSize.Y));
	
	print(SpaceRequired);
	
	for i = 1,#Text do
		local str = string.sub(Text, 1,i);
		if (TextComponent:GetAbsoluteSize().Y > DialogueTextContainer:GetAbsoluteSize().Y - 10)then
			print("Overflow")
		end
		--print(TextComponent:GetAbsoluteSize().Y > SpaceRequired.Y)
		TextComponent.Text = str;
		wait(Speed);
	end
	
end


function DialogueGUI:_Render(App)
	
	local DialogueModal = App.new("Modal",self:GetRef());
	
	local DialogueTextContainer = App.new("Frame",DialogueModal);
	DialogueTextContainer.Size = UDim2.new(0,450,0,100);
	DialogueTextContainer.BackgroundTransparency = .7;
	DialogueTextContainer.StrokeTransparency = 1;
	
	return {
		["Speaker"] = function(Value)
			DialogueModal.HeaderText = Value;
		end,["SpeakerTextSize"] = function(Value)
			DialogueModal.HeaderTextSize = Value;
		end,
		_Components = {
			DialogueModal = DialogueModal;
			DialogueTextContainer = DialogueTextContainer;
			
		};
		_Mapping = {
			[DialogueModal] = {
				"Position","AnchorPoint","Roundness","BackgroundColor3","BackgroundTransparency",
				"StrokeThickness","StrokeTransparency","StrokeColor3"
			}	
		};
	};
end;


return DialogueGUI
