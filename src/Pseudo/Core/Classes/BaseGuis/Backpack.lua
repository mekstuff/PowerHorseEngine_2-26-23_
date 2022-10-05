local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local BackpackCreated = false;

local IdleColor = Color3.fromRGB(24, 24, 24);
local EquippedColor = Color3.fromRGB(163, 163, 163);

local Player;
local Char;
local Backpack;

local Backpack = {
	Name = "Backpack";
	ClassName = "Backpack";
	Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui");
	Enabled = true;
	HotbarDisplayAmount = 9;
	AutomaticallyEquip = true;
};
Backpack.__inherits = {}

local function createHUDButton(App)
	local Container = Instance.new("Frame");
	Container.BackgroundTransparency = 1;
	--Container.Size = UDim2.new(40,0,1,0)
	local Button = App.new("Button",Container);
	Button.ButtonFlexSizing = false;
	Button.Position = UDim2.fromScale(.5,.5);
	Button.AnchorPoint = Vector2.new(.5,.5);
	Button.Size = UDim2.fromScale(1,1);
	Button.ClickEffect = false;
	Button.BackgroundTransparency = .2;
	Button.BackgroundColor3 = IdleColor;
	Button.StrokeTransparency = 1;
	Button.IconAdjustment = App.Enumeration.Adjustment.Center;
	Button.TextAdjustment = App.Enumeration.Adjustment.Center;
	Button.TextScaled = true;
	--Button.TextSize = 12;
	Button.Text = "";
	
	--local Index = App.new("Text", Container);
	--Index.Name = "Index";
	--Index.Size = UDim2.fromScale(.15,.15);
	--Index.TextSize = 14;
	--Index.Position = UDim2.fromOffset(5,5);
	--Index.BackgroundTransparency = 1;
	--Index.Text = "1";
	--Index.StrokeTransparency = 1;
	
	local Index = App.new("Badge",Container);
	Index.Text = "1";
	Index.xAdjustment = Enumeration.Adjustment.Left;
	Index.BackgroundColor3 = Button.BackgroundColor3;
	Index.BackgroundTransparency = Button.BackgroundTransparency;
	
	Button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
		Index.BackgroundColor3 = Button.BackgroundColor3;
	end)
	
	return Container, Button, Index;
end;

local HUDItems = {};
local Hotbar;

local function searchHud(Tool)
	for index,v in pairs(HUDItems)do
		if(v.Tool == Tool)then return v,index;end;
	end;return false;
end;


function Backpack:_createHUDItem(Tool)
	if(searchHud(Tool))then return end;
	local App = self:_GetAppModule();
	local HUD,Button,Index = createHUDButton(App);
	Button.Icon = Tool.TextureId;
	HUD.Size = UDim2.new(0,Hotbar.Size.Y.Offset+3,1);
	
	Button.Icon = Tool.TextureId;
	Button.Text = Tool.TextureId == "" and Tool.Name or "";
	
	local function ArrangeHUDIndexes()
		for index,v in pairs(HUDItems)do
			v.Index.Text = tostring(index);
		end
	end;
	
	local Engine = App:GetGlobal("Engine");
	
	
	
	Button.MouseButton1Down:Connect(function()
		self:GetEventListener("EquipRequest"):Fire(Tool)
		if(self.AutomaticallyEquip)then
			Engine:FetchStorageEvent("Backpack_EquipCall"):FireServer(Tool)
		end;
	end);
	
	local function DragMode(InputObject)
		print(InputObject.UserInputType)
	end;
	local DragModeConnection;
	
	local IsMouseButtonPressed = false;
	
	HUD.Parent = Hotbar:GetGUIRef();
	
	table.insert(HUDItems, {
		Tool = Tool;
		Index = Index;
	});
	Index.Text = tostring(#HUDItems);
	
	
	local pc;
	pc = Tool:GetPropertyChangedSignal("TextureId"):Connect(function()
		Button.Icon = Tool.TextureId;
		Button.Text = Tool.TextureId == "" and Tool.Name or "";
	end);
	
	
	--Tool.Equipped:Connect(function()
	--	print("Equipped");
	--	Button:JiggleEffect();
	--	Button.BackgroundColor3 = EquippedColor;
	--end);
	
	--Tool.Unequipped:Connect(function()
	--	print("Unequippted");
	--	Button.BackgroundColor3 = IdleColor;
	--end)
	
	local cs;
	cs = Tool:GetPropertyChangedSignal("Parent"):Connect(function()
		
		if(Tool.Parent == Char)then
			print("ToolEquipped")
			Button:JiggleEffect();
			Button.BackgroundColor3 = EquippedColor;
		elseif(Tool.Parent ==  Backpack)then
			print("Unequipped");
			Button.BackgroundColor3 = IdleColor;
		else
			local obj,index = searchHud(Tool);
			obj = nil;
			HUD:Destroy();
			table.remove(HUDItems, index);
			ArrangeHUDIndexes();
			cs:Disconnect();cs=nil;pc:Disconnect();pc=nil;
			
		end
	end)
	
	
end;

function Backpack:_Render(App)
	
	assert(IsClient, "Backpacks can only be created by the client.");
	assert(BackpackCreated == false, "Tried to create second \"Backpack\". Only 1 Backpack can be created per client.");
	
	Player = game:GetService("Players").LocalPlayer;
	Char = Player.Character or Player.CharacterAdded:Wait();
	
	Backpack = Player:WaitForChild("Backpack");
	game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack,false);
	
	self:AddEventListener("EquipRequest",true);
	
	local BackpackPortal = App.new("Portal");
	BackpackPortal.ZIndex = 49;
	BackpackPortal.Name = "UserBackpack";
	BackpackPortal.Parent = self:GetRef();
	
	Hotbar = App.new("Frame")
	Hotbar.AnchorPoint = Vector2.new(.5,1);
	Hotbar.Position = UDim2.new(.5,0,1,-10);
	Hotbar.Size = UDim2.new(.75,0,0,45);
	Hotbar.BackgroundTransparency = 1;
	
	local Hotbar_Grid = Instance.new("UIListLayout");
	--Hotbar_Grid.f = UDim2.new(0,40,1,0);
	--Hotbar_Grid.CellPadding = UDim2.new(0,5);
	Hotbar_Grid.Padding = UDim.new(0,5);
	--Hotbar_Grid.VerticalAlignment = 
	Hotbar_Grid.FillDirection = Enum.FillDirection.Horizontal;
	Hotbar_Grid.HorizontalAlignment = Enum.HorizontalAlignment.Center;
	Hotbar_Grid.Parent = Hotbar:GetGUIRef();
	
	Hotbar.Parent = BackpackPortal:GetGUIRef();
	
	for _,v in pairs(Backpack:GetChildren()) do
		if(v:IsA("Tool"))then
			self:_createHUDItem(v);
		end
	end;
	
	self._dev.BackpackSignal = Backpack.ChildAdded:Connect(function(Child)
		if(Child:IsA("Tool"))then 
			--wait()
			self:_createHUDItem(Child);
			--print(#HUDItems);
		end;
	end)
	
	
	
	
	
	return {
		["Enabled"] = function(Value)
			BackpackPortal.Visible = Value;
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return Backpack
