local Theme = require(script.Parent.Parent.Parent.Theme);
local IsClient = game:GetService("RunService"):IsClient();

local ThemeProvider = {
	Name = "ThemeProvider";
	ClassName = "ThemeProvider";
	ThemeFilter = "";
	ThemeDisabled = false;

	--ThemeFilter = "Button";
	
	-- Primary = Theme.getDefaultTheme().Primary;
	-- Secondary = Theme.getCurrentTheme().Secondary;
	-- TextColor3 = Theme.getCurrentTheme().Text;
	-- BackgroundColor3 = Theme.getCurrentTheme().Background;

};
ThemeProvider.__inherits = {}

for a,b in pairs(Theme.getCurrentTheme()) do
	ThemeProvider[a]=b;
end

function ThemeProvider:useTheme(Theme)
	if(self._ThemeStates[Theme])then return self._ThemeStates[Theme];end;
	local App =  self:_GetAppModule();
	local newState = App.new("State");
	newState.State = self[Theme];
	self._ThemeStates[Theme]=newState;
	return newState;
end
--//
function ThemeProvider:ThemeControl(...)
	-- local i=0
	local t = {...}
	for i,v in pairs(t)do
		if(i%2 == 1)then
			self:_ThemeControl(v,t[i+1])
		end
	end
end
--//
function ThemeProvider:UpdateThemeControl(Class, newControl, DoNotAdd)
	for i,v in pairs(self._ThemeControls) do
		if(v.class == Class)then
			if(newControl)then
				v.Control = newControl;
			else
				-- self.control:Terminate();
				table.remove(self._ThemeControls,i);
			end
			-- table.remove(self._ThemeControl, i);
			break;
		end
	end;
	if(newControl and not DoNotAdd)then
		table.insert(self._ThemeControls,{
			class = Class;
			control = newControl;
		})
	end;
end;
--//
function ThemeProvider:_ThemeControl(Class,Control)
	local ErrorService = self:_GetAppModule():GetService("ErrorService");
	ErrorService.assert(typeof(Class) == "string", ("Missing Theme From :ThemeControl. Class Is Expected To Be A String, You Passed %s"):format(typeof(Class)))
	ErrorService.assert(typeof(Control) == "table", ("Missing Control From :ThemeControl. Control Is Expected To Be A Dictionary, You Passed %s"):format(typeof(Control)))
	self:UpdateThemeControl(Class, Control);
end;

function ThemeProvider:_GetThemeControl(class)
	for _,v in pairs(self._ThemeControls)do
		if(v.class == class)then
			return v.control;	
		end
	end;
end;

function ThemeProvider:ApplyTheme(Obj,Control)
	-- print(self._ThemeControls)
	Control = Control or self:_GetThemeControl(Obj.ClassName);
	if(not Control)then
		self:_GetAppModule():GetService("ErrorService").tossWarn("Missing Control For Theme Type "..Obj.ClassName);
		return;
	end;
	for a,b in pairs(Control) do
		Obj[a]=b;
	end;
end;

function ThemeProvider:RemoveTheme(Obj)
	-- print(self._ThemeControls);
	for _,v in pairs(self._ThemeControls) do
		if(v.class == Obj.ClassName)then
			for _,x in pairs(v.control) do
				x:Terminate(Obj);
			end
			-- v.control:Terminate(Obj);
			break;
		end
	end;
end;

function ThemeProvider:_Render(App)
	
	self._ThemeControls={};
	self._ThemeStates = {};
	local StackProvider = App.new("StackProvider");

	-- for a,b in pairs()
	
	StackProvider.PseudoAdded:Connect(function(Pseudo,PseudoClass)
		-- print(Pseudo);
		self:ApplyTheme(Pseudo);
		-- print(Pseudo, PseudoClass);
		--print(Pseudo,PseudoClass)
		-- self:_applyIndividual(Pseudo)
	end)

	StackProvider.PseudoRemoved:Connect(function(Pseudo)
		self:RemoveTheme(Pseudo);
	end)
	
	-- for _,v in pairs(ToEdit)do
	-- 	self:GetPropertyChangedSignal(v):Connect(function()
	-- 		self:_applyChange(v,self[v]);
	-- 	end);
	-- end
	
	local firstran=true;
	
	return {
		["*Parent"] = function(Value)
			StackProvider.Parent = self.Parent;
		end,
		["ThemeFilter"] = function(Value)
			StackProvider.Filter = Value;
		end,
		["ThemeDisabled"] = function(Value)
			StackProvider.Enabled = not Value;
			-- if(Value == false)then
			-- 	if(firstran)then firstran=nil;return;end
			-- 	for _,v in pairs(ToEdit)do
			-- 		-- self:_applyChange(v,self[v]);
			-- 	end;
			-- end;
		end,
		["_UseEffect"] = function(k,v)
			if(self._ThemeStates[k])then
				self._ThemeStates[k].State = v;
			end
		end,
		_Components = {
			StackProvider=StackProvider;	
			FatherComponent = self:GetRef();
		};
		_Mapping = {};
	};
end;


return ThemeProvider
