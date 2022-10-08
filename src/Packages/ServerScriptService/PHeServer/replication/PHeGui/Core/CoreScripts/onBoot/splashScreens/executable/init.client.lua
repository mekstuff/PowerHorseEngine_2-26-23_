--//This will require PowerHorseEngine to be loaded in so players will experience a blank screen until then

local ReplicatedFirst = game:GetService("ReplicatedFirst");
local PHeClientBoot = script.PHeClientBoot;
PHeClientBoot.Parent = ReplicatedFirst;
script:Destroy();




local Player = game:GetService("Players").LocalPlayer;
local PlayerGui = Player:WaitForChild("PlayerGui");
local TempGui = Instance.new("ScreenGui",PlayerGui);
TempGui.IgnoreGuiInset = true
TempGui.DisplayOrder = 999;
TempGui.Name = "%Temp%PowerHorseEngine%";

local TempFrame = Instance.new("Frame",TempGui);
TempFrame.Size = UDim2.fromScale(1,1);
TempFrame.BorderSizePixel = 0;
TempFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255);

local PowerHorseEngineReady = game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine");
local PowerHorseEnginePseudoReady = PowerHorseEngineReady:WaitForChild("Pseudo");

local PowerHorseEngine = require(PowerHorseEngineReady);
local ConfigFile = PowerHorseEngine:GetGlobal("Engine"):RequestConfig();
local ConfigStartup = ConfigFile.Game.Startup;

if(ConfigStartup.disableStartup)then
	TempGui:Destroy();
	return;
end;
ReplicatedFirst:RemoveDefaultLoadingScreen();

local FadeTransition = PowerHorseEngine.new("FadeTransition");
FadeTransition.Color = ConfigStartup.StartupColor;
FadeTransition.ShowIndicator = true;
FadeTransition.Parent = PlayerGui;



wait(5);
TempGui:Destroy();


if(not game:IsLoaded())then
	game.Loaded:Wait();
end;
FadeTransition.ShowIndicator = false;


PHeClientBoot = require(PHeClientBoot);
if(PHeClientBoot.BeforeSplash)then
	PHeClientBoot.BeforeSplash(FadeTransition:GET("Frame"));
end


if(ConfigStartup.SplashScreen.Enabled)then
	local SplashScreenSequence = PowerHorseEngine:GetService("SplashScreenSequence");
	
	local frame = PowerHorseEngine.new("Frame");
	local Text = PowerHorseEngine.new("Text",frame);
	Text.Text = "This is an awesome demonstration :)"
	
	local Sequences = {
		{Logo = "rbxthumb://type=Asset&id=5144266065&w=420&h=420", Lifetime = 1}
	};
	for _,v in pairs(ConfigStartup.SplashScreen.Screens) do
		table.insert(Sequences,v);
	end;

	local SplashScreen = SplashScreenSequence.new(Sequences,FadeTransition.Color);
end;



if(PHeClientBoot.Booted)then
	PHeClientBoot.Booted(FadeTransition:GET("Frame"))
end


FadeTransition:Destroy();
