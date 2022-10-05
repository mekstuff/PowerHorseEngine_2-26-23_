local CustomClassService = require(script.Parent.Parent.Services.CustomClassService);
local TweenService = game:GetService("TweenService");

local Camera = workspace.CurrentCamera;

--[=[
:::caution
	You must use [GlobalProvider]:GetGlobal("Cutscene") to retrieve this module
	NOT [GlobalProvider]:GetGlobal("CutsceneConstructor")
	"CutsceneConstructor" is used for documentation purposes.
:::
@tag Global
@class CutsceneConstrctor
]=]
local Cutscene = {}

--[=[
@class Cutscene
]=]
local Cutscene = {
	ClassName = "Cutscene";
	CFrame = CFrame.new(Vector3.new(0));
	Speed = 1;
	EasingStyle = Enum.EasingStyle.Linear;
	EasingDirection = Enum.EasingDirection.Out;
	Lifetime = 10;
	TargetCamera = Camera;
};
--[=[
@prop CFrame CFrame
@within Cutscene
The CFrame that the cutscene will reach
]=]

function Cutscene:_Render()
	return {};
end

--function Cutscene:PauseScene()
--	self._tween:Pause();
--end

--[=[
Plays the cutscene

@within Cutscene
]=]
function Cutscene:PlayScene()
	print("Playing scene")
	if(self.TargetCamera.CameraType ~= Enum.CameraType.Scriptable)then
		self.TargetCamera.CameraType = Enum.CameraType.Scriptable;
		--repeat wait() until self.TargetCamera.CameraType == Enum.CameraType.Scriptable;
	end
	local Tween = TweenService:Create(self.TargetCamera, TweenInfo.new(self.Speed,self.EasingStyle,self.EasingDirection), {CFrame = self.CFrame})
	Tween:Play();	
	self._tween = Tween;
	return Tween;
end;

--[=[
Constructor for creating a new cutscene
@within CutsceneConstrctor
@return Cutscene
]=]
function Cutscene.new(CFrame_:CFrame,Speed_:number,EasingStyle_:TweenInfo,EasingDirection_:TweenInfo,Lifetime_:number)
	local x = CustomClassService:Create(Cutscene);
	x.CFrame = CFrame_ or x.CFrame;x.Speed = Speed_ or x.Speed;x.EasingStyle = EasingStyle_ or x.EasingStyle;x.EasingDirection = EasingDirection_ or x.EasingDirection;
	x.Lifetime = Lifetime_ or x.Lifetime;
	return x;
end;

return Cutscene
