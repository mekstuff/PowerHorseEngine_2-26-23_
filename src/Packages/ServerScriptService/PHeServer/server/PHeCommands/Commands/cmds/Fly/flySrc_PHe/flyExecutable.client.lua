local Player = game.Players.LocalPlayer
local Char = Player.Character or Player.CharacterAdded:Wait();
local RootPart = Char:WaitForChild("HumanoidRootPart");

local RunService = game:GetService("RunService");

local Cam = workspace.CurrentCamera;

local bp = Instance.new("BodyPosition", Char)
bp.MaxForce = Vector3.new(0)
bp.D = 10
bp.P = 10000

local bg = Instance.new("BodyGyro", Char)
bg.MaxTorque = Vector3.new(0)
bg.D = 10
local flying = false;

local Speed = .5;

local function fly()
	flying = true
	bp.MaxForce = Vector3.new(400000,400000,400000)
	bg.MaxTorque = Vector3.new(400000,400000,400000)
	print("Flying")
	while flying do
		RunService.RenderStepped:wait()
		bp.Position = RootPart.Position +((RootPart.Position - Cam.CFrame.p).unit * Speed);
		bg.CFrame = CFrame.new(Cam.CFrame.p, RootPart.Position)
	end
end;

fly();