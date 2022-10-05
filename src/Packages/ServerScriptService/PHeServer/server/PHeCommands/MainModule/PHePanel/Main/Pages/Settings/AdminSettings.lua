local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Config = App:GetConfig();
local PanelConfig = Config.PHePanel;
local Theme = App:GetGlobal("Theme");

local Components = script.Parent.Parent.Parent.Components;
local CreateHeader = require(Components.createHeader);
local EditableObject = require(Components.EditableObject);
local MainModule = require(script.Parent.Parent.Parent.MainModule);
local MainWidget = MainModule.CreateWidget();


local AdminSettings = {
	["Commands"] = {};
	[""] = {
		{name = "Moderation Log",class = "Button", args={Text = "View"};
		exe = function(obj)

		end,
		};
		
	};
	
	
}

local Commands = App:GetService("CommandService"):GetCommands();

for _,v in pairs(Commands)do
	table.insert(AdminSettings.Commands,{
		name = v.cmd,
		class = "Checkbox",
		exe = function(obj)
			-->Disable and enable commands remotely
		end,
		
	})
end

return {
	Name = "Admin Settings";
	Icon = "ico-mdi@action/admin_panel_settings";
	Func = function()
		local Frame = App.new("Frame");
		
		local Scroller = App.new("ScrollingFrame", Frame);
		Scroller.Size = UDim2.new(1,0,1,0);
		Scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		Scroller.BackgroundTransparency = 1;
		
		local List = Instance.new("UIListLayout",Scroller:GetGUIRef());
		List.Padding = UDim.new(0,2);
		
		for SettingHeader,SettingContent in pairs(AdminSettings)do
			if(SettingHeader ~= "")then
				CreateHeader(SettingHeader,Scroller:GetGUIRef());
			end;
			for _,x in pairs(SettingContent)do
				local gridresp,_,obj = EditableObject(x.name,x.class,x.args);
				gridresp.Parent = Scroller:GetGUIRef();
				x.exe(obj);
			end
		end;
		return Frame;
	end,
}