local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);

--[=[
The base of all gui's

:::note Cannot be created with .new()
	BaseGui is used as a inheritance object
:::
@class BaseGui
--]=]

local function getROBLOXInstance(x)
	return x:IsA("BaseGui") and x:GetGUIRef() or (x:GET("_Appender") or x:GetRef()) or x;
end;

local BaseGui = {
	__PseudoBlocked = true;
	Name = "BaseGui";
	ClassName = "BaseGui";
	Position = UDim2.new(0);
	AnchorPoint = Vector2.new(0);
	--AbsolutePosition = Vector2.new(0,0);
	--AbsoluteSize = Vector2.new(0,0);
	--Size = UDim2.new(0,350,0,250);
	Size = UDim2.new(0,120,0,40);
	Visible = true;
	ZIndex = 1;
	Disabled = false;
	SupportsRBXUIBase = false;
	Rotation = 0;
	LayoutOrder = 0;
};
BaseGui.__inherits = {}
--[=[
@prop Disabled Boolean
@within BaseGui
]=]
--[=[
@prop Position UDim2
@within BaseGui
]=]
--[=[
@prop Size UDim2
@within BaseGui
]=]
--[=[
Sets whether or not the basegui is compatiable with [UIBase] objects, such as [UIListLayout]
@prop SupportsRBXUIBase Boolean
@within BaseGui
]=]
--[=[
@prop Visible Boolean
@within BaseGui
]=]
--[=[
@prop ZIndex Number
@within BaseGui
]=]
--[=[
@prop LayoutOrder Number
@within BaseGui
]=]

local TweenService = game:GetService("TweenService");

--[=[
Adds the css to the baseGui
]=]
function BaseGui:addcss(class:string)
	local hasCss = self.css:gsub("%-","_"):match(class:gsub("%-","_"));
	--print(hasCss)
	if(hasCss)then return end;
	if(self.css == "")then
		self.css = class;
	else
		self.css = self.css..","..class;
	end
end;
--//
local cssObjectClass = {
	Name = "cssObject",
	ClassName = "cssObject",
	--callBack = "**function",
};

function cssObjectClass:GetSelf()
	return self._dev.args[1];
end

function cssObjectClass:Connect(...)
	local t = {...}
	if(#t == 1)then
		table.insert(self._dev.eventHandlers,t[1]);
		return t[1]
	end;
	for _,x in pairs(t) do
		table.insert(self._dev.eventHandlers, t);
	end;
end

function cssObjectClass:ApplyProperty(Pseudo,Properties)
	
	local ErrorService = self:_GetAppModule():GetService("ErrorService");
	if(typeof(Pseudo) == "table" and not Pseudo._dev)then
		Properties = Pseudo;
		Pseudo = self._dev.args[1];
	end;
	ErrorService.assert(Pseudo, ("Pseudo expected while applying properties got '%s'"):format(tostring(Pseudo)));
	ErrorService.assert(Properties and typeof(Properties)=="table", ("table expected while applying properties got '%s'"):format(tostring(Properties)))
	
	for a,b in pairs(Properties) do
		--print(a,b, Pseudo)
		Pseudo[a]=b;
	end
	
end;

function cssObjectClass:_Render()
	self._dev.eventHandlers = {};
	self._dev.args[1]._dev.baseGui_cssObjectPropertyHolder = self; --> adds to cleanup
	return {};
end
--//
function BaseGui:_init()
	local GuiRef = self:GetGUIRef();
	GuiRef.LayoutOrder = self.LayoutOrder;
	self._dev._baseGui_LayoutOrder = self:GetPropertyChangedSignal("LayoutOrder"):Connect(function()
		GuiRef.LayoutOrder = self.LayoutOrder;
	end);
	self._dev._baseGui_supportsRBXUIBase = self:GetPropertyChangedSignal("SupportsRBXUIBase"):Connect(function()
		if(self.SupportsRBXUIBase)then
			self:GetGUIRef().Parent = self.Parent and ( self.Parent:IsA("Pseudo") and getROBLOXInstance(self.Parent) or self.Parent);
			self._dev._baseGui_supportsRBXUIBase_ParentChanged = self:GetPropertyChangedSignal("Parent"):Connect(function()
				self:GetGUIRef().Parent = self:GetRef().Parent;
			end);
		else
			self:GetGUIRef().Parent = self:GetRef();
			if(self._dev._baseGui_supportsRBXUIBase_ParentChanged)then
				self._dev._baseGui_supportsRBXUIBase_ParentChanged:Disconnect();
				self._dev._baseGui_supportsRBXUIBase_ParentChanged=nil;
			end;
		end;
	end)
end;
--//
function BaseGui:CreateTween(TweenInfo_,TweenProps,ToTween)
	return TweenService:Create(ToTween or self:GetGUIRef(), TweenInfo_ or TweenInfo.new(0), TweenProps);
end
--[=[
Gets The AbsolutePosition Of The BaseGui
@return Vector2
]=]
function BaseGui:GetAbsolutePosition()
	--game:GetService("RunService").RenderStepped:Wait();
	return self._Components["FatherComponent"].AbsolutePosition;
end;
--[=[
Gets The AbsoluteSize Of The BaseGui
@return Vectror2
]=]
function BaseGui:GetAbsoluteSize()
	--game:GetService("RunService").RenderStepped:Wait();
	return self._Components["FatherComponent"].AbsoluteSize;
end;
--[=[
Gets The GUI Reference Object Of The BaseGui 
@return Instance
]=]
function BaseGui:GetGUIRef()
	return self._Components["FatherComponent"];
end




return BaseGui
