local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);

local __PHeImage = "rbxasset://textures/loading/robloxTilt.png";

local TweenService = game:GetService("TweenService");
local a_zLowercase = {};
local z_aLowercase = {};
for i = 27,((27*2)-2) do
	table.insert(a_zLowercase, Core.ASCIICharsSupported[i]);
end;
for _,v in pairs(a_zLowercase) do
	table.insert(z_aLowercase,v);
end;Core.InverseTable(z_aLowercase);

--[=[
	@class NotificationGroup
]=]

local NotificationGroup = {
	Name = "NotificationGroup";
	ClassName = "NotificationGroup";
	DefaultNotificationPriority = Enumeration.NotificationPriority.Low;
	DefaultNotificationLifetime = -1;
	ContentAdjustment = Enumeration.Adjustment.Left;
	SortOrderAdjustment = Enumeration.Adjustment.Bottom;
	FillDirectionAdjustment = Enumeration.Adjustment.Bottom;
	Padding = UDim.new(0,5);
	Position = UDim2.new(0, 5, 1, -5);
	AnchorPoint = Vector2.new(0,1);
	Size = UDim2.new(0, 300, 1, -36-10);
	NotificationAnimationStyle = Enumeration.NotificationAnimationStyle.Slide;
	BackgroundTransparency = 1;
};

--[=[
	@prop DefaultNotificationPriority Enumeration.NotificationPriority
	@within NotificationGroup
]=]
--[=[
	@prop DefaultNotificationLifetime number
	@within NotificationGroup
	Set to -1 for infinite Notification
]=]
--[=[
	@prop ContentAdjustment Enumeration.Adjustment
	@within NotificationGroup
]=]
--[=[
	@prop SortOrderAdjustment Enumeration.Adjustment
	@within NotificationGroup
]=]
--[=[
	@prop FillDirectionAdjustment Enumeration.Adjustment
	@within NotificationGroup
]=]
--[=[
	@prop Padding UDim
	@within NotificationGroup
]=]
--[=[
	@prop Position UDim2
	@within NotificationGroup
]=]
--[=[
	@prop AnchorPoint Vector2
	@within NotificationGroup
]=]
--[=[
	@prop Size UDim2
	@within NotificationGroup
]=]
--[=[
	@prop NotificationAnimationStyle Enumeration.NotificationAnimationStyle
	@within NotificationGroup
]=]
--[=[
	@prop BackgroundTransparency number
	@within NotificationGroup
]=]

NotificationGroup.__inherits = {"BaseGui","Frame"}

--//
local NotificationMethods = {};

function NotificationMethods:RemoveSubNotification(id)
	for index,v in pairs(self._subNotifications)do
		if(v.id == id)then
			table.remove(self._subNotifications,index);
			--break;
		end
	end;
	if(not self._collapsed)then
		for index,v in pairs(self._tempNotifications)do
			if(v.id == id)then
				v.n:Dismiss();
				table.remove(self._tempNotifications,index);
				--break;
			end
		end
	end
end

function NotificationMethods:GetSubNotification(id)
	for index,v in pairs(self._tempNotifications)do
		if(v.id == id)then
			return v.n;
		end
	end
end

function NotificationMethods:SendNotification(...)
	return self:Notify(...)
end;

function NotificationMethods:Notify(id,...)
	if(not id)then id = math.random(1,1000);end;
	return self:_handleSubNotification("ntfy",id,...);
end;


function NotificationMethods:_handleSubNotification(type_,id,...)
	local NotificationContainer = self.ElementRBX;
	
	local Pseudo = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
	
	local Badge = Pseudo.new("Badge",NotificationContainer);
	Badge.Text = "1";
	--lastNotification.toast._dev.badge = Badge;
	print(self._subNotifications)
	table.insert(self._subNotifications, {
		dotdotdot = {...}; --lol
		type_ = type_;
		id = id;
	});
	
	
	
	if(not self._tempNotifications)then self._tempNotifications = {};end;
	
	
	--print(self._subNotifications);
	
	if(not self._inputBeganEvent)then
		self._inputBeganEvent = NotificationContainer.InputBegan:Connect(function(InputObject)
			if(InputObject.UserInputType == Enum.UserInputType.MouseButton1)then
				self._collapsed = not self._collapsed;

				if(not self._collapsed)then
					--local OriginalPriority = self.Priority;
					--self.Priority = Enumeration.NotificationPriority.High;
					self.Pinned = true;
					local n;
					Badge.Visible = false;
					Badge.Text = tostring(#self._subNotifications);
					--print(self.NotificationGroup);
					for index,v in pairs(self._subNotifications) do

						if(v.type_ == "ntfy")then
							n = self.NotificationGroup:Notify(unpack(v.dotdotdot));
						else
							n = self.NotificationGroup:SendNotification(unpack(v.dotdotdot))
						end

						--local n = self.NotificationGroup:Notify("This is a test "..tostring(index));
						table.insert(self._tempNotifications, {n =n, id=v.id});
						n.Pinned=true;
						n.Priority = self.Priority;
						--NotificationGroup:SendNotification(..)
					end;
					local CollapseNotification = Instance.new("Frame");
					CollapseNotification.Size = UDim2.new(0,40,0,30);
					CollapseNotification.BackgroundTransparency = 1;
					local Button = Pseudo.new("Button",CollapseNotification)
					Button.Position = UDim2.fromScale(.5,.5);
					Button.AnchorPoint = Vector2.new(.5,.5);
					Button.Size = UDim2.new(.9,0,.9,0)
					Button.ButtonFlexSizing = false;
					Button.TextScaled = true;
					Button.BackgroundTransparency = 1;
					Button.StrokeTransparency = 1;
					Button.TextAdjustment = Enumeration.Adjustment.Center; 
					Button.Text = "^";
					Button.RippleStyle = Enumeration.RippleStyle.None;

					local CollapseBtnBNotification = self.NotificationGroup:SendNotification(CollapseNotification);
					CollapseBtnBNotification.Pinned=true;
					CollapseBtnBNotification.Priority = self.Priority;

					Button.MouseButton1Down:Connect(function()
						--self.Priority = OriginalPriority;
						CollapseBtnBNotification:Dismiss();
						Badge.Visible = true;
						if(self._tempNotifications)then
							for _,x in pairs(self._tempNotifications)do
								x.n:Dismiss();
							end;
							self._tempNotifications = {};
						end;
						self._collapsed=true;
					end);

				end

			end;
		end);
	end
	
	
	
end

function NotificationMethods:LinkDismissToNotification(t)
	if(t.Dismissed)then
		local e
		e = t.Dismissed:Connect(function()
			if(e)then e:Disconnect();e=nil;end;
			if(self and self.Dismiss)then
				--wait();
				self:Dismiss();
			end;

		end)
	end
end;

--//
function NotificationMethods:Sort(NotificationGroupObject)

	local String = "";

	local TargetTable = z_aLowercase;
	-- local TargetTable = NotificationGroupObject.SortOrderAdjustment == Enumeration.Adjustment.Top and a_zLowercase or z_aLowercase;
	-- local TargetTable = NotificationGroupObject.FillDirectionAdjustment == Enumeration.Adjustment.Bottom and a_zLowercase or z_aLowercase;

	if(self.Pinned)then
		String = TargetTable[1];
	else
		String = TargetTable[2];
	end;

	local PriorityNumber = self.Priority.prNumber;
	if(not PriorityNumber)then PriorityNumber = 1;end;
	String = String..(TargetTable[PriorityNumber]);


	self.ElementContainer.Name = String;
end;

--//
function NotificationMethods:AnimateEntry(TweenInfo_)
	local ElementRBX = self.ElementRBX;


	if(self.NotificationAnimationStyle == Enumeration.NotificationAnimationStyle.Slide)then


		--print(self.NotificationGroupRBX.AbsolutePosition);

		local x,y = Core.getRelativePositionInViewport(self.NotificationGroupRBX.AbsolutePosition, self.NotificationGroupRBX.AbsoluteSize);

		local offscreenpos = -1;

		if(x == Enumeration.Adjustment.Right)then
			offscreenpos = 2;
		end;



		ElementRBX.Position = UDim2.new(offscreenpos);
		TweenService:Create(ElementRBX, TweenInfo_ or TweenInfo.new(.2), {Position = UDim2.new(0)}):Play();
	end;

end;
--//
function NotificationMethods:Dismiss(...) self._FadeChildren=nil;self:AnimateExit(true,nil,...); end;
--//
function NotificationMethods:_FetchFadeChildren()
	local ElementContainer = self.ElementContainer;
	if(self._FadeChildren)then return self._FadeChildren;end;
	if(not self._FadeChildren)then
		self._FadeChildren = {};
		for _,v in pairs(ElementContainer:GetDescendants()) do
			if(v:IsA("Frame"))then
				self._FadeChildren[v]={
					Animate = "BackgroundTransparency";
					Default = v.BackgroundTransparency;
				};
			elseif(v:IsA("TextLabel"))then
				self._FadeChildren[v]={
					Animate = "TextTransparency";
					Default = v.TextTransparency;					
				};
			end;
		end;
	end;
	return self._FadeChildren;
end
--//

function NotificationMethods:FadeOut(Speed)
	Speed = Speed or 1;
	local FadeChildren = self:_FetchFadeChildren();
	for element,data in pairs(FadeChildren)do
		TweenService:Create(element, TweenInfo.new(Speed), {[data.Animate] = 1}):Play();
	end
end;


--//
function NotificationMethods:FadeIn(Speed)
	Speed = Speed or 1;
	local FadeChildren = self:_FetchFadeChildren()
	
	for element,data in pairs(FadeChildren)do
		TweenService:Create(element, TweenInfo.new(Speed), {[data.Animate] = data.Default}):Play();
	end
	--for _,v in pairs()
end
--//
function NotificationMethods:AnimateExit(Destroy,TweenInfo_,...)
	local ElementRBX = self.ElementRBX;

	local t;

	if(self.NotificationAnimationStyle == Enumeration.NotificationAnimationStyle.Slide)then
		local x,y = Core.getRelativePositionInViewport(self.NotificationGroupRBX.AbsolutePosition, self.NotificationGroupRBX.AbsoluteSize);

		local offscreenpos = -2;

		if(x == Enumeration.Adjustment.Right)then
			offscreenpos = 1.5;
		end
		t = TweenService:Create(ElementRBX, TweenInfo_ or TweenInfo.new(.2), {Position = UDim2.new(offscreenpos)});
		t:Play();
	end;

	local function cleanup()
		local ended = TweenService:Create(self.ElementContainer, TweenInfo.new(.2), {Size = UDim2.new(1)});
		ended:Play();
		local cn;
		cn = ended.Completed:Connect(function() cn:Disconnect(); cn=nil; self.ElementContainer:Destroy();end);
	end;

	if(Destroy)then
		self.__DismissedEvent:Fire(...);
		if(t)then
			t.Completed:Connect(function()
				cleanup();
			end)
		else
			cleanup();
		end
	end
end;

--//
function NotificationGroup:SendNotification(Element, Priority, AnimationStyle, Lifetime)
	--
	

	local newNotification = {};
	if(not Element)then Core.tossWarn("__sendnotificationfailed__"); return end;



	Priority = Priority or self.DefaultNotificationPriority;
	Lifetime = Lifetime or self.DefaultNotificationLifetime;
	
	AnimationStyle = AnimationStyle or self.NotificationAnimationStyle;

	local NotificationContainer = Instance.new("Frame");
	NotificationContainer.BackgroundTransparency = 1;
	
	Element.Parent = NotificationContainer;

	local ElementRBX = Core.getElementObject(Element);
	--NotificationContainer.Size = UDim2.new(1,0,0,ElementRBX.AbsoluteSize.Y)
	--NotificationContainer.Size = UDim2.fromOffset(ElementRBX.AbsoluteSize.X,ElementRBX.AbsoluteSize.Y);
	NotificationContainer.AutomaticSize = Enum.AutomaticSize.XY;
--[[
	ElementRBX:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		NotificationContainer.Size = UDim2.new(1,0,0,ElementRBX.AbsoluteSize.Y)
	end)
]]
	
	newNotification._subNotifications = {};
	newNotification._collapsed = true;


	newNotification.ElementContainer = NotificationContainer;
	newNotification.ElementRBX = ElementRBX;
	newNotification.NotificationAnimationStyle = AnimationStyle;
	newNotification.NotificationGroup = self;
	--newNotification.AdjustContentsCenter = self.AdjustContentsCenter;
	newNotification.NotificationGroupRBX = self:GetGUIRef();
	local NotificationDismissedEvent = Instance.new("BindableEvent", NotificationContainer);
	newNotification.Dismissed = NotificationDismissedEvent.Event;
	newNotification.__DismissedEvent = NotificationDismissedEvent;

	local Proxy = {};

	setmetatable(Proxy, {
		__index = NotificationMethods;
	})
	local ProxyMeta = {
		__index = function(t,k)
			return Proxy[k]
		end,
		__newindex = function(i,k,v)
			rawset(Proxy,k,v)
			if(k == "Priority")then
				newNotification:Sort(self);
			elseif(k == "Pinned")then
				newNotification:Sort(self);
			end

		end,
	};


	setmetatable(newNotification, ProxyMeta)
	newNotification.Priority = Priority;

	newNotification:AnimateEntry();
	NotificationContainer.Parent = self:GetGUIRef();

	--newNotification.Pinned = Pinned;

	if(Lifetime ~= -1)then
		--Lifetime = math.clamp(Lifetime,5,)
		--print("Here")
		delay(Lifetime, function()
			--print("Time!")
			if(self and self._dev and newNotification and newNotification.Dismiss)then
				newNotification:Dismiss();
			end
		end)
	end;
	
	self:GetEventListener("Notification"):Fire(newNotification)
	
	return newNotification;

end;

--[=[
	Style toasts created by :Notify method
	@param StyleHandler function -- Arguments = Toast,Data,AttachedBTN,AttachedBTN2
]=]
function NotificationGroup:AddNotificationStyle(StyleName:string,StyleHandler:any)
	self._dev.Styles[StyleName] = StyleHandler;
end;
--[=[
	Creates a toast notification
]=]
function NotificationGroup:Notify(Data:string|table,...:any?)

	Data = Data or {};
	local ErrorService = self:_GetAppModule():GetService("ErrorService")

	if(typeof(Data)=="string")then
		local s = {...};

		Data = {
			Body = Data;
			Lifetime = s[1] ~= true and s[1] or nil;
			CloseButtonVisible = s[1] == true and s[1] or false;
		}
	end;
	
	if(not Data.IconImage)then
		local CoreGuiService = self:_GetAppModule():GetService("CoreGuiService");
		if(CoreGuiService:GetIsCoreScript(getfenv(0).script))then
			Data.IconImage = __PHeImage;
		end
	else
		if(Data.IconImage == __PHeImage)then
			ErrorService.tossWarn("Only CoreScripts can use "..Data.IconImage.." as a notification's icon image.");
			Data.IconImage = nil;
		end
	end;
	
	local App = self:_GetAppModule()
	local Toast = App.new("Toast");
	Toast.Header = Data.Header or "";
	Toast.Body = Data.Body or "";
	Toast.CanvasImage = Data.CanvasImage or "";
	Toast.Subheader = Data.Subheader or "";
	Toast.IconImage = Data.IconImage or "";
	Toast.CanCollapse = Data.CanCollapse or false;
	--Toast.After = Data.After;
	Toast.BackgroundColor3 = Data.BackgroundColor3 or Theme.getCurrentTheme().Background;
	Toast.BodyTextSize = Data.BodyTextSize or 16;
	Toast.BodyTextColor3 = Data.BodyTextColor3 or Theme.getCurrentTheme().Text;
	Toast.HeaderTextSize = Data.HeaderTextSize or 16;
	Toast.HeaderTextColor3 = Data.HeaderTextColor3 or Theme.getCurrentTheme().Text;
	Toast.CloseButtonVisible = Data.CloseButtonVisible or false;
	Toast._After = Data._After;
	Toast.xMax = self:GetGUIRef().AbsoluteSize.X-10;

	local AttachedBTN,AttachedBTN2;
	if(Data.AttachButton)then
		if(Data.After)then warn("Cannot Attach Button To Toast With An Existing After.");return end;
		local After = App.new("Frame");
		After.Size = UDim2.new(1,0,0,55);
		After.BackgroundTransparency = 1;
		After.StrokeTransparency = 1;
		local Btn = App.new("Button");	
		Btn.Position = UDim2.fromScale(.5,.5);
		Btn.AnchorPoint = Vector2.new(.5,.5);
		Btn.Text = Data.AttachButton;
		Btn.BackgroundTransparency = Data.AttachButtonColor3 and .2 or .92;
		Btn.BackgroundColor3 = Data.AttachButtonColor3 or Color3.fromRGB(27, 27, 27);
		Btn.StrokeTransparency = 1;
		Btn.Roundness = UDim.new(0);
		Btn.TextAdjustment = Enumeration.Adjustment.Center;
		Btn.Size = UDim2.new(1,0,0,35);
		Btn.RichText = true;
		Btn.ButtonFlexSizing = false;
		Btn.RippleStyle = Enumeration.RippleStyle.None;
		Btn.Parent = After;
		if(Data.AttachButton2)then
			local Btn2 = App.new("Button");	
			Btn2.Position = UDim2.new(0,0,.5);
			Btn2.AnchorPoint = Vector2.new(0,.5);
			Btn2.Text = Data.AttachButton2;
			Btn2.BackgroundTransparency = Data.AttachButton2Color3 and .2 or .92;
			Btn2.BackgroundColor3 = Data.AttachButton2Color3 or Color3.fromRGB(27, 27, 27);
			Btn2.StrokeTransparency = 1;
			Btn2.Roundness = UDim.new(0);
			Btn2.TextAdjustment = Enumeration.Adjustment.Center;
			Btn2.Size = UDim2.new(.49,0,0,35);
			Btn2.RichText = true;
			Btn2.ButtonFlexSizing = false;
			Btn2.RippleStyle = Enumeration.RippleStyle.None;
			Btn2.Parent = After;
			Btn.Position = UDim2.fromScale(1,.5);
			Btn.AnchorPoint = Vector2.new(1,.5);
			Btn.Size = Btn2.Size;
			AttachedBTN2 = Btn2;
		end;
	After.Parent = Toast;
		AttachedBTN=Btn;
		--Toast._After = After;
	end
	if(Data.NotificationStyle)then
		ErrorService.assert(typeof(Data.NotificationStyle) == "string", ("string expected for NotificationStyle, got %s. %s"):format(typeof(Data.NotificationStyle),self.Name));
		local targetStyle = self._dev.Styles[Data.NotificationStyle];
		if(targetStyle)then
			self._dev.Styles[Data.NotificationStyle](Toast,Data,AttachedBTN,AttachedBTN2)
		else
			ErrorService.tossWarn(("Could not apply style \"%s\" because it does not yet exist. %s"):format(Data.NotificationStyle, self.Name));
		end;
	end
	local n = self:SendNotification(Toast, Data.Priority, Data.NotificationAnimationStyle,Data.Lifetime);
	if(Data.Pinned)then
		n.Pinned = true;
	end;

	if(Toast:GetEventListener("CloseButtonPressed"))then
		local closed_;
		Toast.CloseButtonPressed:Connect(function()
			if(closed_)then return end;
			closed_=true;
			n:Dismiss();
		end)
	end

	return n, AttachedBTN, AttachedBTN2, Toast;
end;

--//
function NotificationGroup:RenderInPortal()
	if(not self:GET("Portal"))then
		local Portal = self:_GetAppModule().new("Portal");
		Portal.IgnoreGuiInset = true;
		self:GetGUIRef().Parent = Portal:GetGUIRef();
		self._Components["Portal"] = Portal;
		Portal.Parent = self:GetRef();
	end
end;
--//

function NotificationGroup:_Render(App)
	self._dev.Styles = {};
	--[=[
		@prop Notification PHeSignal
		@within NotificationGroup
	]=]
	self:AddEventListener("Notification",true);

	local NotificationsContainer = App.new("Frame",self:GetRef());
	NotificationsContainer.ClipsDescendants = true;
	local ListLayout = Instance.new("UIListLayout", NotificationsContainer:GetGUIRef());

	ListLayout.SortOrder = Enum.SortOrder.Name;

	return {
		["ContentAdjustment"] = function(Value)
			ListLayout.HorizontalAlignment = Enum.HorizontalAlignment[Value.Name];
		end,
		["SortOrderAdjustment"] = function(Value)
			if(Value == Enumeration.Adjustment.Center)then
				ListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
			elseif(Value == Enumeration.Adjustment.Top)then
				ListLayout.VerticalAlignment = Enum.VerticalAlignment.Top;
			else
				ListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom;
			end;
		end,
		_Components = {
			FatherComponent = NotificationsContainer:GetGUIRef();
		};
		_Mapping = {
			[ListLayout] = {
				"Padding";
			};
			[NotificationsContainer] = {
				"BackgroundTransparency","BackgroundColor3","StrokeTransparency","StrokeThickness","StrokeColor3",
				"Size","Position","AnchorPoint","Visible";
			};
		};
	};
end;


return NotificationGroup
