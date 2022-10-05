local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Config = App:GetConfig();
local PanelConfig = Config.PHePanel;
local Theme = App:GetGlobal("Theme");

local Components = script.Parent.Parent.Parent.Components;
local CreateHeader = require(Components.createHeader);
local EditableObject = require(Components.EditableObject);
local MainModule = require(script.Parent.Parent.Parent.MainModule);
local MainWidget = MainModule.CreateWidget();


local PersonalizeSettings = {
	["Commands"] = {
		{name = "Execute Commands From Chat",class = "Checkbox", args={Toggle = PanelConfig.ExecuteCommandsFromChat};
		exe = function(obj)
			obj:GetPropertyChangedSignal("Toggle"):Connect(function()
				PanelConfig.ExecuteCommandsFromChat = obj.Toggle;
			end)
		end,
		};
		{name = "Chat Prefix Syntax",class = "TextInput", args={Text = PanelConfig.ChatPrefixSyntax,ClearTextOnFocus=false};
		exe = function(obj)
			obj.FocusLost:Connect(function(ep)
				if(ep)then
					local prefix = obj.Text:match("%p");
					if(not prefix)then 
						MainModule.Console.log(obj.Text.." could not be used as a prefix", "warn");
					else
						MainModule.Console.log("Chat Prefix Syntax Changed To "..prefix);
						PanelConfig.ChatPrefixSyntax = prefix;
					end
				end
			end)
		end,
		};
	};
	
	["Personalize"] = {
		{name = "Panel Theme",class = "DropdownButton", args={Text = "Default"};
			exe = function(obj)
				for _,theme in pairs(MainModule.Themes) do
					obj:AddButton(theme.name, theme.name);
				end;
			obj.ButtonClicked:Connect(function(id)
				MainModule.SetTheme(id);
				obj.Text = id;
			end);
		end,
		};
		{name = "Panel Static",class = "Checkbox", args={Toggle = false};
		exe = function(obj)
			obj:GetPropertyChangedSignal("Toggle"):Connect(function()
				MainWidget.Static = obj.Toggle;
			end)
		end,
		};
	};
}

return {
	Name = "";
	Icon = "ico-mdi@image/color_lens";
	Func = function()
		local Frame = App.new("Frame");
		
		local Scroller = App.new("ScrollingFrame", Frame);
		Scroller.Size = UDim2.new(1,0,1,0);
		Scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		Scroller.BackgroundTransparency = 1;
		
		local List = Instance.new("UIListLayout",Scroller:GetGUIRef());
		List.Padding = UDim.new(0,2);
		
		for SettingHeader,SettingContent in pairs(PersonalizeSettings)do
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