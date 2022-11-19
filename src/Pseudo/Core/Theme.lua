--[=[
	@class Theme
]=]
local Theme = {};
local Services = script.Parent.Parent.Parent.Core.Services;
local Types = require(Services.Parent.Parent.Types);
local PluginService = require(Services.PluginService);
local TweenService = require(Services.TweenService);

local _defaultTheme:{} = PluginService:IsPluginMode() and 
{

	Alert = Color3.fromRGB(13, 110, 253),
	Warning = Color3.fromRGB(255,204,0),
	Danger = Color3.fromRGB(204,51,0),
	Success = Color3.fromRGB(153,204,51),
	Info = Color3.fromRGB(124, 175, 252),

	Active = Color3.fromRGB(66, 135, 245);
	Unactive = Color3.fromRGB(87, 87, 87);

	Primary = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainButton);
	PrimaryLite = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainButton);

	Secondary = Color3.fromRGB(61, 66, 72);
	SecondaryLite = Color3.fromRGB(61, 66, 72);

	Disabled = Color3.fromRGB(44, 44, 44);
	DisabledLite = Color3.fromRGB(44, 44, 44);

	Background = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainBackground);
	BackgroundLite = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border);

	Text = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText);
	TextLite = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.MainText);

	Border = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border);
	BorderLite = settings().Studio.Theme:GetColor(Enum.StudioStyleGuideColor.Border);

	Foreground = Color3.fromRGB(222, 233, 239);
	ForegroundLite = Color3.fromRGB(222, 233, 239);

	ForegroundText = Color3.fromRGB(30, 30, 30);
	ForegroundTextLite = Color3.fromRGB(30, 30, 30);
	Font = Enum.Font.SourceSans;
}
or {

	Alert = Color3.fromRGB(13, 110, 253),
	Warning = Color3.fromRGB(255,204,0),
	Danger = Color3.fromRGB(204,51,0),
	Success = Color3.fromRGB(153,204,51),
	Info = Color3.fromRGB(124, 175, 252),

	Active = Color3.fromRGB(66, 135, 245);
	Unactive = Color3.fromRGB(87, 87, 87);

	Primary = Color3.fromRGB(66, 135, 245);
	PrimaryLite = Color3.fromRGB(66, 135, 245);

	Secondary = Color3.fromRGB(255, 32, 32);
	SecondaryLite = Color3.fromRGB(255, 32, 32);

	Disabled = Color3.fromRGB(57, 57, 57);
	DisabledLite = Color3.fromRGB(57,57,57);

	Background = Color3.fromRGB(29, 29, 29);
	BackgroundLite = Color3.fromRGB(29, 29, 29);

	Text = Color3.fromRGB(236, 236, 236);
	TextLite = Color3.fromRGB(236, 236, 236);

	Border = Color3.fromRGB(50, 115, 199);
	BorderLite = Color3.fromRGB(50, 115, 199);

	Foreground = Color3.fromRGB(63, 66, 68);
	ForegroundLite = Color3.fromRGB(63, 66, 68);

	ForegroundText = Color3.fromRGB(236, 236, 236);
	ForegroundTextLite = Color3.fromRGB(236, 236, 236);

	Font = Enum.Font.SourceSans;
}

local function getApp()
	return require(Services.Parent.Parent)
end;

--> Support for Config.Theme
local Config = getApp():GetGlobal("Engine"):RequestConfig();
if(Config.Theme)then
	for a:string,b in pairs(Config.Theme) do
		_defaultTheme[a] = b;
	end;
end;

local ThemeObject;
--[=[
	@private
]=]
function Theme.buildTheme()
	if(ThemeObject)then return ThemeObject;end;
	local App:Types.App = getApp()::any;
	local CustomClassService = App:GetService("CustomClassService");
	local ThemeClass = {
		Name = "UseTheme";
		ClassName = "UseTheme";
		Themes = {};
	};
	function ThemeClass:_Render()
		return {};
	end;
	ThemeObject = CustomClassService:Create(ThemeClass);
	for a:string,b in pairs(Theme.getDefaultTheme()) do
		local newState = App.new("State",ThemeObject);
		newState.Name = a.."-Theme";
		newState.State = b;
		ThemeObject.Themes[a] = newState;
	end;
end

--[=[
	extends the Theme
	
	```lua
	Theme.extendTheme({
		MyCustomColor = Color3.fromRGB(0,0,0);
		--> Or overwrite default themes
		Text = Color3.fromRGB(255,0,0)
	})
	Text.TextColor3 = Theme.useTheme("MyCustomColor");
	```

	extendTheme also extends onto stateful themes, so any component using .useTheme will update whenever the theme is extended

	```lua
	local function SwitchModes(dark:boolean)
		Theme.extendTheme({
			Text = dark and Color3.fromRGB(0,0,0) or Color3.fromRGB(255,255,255);
		});
	end;

	MyTextPseudo.TextColor3 = Theme.useTheme("Text") --> My Text will show white when not in darkmode/show black when in darkmode.

	```
]=]
function Theme.extendTheme(extension:{},uniqueThemeIdentifier:string?)
	local App:Types.App = getApp()::any;
	if(not ThemeObject)then
		Theme.buildTheme();
	end;
	for a,b in pairs(extension) do
		if(uniqueThemeIdentifier)then 
			a = uniqueThemeIdentifier..a;
		end;

		if(ThemeObject.Themes[a])then 
			-- ThemeDefault[a] = b;
			ThemeObject.Themes[a].State = b;
		else
			-- print("Extending");
			local newState = App.new("State",ThemeObject);
			newState.Name = a.."-Theme";
			newState.State = b;
			ThemeObject.Themes[a] = newState;
		end;
	end
end;

--[=[
	@return State
]=]
function Theme.useTheme(theme:string,uniqueThemeIdentifier:string?):Types.State|nil
	-- print(ThemeDefault[theme], theme)
	-- return ThemeDefault[theme]
	--[[ disabled until further notice ]]
	if(uniqueThemeIdentifier)then
		theme = uniqueThemeIdentifier..theme;
	end
	if(ThemeObject)then
		local t = ThemeObject.Themes[theme];
		if(not t)then
			warn(tostring(theme).." was not found. Use .extendTheme to add a theme");
		else 
			return t;
		end;
		return;
	end;
	Theme.buildTheme();
	return Theme.useTheme(theme);
end;

--[=[]=]
function Theme.ThemeToggler()
	-- if(ThemeToggler)then return ThemeToggler;end;

	local App = require(script.Parent.Parent.Parent);
	local Enumeration = App:GetGlobal("Enumeration");
	local Whiplash = App:Import("Whiplash");
	local New,OnEvent = Whiplash.New,Whiplash.OnEvent;
	local State = App:Import("State");

	local studioThemes = settings().Studio:GetAvailableThemes() 


	local ToolTipShowing,setToolTipShowing = State(false);


	local Button = New "$Button" {
		Name = "ButtonControlled";
		Roundness = UDim.new(25);
		-- BackgroundTransparency = .5;
		IconAdaptsTextColor = false;
		BackgroundColor3 = Theme.useTheme("Primary");
		IconColor3 = Theme.useTheme("Text");
		StrokeColor3 = Theme.useTheme("Text");
		Text = "";
		Icon = "ico-mdi@action/nightlight_round";
		StrokeThickness = 4;
		StrokeTransparency = 0;
		-- TextColor3
		ButtonFlexSizing = false;
		Size = UDim2.fromOffset(0,25);
		New "UIAspectRatioConstraint" {
			Name = "TogglerConstraint";
			DominantAxis = Enum.DominantAxis.Height;
			AspectType = Enum.AspectType.ScaleWithParentSize;
		};
		[OnEvent "MouseButton1Down"] = function()
			setToolTipShowing(function(showing)
				return not showing;
			end)
		end;
	};

	local ToolTipObject = New "$ToolTip" {
		Parent = Button:GetRef();
		Adornee = Button;
		Name = "ToolTipObject";
		IdleTimeRequired = 0;
		RespectViewport = false;
		RevealOnMouseEnter = false;
		PositionBehaviour = Enumeration.PositionBehaviour.Static;
		BackgroundColor3 = Theme.useTheme("BackgroundLite");
		New "$Frame" {
			Name = "ContentContainer";
			Size = UDim2.fromOffset(0,0); 
			AutomaticSize = Enum.AutomaticSize.Y;
			New "UIListLayout" {
				-- CellSize = UDim2.new(1,0,0,25);
				-- CellPadding = UDim2.fromOffset(0,5);
				Padding = UDim.new(0,5);
			}
		};
	};

	for _,v in pairs(studioThemes) do
		New "$Button" {
			Size = UDim2.fromScale(1,1);
			BackgroundTransparency = .4;
			BackgroundColor3 = v:GetColor(Enum.StudioStyleGuideColor.MainBackground);
			TextColor3 = v:GetColor(Enum.StudioStyleGuideColor.MainText);
			-- TextAdjustment = Enumeration.Adjustment.Center;
			SupportsRBXUIBase = true;
			Parent = ToolTipObject.ContentContainer;
			-- Text = "	"..v.Name;
			Text = v.Name;
			[OnEvent "MouseButton1Down"] = function()
				settings().Studio.Theme = v;
			end;
			[OnEvent "MouseEnter"] = function(this)
				--[[
				TweenService:Create(this,TweenInfo.new(.2),{
					TextColor3 = v:GetColor(Enum.StudioStyleGuideColor.MainBackground);
					BackgroundColor3 = v:GetColor(Enum.StudioStyleGuideColor.MainText);
				}):Play();
				]]
				TweenService:Create(this,TweenInfo.new(.2),{
					BackgroundTransparency = 0;
				}):Play();
	
			end;
			[OnEvent "MouseLeave"] = function(this)
				--[[
				TweenService:Create(this,TweenInfo.new(.2),{
					BackgroundColor3 = v:GetColor(Enum.StudioStyleGuideColor.MainBackground);
					TextColor3 = v:GetColor(Enum.StudioStyleGuideColor.MainText);
				}):Play();
				]]
				TweenService:Create(this,TweenInfo.new(.2),{
					BackgroundTransparency = .4;
				}):Play()
			end;
		}
	end
 
	ToolTipShowing:useEffect(function(showing)
		if(showing)then 
			ToolTipObject:Show(); 
		else 
			ToolTipObject:Hide();
		end;
	end);

	return Button;
end;
--[=[]=]
function Theme.getDefaultTheme()
	return _defaultTheme;
end;

--[=[
	Useful if you just want to use the current value of a Theme, this value will not be stateful (This is what is used by core components)
]=]
function Theme.getCurrentTheme()
	return Theme.getDefaultTheme();
end;


return Theme
