local Types = require(script.Parent.Parent.Parent.Parent.Parent.Types);
local Theme:Types.Theme = require(script.Parent.Parent.Parent.Theme)::any;
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local TextService = game:GetService("TextService");

--[=[
	@class BaseText

	BaseText is the based class for the `Text` component
]=]
local BaseText = {
	__PseudoBlocked=true;
	Name = "BaseText";
	ClassName = "BaseText";
};
BaseText.__inherits = {"GUI","BaseGui"};
--[=[
@prop Inherits BaseGui
@within BaseText
]=]
--[=[
@prop Inherits GUI
@within BaseText
]=]

--[=[
	Creates a `TextInput` that at the given text object and focuses on it.

	It will yield until the `TextInput` loses focus and returns the text that the user inputed
	@yields

	```lua
	local TextObject = App.new("Text");
	TextObject.Text = "Enter name in 2 seconds";

	wait(2);
	local UserInput = TextObject:GetUserTextAsync();
	TextObject.Text = "You entered: "..userInput;
	```
]=]

function BaseText:GetUserTextAsync(ShowText:string?):(string|nil,boolean)
	local App = self:_GetAppModule();
	local Replacement = App.new("TextInput");
	Replacement.Size = UDim2.fromOffset(self:GetGUIRef().AbsoluteSize.X,self:GetGUIRef().AbsoluteSize.Y);
	Replacement.PlaceholderText = "";
	
	Replacement.ClearTextOnFocus = false;
	Replacement.AnchorPoint = self.AnchorPoint;
	Replacement.Position = self.Position;
	Replacement.TextSize = self.TextSize;
	Replacement.Font = self.Font;
	Replacement.TextWrapped = self.TextWrapped;
	Replacement.TextXAlignment = self.TextXAlignment;
	Replacement.TextYAlignment = self.TextYAlignment;
	Replacement.AutomaticSize = self.AutomaticSize;
	-- Replacement.MultiLine = self.TextWrapped;
	-- Replacement.AutomaticSize = Enum.AutomaticSize.Y;
	
	Replacement.SupportsRBXUIBase = true;
	Replacement.StrokeTransparency = 0;
	Replacement.StrokeColor3 = Theme.getCurrentTheme().Primary;
	--Replacement.MultiLine = true;
	Replacement.Overflow = false;
	Replacement.Name = self.Name;
	local VisibleStateBefore = self.Visible;
	self.Visible = false;
	Replacement.Text = ShowText or self.Text;
	--self.ClipsDescendants = false;
	Replacement.Parent = self.Parent
	Replacement:CaptureFocus();
	local ep = Replacement.FocusLost:Wait();
	local t = Replacement.Text 
	Replacement:Destroy();
	self.Visible = VisibleStateBefore;
	return t,ep;
end;
--//
function BaseText:GetTextSizeFromTextService(t,fs,f,f_s)
	if(not t)then t = self.Text;end;
	if(not fs)then fs = self.TextSize;end;
	if(not f)then f = self.Font;end;
	if(not f_s)then f_s = Vector2.new(math.huge,math.huge);end;
	return TextService:GetTextSize(t,fs,f,f_s);
end;


function BaseText:_Render(App)
	
	
	local TextComponent = Instance.new("TextLabel");
	TextComponent.Parent = self:GetRef();

	
	return {
		
		_Components = {
			FatherComponent = TextComponent;
			TextComponent = TextComponent;
			
		};
		_Mapping = {
			[TextComponent] = 
				{"Font","LineHeight","RichText","TextColor3","TextScaled","TextSize","Text","TextStrokeColor3","TextStrokeTransparency","TextTransparency","TextTruncate","TextWrapped","TextXAlignment","TextYAlignment",
				"Position","Size","Visible","BackgroundColor3","BackgroundTransparency","ZIndex","AnchorPoint","AutomaticSize","BorderSizePixel","LayoutOrder"
			}
		}
	};
end;

return BaseText
