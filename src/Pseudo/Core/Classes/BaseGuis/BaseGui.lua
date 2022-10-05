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
	css = "";
	SupportsRBXUIBase = false;
};
BaseGui.__inherits = {}
--[=[
@prop css String
@within BaseGui
]=]
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
	
	local App = self:_GetAppModule();
	local Content = App:GetGlobal("Engine").RequestContentFolder();
	--local Config = Content.Config;
	--if(not Config)then return end;
	
	local _css_mod = Content:FindFirstChild("css");
	local _css = _css_mod and require(_css_mod);
	
	if(not _css)then
		Core.tossError("Tried to apply BaseGui css with no .css file. PowerHorseEngine -> .content -> css");
	end
	local class = self.ClassName;
	local css = self.css;
	
	
	local Base = self:GetGUIRef();
	
	--local cssService = self:_GetAppModule():GetService("css");

	local function useStylesheetIf(format,sheet,noerrorcatch)
		local class_format = format..sheet;
			
		local stylesheet = (_css[class_format]);
		if(not stylesheet)then
			--local preset = cssService:getPreset();
			local tosearch = _css_mod;
			--if(preset)then tosearch = preset;end
			stylesheet = tosearch:FindFirstChild(class_format);
			if(stylesheet)then stylesheet = require(stylesheet);end;
			tosearch=nil;
		end
		if(stylesheet)then
			if(typeof(stylesheet) == "function")then
				local CustomClassService = App:GetService("CustomClassService");
				local Class = CustomClassService:Create(cssObjectClass,nil,{self})
				stylesheet(Class)
				return;
			end;
			
			Core.tossWarn(("You're using legacy css format, please switch to using a function instead of a table.'%s'example:\n\n[\"%s\"] = function(cssObject)end;\n\n learn about cssObjects on our documentation.\n"):format(class_format,class_format))
			--//Legacy
			for prop,val in pairs(stylesheet) do
				if (typeof(val) ~= "function") then
					self[prop]=val;
				end
			end;
			if(stylesheet.cmd)then
				stylesheet.cmd(self);
			end;
		else
			if(not noerrorcatch)then
				Core.tossWarn(sheet.." is not an existing stylesheet. in your .css file, are you sure it's \""..format..""..sheet.."\"?")
			end;		
		end;
	end
		
	--if(not self.ClassName:match("^PHe"))then
		self._dev._baseGUI__cssChanged = self:GetPropertyChangedSignal("css"):Connect(function()
			if(self.css ~= "")then
				local allcss = self.css:split(",");
				for _,cssClass in pairs(allcss)do
					local stringed = cssClass:gsub("[%s,\"]+","");
					useStylesheetIf(".",stringed);
				end
				--useStylesheetIf("#",self.css);
			end
		end);
	--end;
	-- local realParentRef
	self._dev._baseGui_supportsRBXUIBase = self:GetPropertyChangedSignal("SupportsRBXUIBase"):Connect(function()
		if(self.SupportsRBXUIBase)then
			-- print(self.Parent,self.Name);
			self:GetGUIRef().Parent = self.Parent and ( self.Parent:IsA("Pseudo") and getROBLOXInstance(self.Parent) or self.Parent);
			-- local realParentRef = Instance.new("ObjectValue");
			-- realParentRef.Name = "lanzoinc_rpbgr_$l";
			-- realParentRef.Parent = self:GetGUIRef();
			-- realParentRef.Value = self:GetRef();
			self._dev._baseGui_supportsRBXUIBase_ParentChanged = self:GetPropertyChangedSignal("Parent"):Connect(function()
				self:GetGUIRef().Parent = self:GetRef().Parent;
			end);
			-- local OriginalRefName = self:GetGUIRef().Name;
			-- self:GetGUIRef().Name = OriginalRefName..self.Name;
			-- self._dev._baseGui_supportsRBXUIBase_NameChanged = self:GetPropertyChangedSignal("Name"):Connect(function()
				-- self:GetGUIRef().Name = OriginalRefName..self.Name;
			-- end)
		else
			-- local _rpbgr = self:GetGUIRef():FindFirstChild("lanzoinc_rpbgr_$l");
			-- if(_rpbgr)then
				-- _rpbgr:Destroy();
			-- end;
			-- _rpbgr = nil;
			self:GetGUIRef().Parent = self:GetRef();
			if(self._dev._baseGui_supportsRBXUIBase_ParentChanged)then
				self._dev._baseGui_supportsRBXUIBase_ParentChanged:Disconnect();
				self._dev._baseGui_supportsRBXUIBase_ParentChanged=nil;
			end;
			--[[
			if(self._dev._baseGui_supportsRBXUIBase_NameChanged)then
				self._dev._baseGui_supportsRBXUIBase_NameChanged:Disconnect();
				self._dev._baseGui_supportsRBXUIBase_NameChanged=nil;
			end
			]]
		end
		
	end)
	--self._dev._p
	--useStylesheetIf(".",self.ClassName,true);
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
