local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
--local Erro
local IsClient = game:GetService("RunService"):IsClient();
local TweenService = game:GetService("TweenService");

local MaximumPromptLevel = 999;

local LocalPlayer = game.Players.LocalPlayer;
local PlayerGui = LocalPlayer and LocalPlayer:WaitForChild("PlayerGui");

--print("Remember to create a Destroyed event listener and clear promptlist when object destroyed for garbagecollection");

local Prompt = {
	Name = "Prompt";
	ClassName = "Prompt";
	Level = 1;
	--ModalSize = Vector2.new(350,300);
	--Blurred = true;
	--Highlighted = true;
	Header = "Prompt";
	StartPosition = UDim2.fromScale(.5,.5);
	StartAnchorPoint = Vector2.new(.5,.5);
	DestroyOnOverride = false;
	
	--StandAlone = false;
	PromptClass = "Main";
	
	--Showing = false;
	--HeaderAdjustment = Enumeration.Adjustment.Left;
	--Roundness = UDim.new(0);
};

local PromptList = {};
local CurrentPrompt;
local CurrentPromptDestroyedListener;

Prompt.__inherits = {"Modal","GUI","BaseGui"}

local function showModal(Modal,self)
	Modal.Blurred = self.Blurred;Modal.Highlighted = self.Highlighted;
	Modal.Visible = true;
end;
local function hideModal(Modal,blurred,highlighted)
	Modal.Blurred = false;Modal.Highlighted = false;
	--Modal.Visible = false;
end;

local function getAmount(t)
	local i = 0;
	for _,_ in pairs(t)do
		i+=1;
	end;
	return i;
end

local function MatchAnchorAndPos(self)
	--print((self.AnchorPoint == self.StartAnchorPoint) == true and (self.Position == self.StartPosition) == true);
	--print(self.AnchorPoint,self.StartAnchorPoint,self.Position,self.StartPosition)
	--if(self.AnchorPoint == self.StartAnchorPoint and self.Position == self.StartPosition)then return true else return false end;
	return ( (self.AnchorPoint == self.StartAnchorPoint) == true and (self.Position == self.StartPosition) == true ) and true or false;
end

function Prompt:Show()
	
	if(self._showing)then return end;
	
	if(CurrentPrompt and not CurrentPrompt._dev)then
		CurrentPrompt=nil;
	end
	
	if(CurrentPrompt and CurrentPrompt ~=self)then
			if(CurrentPrompt.PromptClass == self.PromptClass)then
				-- print("Got Here")
				if(CurrentPrompt.Level <= self.Level)then
					
						if(CurrentPrompt.DestroyOnOverride == true)then
							CurrentPrompt:Destroy(true);
						else
							CurrentPrompt:Hide(true)
						end
			
				--end;
				--CurrentPrompt:Hide(true, CurrentPrompt.DestroyOnOverride);
				--print("Override")
			else
					
				--print("Can't Show yet, current prompt has higher level!");
				return;
			end
		end;
	end;
	self._showing = true;
	CurrentPrompt = self;
	local Modal = self:GET("Modal");
	showModal(Modal,self)
	-- Modal.Visible = true; 
	--Modal.Position = self.StartPosition;
	--Modal.AnchorPoint = self.StartAnchorPoint;
	local ModalGUIRef = Modal:GetGUIRef();
	local m = MatchAnchorAndPos(self);

	if not(MatchAnchorAndPos(self))then
		ModalGUIRef.Position = self.StartPosition;ModalGUIRef.AnchorPoint = self.StartAnchorPoint;
		TweenService:Create(ModalGUIRef, TweenInfo.new(self._tweenSpeed), {Position = self.Position,AnchorPoint = self.AnchorPoint}):Play();
	end;	
end;

function Prompt:SetTweenSpeed(Speed:number)
	self._tweenSpeed = Speed;
end;

function Prompt:Hide(DontLookForOthers,Destroy)
	--if(CurrentPrompt == self)then CurrentPrompt=nil;end;
	--if(self._dev._destroyedfromhide == true)then return end;
	if(not self._showing)then return end;
	self._showing = false;
	self._watingfordestroy = Destroy;
	local Modal = self:GET("Modal");
	
	if(CurrentPrompt == self)then
		CurrentPrompt = nil;
	end
	
	local function showNext()
	--[[
		if(not DontLookForOthers)then
		--print(PromptList)
			for _,v in pairs(PromptList) do
				if(v~= self and v and v.Show)then
					v:Show();break;
				end
			end
		end;
	]]
		
		if(not DontLookForOthers)then
			local highestlevel = 0;
			local t;
			for _,v in pairs(PromptList) do
				if(v~= self and v and v._dev and v.Visible)then
					if(v.Level >= highestlevel and v.PromptClass == self.PromptClass)then
						
						t = v;
					end
				end
			end;
			if(t)then
				--print("Found a suitable one!");
		
				t:Show();
			end
		end
	end;
	hideModal(Modal)
	
	
	if(Modal and Modal._dev)then
		if not(MatchAnchorAndPos(self))then
			local ModalGUIRef = Modal:GetGUIRef();
			local t = TweenService:Create(ModalGUIRef, TweenInfo.new(self._tweenSpeed), {Position = self.StartPosition,AnchorPoint = self.StartAnchorPoint});
			t:Play();
			self._dev._tComp = t.Completed:Connect(function(State)
				if not(self._dev)then return end;
				self._dev._tComp:Disconnect();
				self._dev._tComp = nil;
				if(Destroy)then
					--self.ButtonClicked:Fire(nil,"override")
					self:GetRef():Destroy();
				end
				if(State == Enum.PlaybackState.Completed)then
					Modal.Visible = false;
				end
				showNext();
				--print("Calling show next from A");
			end);
		else
			if(Destroy)then
				--print("Print Destroying Component")
				--self.ButtonClicked:Fire(nil,"override")
				self:GetRef():Destroy();
			else
				Modal.Visible = false;
			end;
		--print(CurrentPrompt == self)
			showNext();
			--print("Calling show next from B");
		end;
	end;
end;

--//
function Prompt:AddButton(...)
	return self:GET("Modal"):AddButton(...);
end;
function Prompt:CaptureUserFocus(...)
	return self:GET("Modal"):CaptureUserFocus(...);
end;
--//
function Prompt:Yield(destroyOnEnded)
	if(not self:GET("Modal")._dev.__btns and not self.CloseButtonVisible )then 
		self:_GetAppModule():GetService("ErrorService").tossWarn("Called \"Yield()\" On "..self.Name.." That Doesn't Contain Any Buttons. Thread will yield indefinitely.");
	end;
	local btn,id = self.ButtonClicked:Wait();
	
	if(destroyOnEnded)then
		self:Destroy();		
	end
	return not destroyOnEnded and btn,id;
end
--//
function Prompt:Destroy(DontEnableOthers)	
	if(self._showing)then

		PromptList[self._dev.__id] = nil;
		if(CurrentPrompt == self)then CurrentPrompt = nil;end;
		self:Hide(DontEnableOthers,true);
	else
		if(self._watingfordestroy)then
			--print("GOnna destroy so wait");
		else
			pcall(function()
				self:GetRef():Destroy();
			end)
			-- print(self._dev);
		end
		
	end;
end

--//
function Prompt:OnHighlightClicked(...)
	return self:GET("Modal"):OnHighlightClicked(...);
end

--//
function Prompt:_Render(App)
	
	if(not IsClient)then return {};end;
	
	self._tweenSpeed = .65;

	if(App:GetService("PluginService"):IsPluginMode())then
		self.ButtonsAdjustment = Enumeration.Adjustment.Right;
	end
	--local s = tick();
	local Modal = App.new("Modal");
	--print("took ", tick()-s)
	
	Modal:GetPropertyChangedSignal("Destroying"):Connect(function()
		if(self and self._dev)then
			self:Destroy() --< Destroy self if the modal was destroyed (from close btn)
		end;
	end)
	
	Modal.Blurred=false;Modal.Highlighted=false;Modal.Visible=false;
	Modal.Parent = self:GetRef();
	PromptList[self._dev.__id] = self;
	self._showing = false;
--[[
	self._dev._descendantAddedConnectionA = Modal:GET("Center").DescendantAdded:Connect(function(descendant)
		local PseudoService = App:GetService("PseudoService");
		if(descendant.Name == "_pseudoid")then
			local id = descendant.Value;
			local Pseudo = PseudoService:GetPseudoFromId(id);
			if(Pseudo and Pseudo:IsA("Text"))then
				Pseudo.TextColor3 = Theme.getCurrentTheme().ForegroundText;
				Pseudo.TextSize = self.HeaderTextSize-4;
			end
		end
	end)
	]]
	--[[
	self.ChildAdded:Connect(function(child)
		--print(child:IsA("Text") and child.Text or "not text");
		--print(child:IsA("Text"));
		if(child:IsA("Text"))then
			child.TextColor3 = Theme.getCurrentTheme().ForegroundText;
		end
	end)
	]]
	--Modal.Position = self.StartPosition;
	--Modal.AnchorPoint = self.StartAnchorPoint;
	
	--local ModalGUIRef = Modal:GetGUIRef();
	--ModalGUIRef.Posi
	
	self._Components["Modal"] = Modal;
	
	local firstLapse=true;
	
	local level = self._dev.args and self._dev.args[2] or self.Level;
	local notVisible = self._dev.args and self._dev.args[1] == false;
	
	
	if(level ~= self.Level)then
		if(level == true)then
			self.Level = CurrentPrompt and CurrentPrompt.Level+1 or 1;
		else
			self.Level = level;
		end

	end
	

	--local ModalContainer = Modal:GET("ModalContainer");
	--local LineBreakA = App.new("LineBreak");
	--LineBreakA.Name = "B";
	--LineBreakA.Parent = ModalContainer;
	
	self:AddEventListener("ButtonClicked",true,self:GET("Modal"):GetEventListener("ButtonClicked"));
	self:AddEventListener("ButtonAdded",true,self:GET("Modal"):GetEventListener("ButtonAdded"));
	
	
	--self:Show();
--[[	
	self._dev.___propchngsigdes = self:GetPropertyChangedSignal("Destroying"):Connect(function(id)
		--if(cur)
		PromptList[id]:Hide()
		PromptList[id]=nil;
		--if(CurrentPrompt == self)then
			--self:Hide();
		--end
	end);
]]	

self:GetRef().AncestryChanged:Connect(function()
	local hasGameModelAncestry = self:GetRef():FindFirstAncestorOfClass("DataModel");
	if(hasGameModelAncestry)then
		if(self.Visible and not self._showing)then self:Show();end;
	else
		if(self._showing)then self:Hide();end;
	end
end)
	
	Modal._dev._closebuttonconnection:Disconnect();Modal._dev._closebuttonconnection = nil; --< disables modal close button behaviour
	Modal:GET("CloseButton").Activated:Connect(function() --< Creates a custom close button behaviour for prompts
		self.ButtonClicked:Fire(Modal:GET("CloseButton"), "close");
		if(self.CloseButtonBehaviour == Enumeration.CloseButtonBehaviour.Hide)then
			self.Visible = false;
		elseif(self.CloseButtonBehaviour == Enumeration.CloseButtonBehaviour.Destroy)then
			self:Destroy();
		end
	end)
	return {
		["Level"] = function(Value)
			if(Value > MaximumPromptLevel and not self._isPHEPROMPTOBEJ_ECT)then
				App:GetService("ErrorService").tossWarn("Maximum Prompt level reach "..tostring(MaximumPromptLevel)..". ["..self.Name..".Level = "..tostring(Value).."] Failed, Defaulted To ("..MaximumPromptLevel..")")
				self:_RenderOnStep(function()
					self.Level = MaximumPromptLevel;
				end);
			else
				if(CurrentPrompt and CurrentPrompt ~= self and self.Parent and self.Visible)then
					self:Show();
				end;
			end;
		end,
		["Visible"] = function(Value)
			local a=false;
			if(firstLapse and notVisible)then
				firstLapse=false;
				a=true;
				print("Don't show")
				self:Hide();
				return;
			end;
			if(Value)then
				if(self.Parent and self.Parent:FindFirstAncestorOfClass("DataModel"))then
					self:Show();
				end;
			else
				self:Hide();
			end
		end,
		["*Parent"] = function(Value)
			-- if(Value:FindFirstAncestorOfClass("DataModel") and self.Visible)then
				-- self:Show();
			-- end
			-- if(Value and Value:FindFirstAncestorOfClass("DataModel") and self.Visible)then
			-- 	self:Show();
			-- end
		end,
		["Blurred"] = function(v)
			if(self._showing)then
				self:GET("Modal").Blurred=v;
			end
		end,["Highlighted"] = function(v)
			if(self._showing)then
				self:GET("Modal").Highlighted=v;
			end
		end,
	
		_Components = {
			Modal = Modal;
			Header = Modal:GET("Header");
			CloseButton = Modal:GET("CloseButton");
			_Appender = Modal:GET("_Appender");
			FatherComponent = Modal:GetGUIRef();
		};
		_Mapping = {
			[Modal]={
				"StrokeTransparency",
				"StrokeColor3",
				"StrokeThickness",
				"BackgroundTransparency",
				"BackgroundColor3",
				"Size",
				--"Position",
				--"AnchorPoint",
				"Roundness",
				"Header",
				"HeaderIcon","HeaderTextColor3",
				"HeaderTextSize","BodyTextSize",
				"ButtonsAdjustment","HeaderAdjustment",
				-- "ModalSize",
				"ButtonsScaled",
				"Body",
				"CloseButtonBehaviour",
				"ZIndex"
			}	
		};
	}
	
end;


return Prompt