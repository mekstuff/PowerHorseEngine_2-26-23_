local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");

local SubtitleText = {
	Name = "SubtitleText";
	ClassName = "SubtitleText";
	DestroyOnNewSubtitle = true;
	Animated = true;
	AnimatedInterval = .1;
	TextColor3 = Theme.getCurrentTheme().Text;
	RichText = true;
	TextSize = 18;
	--TextTransparency = 0;
	TextStrokeTransparency = 0;
	Text = "";
	Font = Enum.Font.GothamBold;
};
SubtitleText.__inherits = {"BaseGui"};


function SubtitleText:AddButton(ButtonText,ButtonId)
	ButtonId = ButtonId or ButtonText;
	local ButtonsContainer = self:GET("ButtonsContainer");
	
	local ButtonRespect = Instance.new("Frame",ButtonsContainer:GetGUIRef());
	ButtonRespect.BackgroundTransparency = 1;
	local Button = self:_GetAppModule().new("Button");
	Button.TextAdjustment = Enumeration.Adjustment.Center;
	Button.Size = UDim2.fromScale(1,1)
	Button.ButtonFlexSizing = false;
	Button.Text = ButtonText or "Text Here";
	Button.Parent = ButtonRespect;
	Button.MouseButton1Down:Connect(function()
		self:GetEventListener("ButtonPressed"):Fire(ButtonId,Button,ButtonText);
	end);
	return Button;
end;

function SubtitleText:Destroy()
	local Text = self:GET("Text");
	local t = TweenService:Create(Text:GetGUIRef(), TweenInfo.new(.75), {TextTransparency = 1});
	t:Play();
	t.Completed:Connect(function()
		if(self._n)then
			self._n:Dismiss();
		end
		if(self and self._dev)then
			self:GetRef():Destroy();
		end;
	end);
end;
--//

function SubtitleText:_Render(App)
	
	local Container = App.new("Frame",self:GetRef());
	Container.Position = UDim2.fromScale(.5,0);
	Container.AnchorPoint = Vector2.new(.5,0);
	Container.Size = UDim2.new(1);
	Container.AutomaticSize = Enum.AutomaticSize.Y;
	Container.BackgroundTransparency = 1;
	Container.BackgroundColor3 = Color3.fromRGB(255, 58, 58);
	
	local Text = App.new("Text",Container);
	--Text.Position = UDim2.fromScale(.5,0);
	--Text.AnchorPoint = Vector2.new(.5,0);
	Text.Size = UDim2.new(1);
	Text.AutomaticSize = Enum.AutomaticSize.Y;
	Text.TextWrapped = true;
	--Text.AnchorPoint = Vector2.new(0,1)
	
	--Text.Size = UDim2.new(1,-50,1,-30);
	Text.BackgroundTransparency = 1;
	--Text.TextXAlignment = Enum.TextXAlignment.Center;
	Text.TextYAlignment = Enum.TextYAlignment.Bottom;
	
	local ButtonsContainer = App.new("Frame",Container);
	ButtonsContainer.Position = UDim2.fromScale(0,1);
	ButtonsContainer.Size = UDim2.fromScale(1);
	ButtonsContainer.AutomaticSize = Enum.AutomaticSize.Y;
	ButtonsContainer.BackgroundTransparency = 1;
	
	local Grid = Instance.new("UIGridLayout",ButtonsContainer:GetGUIRef());
	Grid.CellSize = UDim2.fromOffset(120,30);
	Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
	Grid.VerticalAlignment = Enum.VerticalAlignment.Top;
	
	self:AddEventListener("ButtonPressed",true);
	--[[
	local function update()
		if(self.Animated)then
			local thread = coroutine.create(function()
				for i = 1,#self.Text do
					Text.Text = rtf:format(self.Text:sub(1,i));
					game:GetService("RunService").RenderStepped:Wait();
				end
			end);coroutine.resume(thread);
		else
			Text.Text = self.Text;
		end
	end
	]]
	return {
		["Text"] = function(Value)
			Text.Text = Value;
		end,
		_Components = {
			Text = Text;
			FatherComponent = Container:GetGUIRef();	
			ButtonsContainer = ButtonsContainer;
		};
		_Mapping = {
			[Text]={
				"RichText","TextSize","TextStrokeTransparency","Font","TextColor3"
			}	
		};
	};
end;


return SubtitleText
