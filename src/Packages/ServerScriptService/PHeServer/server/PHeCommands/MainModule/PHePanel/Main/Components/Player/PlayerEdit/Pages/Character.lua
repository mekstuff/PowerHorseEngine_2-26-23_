local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Components = script.Parent.Parent.Parent.Parent;
local EditableObject = require(Components.EditableObject);
local HeadsupText = require(Components.HeadsupText);

local Player = game.Players.LocalPlayer;
local PlayerName = Player.Name;

local MainModule = require(Components.Parent.MainModule);

local CreateHeader = require(Components.createHeader);

local CharacterSettings = {
	[""] = {
		{name = "Health",class = "TextInput",args={ClearTextOnFocus = false;};
			exe = function(PlayerInfo,Obj)
			Obj.FocusLost:Connect(function(ep)	
				MainModule.exe("Set "..PlayerInfo.Username.." Health "..Obj.Text);
					--MainModule.exe("Set "..PlayerInfo.Username.." Health "..tostring(tonumber(Obj.Text)));
				end)
			end,
		};
		{name = "WalkSpeed",class = "TextInput",args={ClearTextOnFocus = false;};
		exe = function(PlayerInfo,Obj)
			Obj.FocusLost:Connect(function(ep)	
				MainModule.exe("Set "..PlayerInfo.Username.." WalkSpeed "..Obj.Text);
			end)
		end,
		};
		{name = "Teleport",class = "DropdownButton",args={Text = "To...";};
		exe = function(PlayerInfo,Obj)
			Obj:AddButton("To Me","Teleport "..PlayerInfo.Username.." "..PlayerName);
			Obj:AddButton("To Them","Teleport "..PlayerName.." "..PlayerInfo.Username);
			Obj:AddButton("Server To Them","TeleportServer "..PlayerInfo.Username);
			Obj.ButtonClicked:Connect(function(id)
				MainModule.exe(id);
			end)
		end,
		};
	
	};
}


return {
	Name = "Character";
	Icon = "";
	Func = function(_,PlayerInfo)
		local Frame = App.new("Frame");
		
		if not(PlayerInfo.PlayerInServer)then
			HeadsupText(PlayerInfo.Username.." isn't in the current server, you can't manipulate their statistics.", Frame);	
		else
			local Container = App.new("ScrollingFrame",Frame);
			Container.AutomaticCanvasSize = Enum.AutomaticSize.Y;
			Container.Size = UDim2.fromScale(1,1);
			Container.StrokeTransparency = 1;
			Container.BackgroundTransparency = 1;
			local List = Instance.new("UIListLayout",Container:GetGUIRef());


			for SettingHeader,SettingContent in pairs(CharacterSettings)do
				if(SettingHeader ~= "")then
					CreateHeader(SettingHeader,Container:GetGUIRef());
				end;
				for _,x in pairs(SettingContent)do
					local gridresp,_,obj = EditableObject(x.name,x.class,x.args);
					gridresp.Parent = Container:GetGUIRef();
					x.exe(PlayerInfo,obj);
				end
			end;
			

		end
		
	
		
		return Frame;
	end,
}