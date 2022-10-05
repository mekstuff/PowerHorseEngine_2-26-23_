local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local Vanilla_Core = require(script.Parent.Parent.Parent.Vanilla);
local Mouse = Vanilla_Core.Mouse;
local IsClient = game.Players.LocalPlayer;
local ProximityPromptsIdentifier = "ProximityPrompts[PHe]";

--local ClassStructure_Module = require(script.Parent.Parent.Parent.UserScripts.ClassStructure);
local globalClassStructureName = "ProximitivePrompts";


local ProximityPrompt = {
	Name = "ProximityPrompt";
	ClassName = "ProximityPrompt";
	AnchorPoint = Vector2.new(.5,1);
	Size = UDim2.fromOffset(30,30);
	BackgroundColor3 = Color3.fromRGB(211, 211, 211);

	Icon = "";
	ActionText = "Interact";
	ActionTextColor3 = Theme.getCurrentTheme().Text;
	ActionTextSize = 16;
	
	KeyTextColor3 = Color3.fromRGB(107, 107, 107);
	
	ActionTextAdjustment = Enumeration.Adjustment.Bottom;
	PromptOffset = Vector2.new(0);
	KeyCode = Enumeration.KeyCode.E;
	MaxActivationDistance = 10;
	RequiresLineOfSight = true;
	RequiresDirectInteraction = false;
	HoldDuration = 0;
	RetractionSpeed = .2;
	Exclusivity = Enumeration.Exclusivity.OnePerButton;
	Hidden = false;
	Disabled = false;
	--_ReplicatedToClients = false;
};
ProximityPrompt.__inherits = {"BaseGui"}


local PaddingSeperation = 5;

local RootPart;

if(IsClient)then
	local p = game:GetService("Players").LocalPlayer;
	local c = p.Character or p.CharacterAdded:Wait();
	RootPart = c:WaitForChild("HumanoidRootPart");
	
	p.CharacterAdded:Connect(function(Char)

		RootPart = Char:WaitForChild("HumanoidRootPart");
	end)
end

--//
--local Adornee;
local function getAdornee(from)
	
	
	if(not from)then return end;
	if(from:IsA("Model"))then
		if(from.PrimaryPart)then 
			return from.PrimaryPart;end;
	end;
	if(from:IsA("BasePart"))then return from;end

	return from:FindFirstChildWhichIsA("BasePart");

end;

--//

local function getSelfIsBestAdorneeFromSiblings(self,siblings,Magnitude)
	
	for _,v in pairs(siblings)do
		if(v ~= self)then
			if(self.Exclusivity ~= Enumeration.Exclusivity.AlwaysShow and not v.Hidden)then
				--if(self.Exclusivity ~= Enumeration.Exclusivity.AlwaysShow)then
				local LocalAdornee = getAdornee(v.Parent)
				if(LocalAdornee)then
					local dif = ((RootPart.Position - LocalAdornee.Position).Magnitude);
					if(Magnitude > dif)then
						return false;
					end
				end
			end;
		end;
	end;
	return true;
end;

local function getMagnitudeFromRootPart(magid,Mag)
	local totalmag = (magid.Position - RootPart.Position).Magnitude;

	local Pos, InView = workspace.CurrentCamera:WorldToScreenPoint(magid.Position);

	return totalmag, (totalmag <= Mag) , InView, Pos
end;

--//
local function connectUISINPUTEvents(self)
	if not(self._dev)then return end;
	local Button = self:GET("Button");
	if(not self._dev.__LISTENER_UIS_A)then	
		--print("Connected")
		self._dev.__LISTENER_UIS_A = game:GetService("UserInputService").InputBegan:Connect(function(Input)
			if(Input.KeyCode.Name == self.KeyCode.Name)then
				if(self.Disabled)then return end;
				Button._Signals["MouseButton1Down"]:Fire();
			end
		end);
	end;
	if(not self._dev.__LISTENER_UIS_B)then	
		self._dev.__LISTENER_UIS_B = game:GetService("UserInputService").InputEnded:Connect(function(Input)
			if(Input.KeyCode.Name == self.KeyCode.Name)then
				--if(self.Disabled)then return end;
				Button._Signals["MouseButton1Up"]:Fire();
			end
		end)
	end;
end;

--//
local function disconnectUISINPUTEvents(self)
	if not(self._dev)then return end;
	local Button = self:GET("Button");
	if(self._dev.__LISTENER_UIS_A)then
		self._dev.__LISTENER_UIS_A:Disconnect();
		self._dev.__LISTENER_UIS_A = nil;
		--print("Disconnected Listener: A");
	end
	if(self._dev.__LISTENER_UIS_B)then
		self._dev.__LISTENER_UIS_B:Disconnect();
		self._dev.__LISTENER_UIS_B = nil;
		--print("Disconnected Listener: B");
	end
	if(Button)then
		Button._Signals["MouseButton1Up"]:Fire();
	end;
end

--//
function ProximityPrompt:_onDestroyed()
	--wait(5);
	--disconnectUISINPUTEvents(self);
	--print(self._dev.__RenderSteppedCONNECTION);
end

--//
local function HideComp(self)
	if not(self._dev)then return end;
	
	--print("Hide?")
	--if(not IsClient)then return end;
	--local Component = self:GET();
	local ComponentRBX = self:GetGUIRef();
	--print(ComponentRBX)
	if(not ComponentRBX)then return end;
	if(ComponentRBX.Visible ~= false)then
		disconnectUISINPUTEvents(self); ComponentRBX.Visible = false;
		
			if(not self._dev._____firstlost)then self._dev._____firstlost = true;return;end;
			self:GetEventListener("ProximityLost"):Fire(); 
	end;	
end


--//
local function FireEvent(Event,Name)

	if(typeof(Event) == "Instance")then
		--print("Event Tosses To Server : "..Name)
		Event:FireServer();
	else
		Event:Fire(game.Players.LocalPlayer);
	end
end

--//

function ProximityPrompt:_Render(App)
	
	local MapSheet = {};
	local ClassStructure_Module = App:GetService("ClassStructure");

	local PromptContainer,PromptActionText,PromptButton,PromptIcon;
	
	local Engine = App:GetGlobal("Engine");
	local EnginelocalEventsFolder = Engine:FetchLocalEvents();
	--print("running from client? ", IsClient)
	
	
	local TriggeredEvent,TriggerEndedEvent,ProximityGained,ProximityLost;
	
	if(self._REPLICATED)then
		if(not IsClient)then
			
			TriggeredEvent = Instance.new("RemoteEvent");
			TriggerEndedEvent = Instance.new("RemoteEvent");
			TriggeredEvent.Name = "Triggered-"..self._REPLICATED;TriggerEndedEvent.Name = "TriggerEnded-"..self._REPLICATED;
			TriggeredEvent.Parent = EnginelocalEventsFolder;TriggerEndedEvent.Parent = EnginelocalEventsFolder;
			self:AddEventListener("Triggered",true,TriggeredEvent.OnServerEvent);
			self:AddEventListener("TriggerEnded",true,TriggerEndedEvent.OnServerEvent);
		else
			TriggeredEvent = EnginelocalEventsFolder:WaitForChild("Triggered-"..self._REPLICATED);
			TriggerEndedEvent = EnginelocalEventsFolder:WaitForChild("TriggerEnded-"..self._REPLICATED);
			--self:AddEventListener("Triggered",true,TriggeredEvent.OnServerEvent);
			--self:AddEventListener("TriggerEnded",true,TriggerEndedEvent.Event);
		end;
		
	else
		TriggeredEvent = self:AddEventListener("Triggered",true);
		TriggerEndedEvent = self:AddEventListener("TriggerEnded",true);
	end;
	
	
	self._dev.__TriggeredEvent = TriggeredEvent;
	self._dev.__TriggerEndedEvent = TriggerEndedEvent;


	
	if(IsClient)then
		local Plr = game:GetService("Players").LocalPlayer;
		local PlayerGui = Plr:WaitForChild("PlayerGui");
		local ProximityPrompts = PlayerGui:FindFirstChild(ProximityPromptsIdentifier);
		
		if(not ProximityPrompts)then
			local n = Instance.new("ScreenGui",PlayerGui);
			n.Name = ProximityPromptsIdentifier;
			n.ResetOnSpawn = false;
			ProximityPrompts=n;
		end;
		
		PromptContainer = Instance.new("Frame",ProximityPrompts);
		PromptContainer.BackgroundTransparency = 1;
		PromptContainer.AnchorPoint = Vector2.new(.5,1);
		PromptContainer.Position = UDim2.fromScale(.5,.5);

		PromptIcon = App.new("Image", PromptContainer);
		PromptIcon.AnchorPoint = Vector2.new(1,1);
		PromptIcon.ScaleType = Enum.ScaleType.Fit;
		PromptIcon.BackgroundTransparency = 1;
		PromptIcon.Size = UDim2.fromScale(.85,.85);
		
		PromptButton = App.new("Button",PromptContainer);
		PromptButton.Padding = Vector2.new(0,0);
		PromptButton.RippleStyle = Enumeration.RippleStyle.Static;
		PromptButton.Size = UDim2.fromScale(1,1);
		PromptButton.TextScaled = true;
		PromptButton.Text = "F";
		PromptButton.ButtonFlexSizing = false;
		PromptButton.AnchorPoint = Vector2.new(.5,.5);
		PromptButton.Position = UDim2.fromScale(.5,.5);
		PromptButton.StrokeTransparency = 0;
		PromptButton.StrokeThickness = 2;
		PromptButton.TextAdjustment = Enumeration.Adjustment.Center;
		PromptButton.Font = Enum.Font.GothamBold;
		PromptButton.TextSize = 30;
		
		PromptActionText = App.new("Text",PromptContainer);
		--PromptActionText.Position = UDim2.new(1,5,.5,0);
		--PromptActionText.AnchorPoint = Vector2.new(0,.5);
		PromptActionText.Size = UDim2.fromScale(.95,.75);
		PromptActionText.BackgroundTransparency = 1;
		PromptActionText.TextXAlignment = Enum.TextXAlignment.Left;
		PromptActionText.TextStrokeTransparency = .75;
		PromptActionText.Text = "ActionText";
		PromptActionText.Font = Enum.Font.GothamBold;
		
		local PromptButtonFill = Instance.new("Frame", PromptButton:GetGUIRef());
		PromptButtonFill.Size = UDim2.fromScale(1,0);
		PromptButtonFill.AnchorPoint = Vector2.new(0,1);
		PromptButtonFill.Position = UDim2.fromScale(0,1);
		PromptButtonFill.BorderSizePixel = 0;
		PromptButtonFill.BackgroundColor3 = Color3.new(1,1,1);
		PromptButtonFill.BackgroundTransparency = .35;
		
		local Adornee = getAdornee(self.Parent);
		

		local HoldBeganEvent = self:AddEventListener("HoldBegan", true);
		local HoldEndedEvent =  self:AddEventListener("HoldEnded",true);
		ProximityGained = self:AddEventListener("ProximityGained", true);
		ProximityLost =  self:AddEventListener("ProximityLost",true);
	
		
		PromptButton.MouseButton1Down:Connect(function()
			--print(self.__serverReplicated);
			local abs_ = PromptButton:GetAbsoluteSize();
			local s = UDim2.fromOffset(abs_.X,abs_.Y);
			--self:CreateTween(TweenInfo.new(.1), {Size = self.Size - UDim2.fromOffset(5,5)},ComponentRBX):Play();
			FireEvent(TriggeredEvent, self.Name)
			--TriggeredEvent:Fire();
		
			
			if(self.HoldDuration ~= 0 )then


				HoldBeganEvent:Fire();
				
				local Tween = self:CreateTween(TweenInfo.new(self.HoldDuration),{Size = UDim2.fromScale(1,1)}, PromptButtonFill);
				Tween:Play();
		
				Tween.Completed:Connect(function(State)
					if(State == Enum.PlaybackState.Completed)then
						PromptButton:JiggleEffect();
						--local AnimationTween = self:CreateTween(TweenInfo.new(.6,Enum.EasingStyle.Elastic), {Size = self.Size},ComponentRBX):Play();
						wait(.4);
						self:CreateTween(TweenInfo.new(self.RetractionSpeed),{Size = UDim2.fromScale(1,0)}, PromptButtonFill):Play();
						--TriggerEndedEvent:Fire();
						
						FireEvent(TriggerEndedEvent,self.Name);
					end
				end)
			else
				--print("Trigger")
				--TriggerEndedEvent:Fire();
				FireEvent(TriggerEndedEvent,self.Name);
			end



		end);
		PromptButton.MouseButton1Up:Connect(function()
			--ComponentRBX.Size = self.Size;
			--self:CreateTween(TweenInfo.new(.1), {Size = self.Size},ComponentRBX):Play();
			if(self.HoldDuration ~= 0 )then
				--HoldEndedEvent:Fire();
		
				--ProgressBar:CreateTween(TweenInfo_2, {Transparency = 1}):Play();
				self:CreateTween(TweenInfo.new(self.RetractionSpeed),{Size = UDim2.fromScale(1,0)}, PromptButtonFill):Play();
				--local Tween = ProgressBar:FillValue(0, self.RetractionSpeed);
			end

		end);
		
		MapSheet = {
			[PromptButton]={
				"BackgroundColor3",
			}
		}
		
		
		ClassStructure_Module:AddComponentToClassStructure(globalClassStructureName, self, self.KeyCode.Name);
	end;

	local function Run(Parent)
		local Adornee = getAdornee(Parent)
		if(Adornee and not self.Hidden)then
			--if(self._dev.__BLOCKCONNECTIONCUZDESTROY)then print("Blocked Connection") return end;
			if(not self._dev.__RenderSteppedCONNECTION)then
				
				--print("Connected");
				self._dev.__RenderSteppedCONNECTION = game:GetService("RunService").RenderStepped:Connect(function()
				
					if(not RootPart)then print("No Root Part For Player.") return end;
					if(not self._dev)then return;end;
					local Magnitude, WithinDistance, WithinLineOfSight, Pos = Core.getMagnitudeFromRootPart(Adornee, self.MaxActivationDistance);

					--< Lost Distance Or View
					if(not WithinDistance) or (self.RequiresLineOfSight and not WithinLineOfSight)then
							HideComp(self);
						return;
					end;

					if(self.RequiresDirectInteraction)then

						local Params = RaycastParams.new()
						Params.FilterType = Enum.RaycastFilterType.Blacklist;
						Params.FilterDescendantsInstances = {RootPart.Parent, Adornee.Parent};

						local rayCastResults = workspace:Raycast(RootPart.Position, (Adornee.Position - RootPart.Position).Unit*Magnitude, Params);
						if(rayCastResults)then
							HideComp(self);
							return;
						end
					end;

					if(self.Exclusivity == Enumeration.Exclusivity.OneGlobally)then
						local siblings = ClassStructure_Module:GetAllComponentsOfClass(globalClassStructureName, true);
						local currentisBest = getSelfIsBestAdorneeFromSiblings(self, siblings, Magnitude);
					
						if(not currentisBest)then
							HideComp(self);
							return;
						end

					elseif(self.Exclusivity == Enumeration.Exclusivity.OnePerButton)then
						local siblings = ClassStructure_Module:GetAllComponentsOfStructureID(globalClassStructureName, self.KeyCode.Name);
						local currentisBest = getSelfIsBestAdorneeFromSiblings(self, siblings, Magnitude);
						
						if(not currentisBest)then
							HideComp(self);
							return;
						end
					end;

					if(PromptContainer.Visible ~= true)then
						PromptContainer.Visible = true;PromptButton:JiggleEffect();
				
						ProximityGained:Fire();
					end;	

					PromptContainer.Position = UDim2.fromOffset(Pos.X,Pos.Y+PromptContainer.AbsoluteSize.Y/2) + UDim2.fromOffset(self.PromptOffset.X,self.PromptOffset.Y) + (self.Icon ~= "" and UDim2.fromOffset(PromptIcon:GetAbsoluteSize().X,PromptIcon:GetAbsoluteSize().Y) or UDim2.new(0))
					if(self)then
						connectUISINPUTEvents(self);
					end;

				end);
			end
		else
			if(self._dev.__RenderSteppedCONNECTION)then
				self._dev.__RenderSteppedCONNECTION:Disconnect();
				self._dev.__RenderSteppedCONNECTION = nil;
			end;disconnectUISINPUTEvents(self);if(PromptContainer.Visible ~= false)then PromptContainer.Visible = false; end;
		end;
	end
	

	return {
		["Size"] = function(Value)
		 if(IsClient)then PromptContainer.Size = Value; end;
		end,
		["ActionText"] = function(val)
			if(IsClient)then PromptActionText.Text = val;end;
		end,
		["ActionTextSize"] = function(val)
			if(IsClient)then PromptActionText.TextSize = val;end;
		end,
		["ActionTextColor3"] = function(val)
			if(IsClient)then 
				PromptActionText.TextColor3 = val;
			end;
		end,
		["Icon"] = function(Value)
			if(IsClient)then
				PromptIcon.Image = Value;	
			end;
		end,
		["ActionTextAdjustment"] = function()
			if(IsClient)then	
				if(self.ActionTextAdjustment == Enumeration.Adjustment.Bottom)then
					PromptActionText.AnchorPoint = Vector2.new(.5);
					PromptActionText.TextXAlignment = Enum.TextXAlignment.Center;
					PromptActionText.Position = UDim2.new(.5,0,1,PaddingSeperation/2);
				elseif(self.ActionTextAdjustment == Enumeration.Adjustment.Top)then
					PromptActionText.TextXAlignment = Enum.TextXAlignment.Center;
					PromptActionText.AnchorPoint = Vector2.new(.5,1);
					PromptActionText.Position = UDim2.new(.5,0,0,-PaddingSeperation);
				elseif(self.ActionTextAdjustment == Enumeration.Adjustment.Right)then
					PromptActionText.AnchorPoint = Vector2.new(0,.5);
					PromptActionText.TextXAlignment = Enum.TextXAlignment.Left;
					PromptActionText.Position = UDim2.new(1,PaddingSeperation,.5);
				elseif(self.ActionTextAdjustment == Enumeration.Adjustment.Left)then
					PromptActionText.AnchorPoint = Vector2.new(1,.5);
					PromptActionText.TextXAlignment = Enum.TextXAlignment.Right;
					PromptActionText.Position = UDim2.new(0,-PaddingSeperation,.5) ;
				end
			end;
		end,
		["KeyTextColor3"] = function(Value)
			if(IsClient)then
				PromptButton.TextColor3 = Value;
				PromptButton.StrokeColor3 = Value;
			end;
		end,
		["KeyCode"] = function(Value)
			if(not IsClient)then return end;
			--print(Value);
			PromptButton.Text = Value.Name;
		end,
		["*Parent"] = function(Value)	
			if(IsClient)then
				Run(Value);
			end;
		end,
		["Hidden"] = function(Value)
			if(IsClient)then
				Run(self.Parent);
			end;
		end,
		
		_Components = IsClient and {FatherComponent = PromptContainer,Button = PromptButton};
		_Mapping = MapSheet;
	};
end;


return ProximityPrompt
