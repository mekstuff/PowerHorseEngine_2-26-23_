local module = {};
local Services = script.Parent.Parent.Parent.Core.Services;
local PluginService = require(Services.PluginService);
local TweenService = require(Services.TweenService);


local ThemeDefault = PluginService:IsPluginMode() and 
{

	Alert = Color3.fromRGB(),
	Warning = Color3.fromRGB(),
	Danger = Color3.fromRGB(),
	Success = Color3.fromRGB(),
	Info = Color3.fromRGB(),

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
	-- FontSize = 16;
}
or {

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
	-- FontSize = 30;
}

-- local GlobalThemes = {
-- 	Primary = Color3.fromRGB(66, 135, 245);
-- 	Secondary = Color3.fromRGB(255, 32, 32);
-- 	Disabled = Color3.fromRGB(57, 57, 57);
-- 	Background = Color3.fromRGB(29, 29, 29);
-- 	Text = Color3.fromRGB(236, 236, 236);
-- 	Border = Color3.fromRGB(50, 115, 199);
-- 	Foreground = Color3.fromRGB(63, 66, 68);
-- 	ForegroundText = Color3.fromRGB(236, 236, 236);
-- 	Font = Enum.Font.FredokaOne;
-- }

-- module.Themes = {
-- 	["Default"] = {
-- 		Active = GlobalThemes.Primary;
-- 		NonActive = Color3.fromRGB(43, 43, 43);
-- 		Primary = GlobalThemes.Primary;
-- 		Secondary = GlobalThemes.Secondary;
-- 		Disabled = GlobalThemes.Disabled;
-- 		Background = GlobalThemes.Background;
-- 		Text = GlobalThemes.Text;
-- 		Border = GlobalThemes.Border;
-- 		Foreground = GlobalThemes.Foreground;
-- 		ForegroundText = GlobalThemes.ForegroundText;
-- 		Font = Enum.Font.SourceSans;
-- 	};
-- }


local ThemeObject;

-- local AppModule;
local function getApp()
	return require(Services.Parent.Parent)
	-- if(AppModule)then return AppModule;end;
	-- if(PluginService:IsPluginMode())then
	-- 	return PluginService:ReadSync().app;
	-- end;
	-- return 
	-- return require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"))
end;

function module.buildTheme()
	if(ThemeObject)then return ThemeObject;end;
	local App = getApp();
	-- local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
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
	-- ThemeObject.Parent = workspace;
	for a,b in pairs(ThemeDefault) do
		local newState = App.new("State",ThemeObject);
		newState.Name = a.."-Theme";
		newState.State = b;
		ThemeObject.Themes[a] = newState;
	end;
end


function module.extendTheme(t,uniqueThemeIdentifier)
	local App = getApp();
	if(not ThemeObject)then module.buildTheme();end;
	for a,b in pairs(t) do
		if(uniqueThemeIdentifier)then a = uniqueThemeIdentifier..a;end;

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


function module.useTheme(theme)
	-- print(ThemeDefault[theme], theme)
	-- return ThemeDefault[theme]
	--[[ disabled until further notice ]]
	if(ThemeObject)then
		local t =  ThemeObject.Themes[theme];
		if(not t)then
			warn(tostring(theme).." was not found. Use .ExtendTheme to add a theme");
		else 
			return t;
		end;
		return;
	end;
	module.buildTheme();
	return module.useTheme(theme);
end;

function module.ThemeToggler()
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
		BackgroundColor3 = module.useTheme("Primary");
		IconColor3 = module.useTheme("Text");
		StrokeColor3 = module.useTheme("Text");
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
		BackgroundColor3 = module.useTheme("BackgroundLite");
		New "$Frame" {
			Name = "ContentContainer";
			Size = UDim2.fromOffset(0); 
			AutomaticSize = Enum.AutomaticSize.Y;
			New "UIListLayout" {
				-- CellSize = UDim2.new(1,0,0,25);
				-- CellPadding = UDim2.fromOffset(0,5);
				Padding = UDim.new(0,5);
			}
		};
	};

	for _,v in pairs(studioThemes) do
		local b = New "$Button" {
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
		if(showing)then ToolTipObject:Show(); else ToolTipObject:Hide();end;
	end);

	return Button;
end;

function module.getDefaultTheme()
	return ThemeDefault;
	--[[
	return PluginService:IsPluginMode() and 
	{
	
		Alert = Color3.fromRGB(233, 223, 81),
		Warning = Color3.fromRGB(240, 173, 78),
		Danger = Color3.fromRGB(217, 83, 79),
		Success = Color3.fromRGB(92, 184, 92),
		Info = Color3.fromRGB(91, 192, 222),
	
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
		-- FontSize = 16;
	}
	or {
		Alert = Color3.fromRGB(233, 223, 81),
		Warning = Color3.fromRGB(240, 173, 78),
		Danger = Color3.fromRGB(217, 83, 79),
		Success = Color3.fromRGB(92, 184, 92),
		Info = Color3.fromRGB(91, 192, 222),
		
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
		-- FontSize = 30;
	}
	
	-- local PluginService = require(script.Parent.Parent.Parent.Core.Services.PluginService);
	-- return ThemeDefault;
	]]
end;

--[[
function module.getCurrentTheme()
	local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
	if(PluginService:IsPluginMode())then
		local StudioTheme = settings().Studio.Theme;
		return {
			Primary = StudioTheme:GetColor(Enum.StudioStyleGuideColor.MainButton);
			Secondary = Color3.fromRGB(61, 66, 72);
			Disabled = Color3.fromRGB(44, 44, 44);
			Background = StudioTheme:GetColor(Enum.StudioStyleGuideColor.MainBackground);
			Text = StudioTheme:GetColor(Enum.StudioStyleGuideColor.MainText);
			Border = StudioTheme:GetColor(Enum.StudioStyleGuideColor.Border);
			Foreground = Color3.fromRGB(222, 233, 239);
			ForegroundText = Color3.fromRGB(30, 30, 30);
			--Font = settings().Studio.Font;
			Font = Enum.Font.SourceSans;
			FontSize = 16;
		}
	else
		return {
			Active = GlobalThemes.Primary;
			NonActive = Color3.fromRGB(43, 43, 43);
			Primary = GlobalThemes.Primary;
			Secondary = GlobalThemes.Secondary;
			Disabled = GlobalThemes.Disabled;
			Background = GlobalThemes.Background;
			Text = GlobalThemes.Text;
			Border = GlobalThemes.Border;
			Foreground = GlobalThemes.Foreground;
			ForegroundText = GlobalThemes.ForegroundText;
			Font = Enum.Font.SourceSans;
		}
	end
end;
]]


function module.getCurrentTheme()
	return module.getDefaultTheme();
end
return module