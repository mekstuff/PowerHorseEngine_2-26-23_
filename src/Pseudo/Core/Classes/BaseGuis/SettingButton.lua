local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local SettingButton = {
	Name = "SettingButton";
	ClassName = "SettingButton";
	StrokeColor3 = Theme.getCurrentTheme().Border;
	StrokeTransparency = 0;
	StrokeThickness = 0;
	--ButtonFlexSizing = true;

};
SettingButton.__inherits = {"BaseGui"}

function SettingButton:Select(id,noFire)
	local Button = self:GET("Button");
	local Theme = self:_GetAppModule():GetGlobal("Theme").getCurrentTheme();
	for i,v in pairs(self._settings) do
		if(v.id == id)then
			Button.Text = v.name;
			Button.BackgroundColor3 = v.color or Theme.Primary;
			self._index = i;
			if(not noFire)then self:GetEventListener("SettingChanged"):Fire(id);end;
			break;
		end;
	end
end

function SettingButton:AddSetting(SettingName,SettingId,SettingColor)
	SettingId = SettingId or SettingName;
	table.insert(self._settings,{
		name = SettingName;
		id = SettingId;
		color = SettingColor;
	});
	if(#self._settings == 1)then
		self:Select(SettingId);
	end
end;

function SettingButton:_RemoveASetting(SettingId)
	for i,v in pairs(self._settings) do
		if(v.id == SettingId)then
			if(self._index == i)then
				local nextInLine = self._settings[i-1] or self._settings[i+1];
				--[[
				if(not nextInLine)then
					for ii,vv in pairs(self._settings) do
						if (ii ~= i)then
							nextInLine = v;break;
						end
					end
				end
				]]
				if(nextInLine)then
					self:Select(nextInLine.id);
				end
			end
			table.remove(self._settings,i);
			break;
		end
	end
end

function SettingButton:RemoveSetting(...)
	for _,id in pairs {...} do
		self:_RemoveASetting(id);
	end
end

function SettingButton:_Render(App)
	
	local Button = App.new("Button",self:GetRef());
	Button.TextScaled = true;
	Button.ButtonFlexSizing = false;
	Button.TextAdjustment = Enumeration.Adjustment.Center;
	
	self._settings = {};
	self:AddEventListener("SettingChanged",true);

	
	Button.MouseButton1Down:Connect(function()
		if(#self._settings > 0)then
			local i = self._index+1 > #self._settings and 1 or self._index+1;
			if(i ~= self._index)then
				self:Select(self._settings[i].id);
			end
		end
	end);
	
	return {
		["Property"] = function(Value)
			
		end,
		_Components = {
			Button = Button;
			FatherComponent = Button:GetGUIRef();
		};
		_Mapping = {
			[Button] = {
				"Position","AnchorPoint","Size","Visible","StrokeColor3","StrokeTransparency","StrokeThickness";
			}	
		};
	};
end;


return SettingButton
