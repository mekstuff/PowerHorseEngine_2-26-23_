local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local CommandService = App:GetService("CommandService");
local Components = script.Parent.Parent.Parent.Parent;
local EditableObject = require(Components.EditableObject);
local HeadsupText = require(Components.HeadsupText);

return {
	Name = "Statistics";
	Icon = "";
	Func = function(_,PlayerInfo)
		local Frame = App.new("Frame");
		
		if not(PlayerInfo.PlayerInServer)then
			
			HeadsupText(PlayerInfo.Username.." isn't in the current server, you can't manipulate their statistics.", Frame);
			
		else
			
			local leaderstats = PlayerInfo.Player:FindFirstChild("leaderstats");
			
			if(not leaderstats)then
				HeadsupText("No \"leaderstats\" folder found. Does your game not use leaderstats? you can still edit data in the datastore tab!", Frame);
				else
				local Container = App.new("ScrollingFrame",Frame);
				Container.AutomaticCanvasSize = Enum.AutomaticSize.Y;
				Container.Size = UDim2.fromScale(1,1);
				Container.StrokeTransparency = 1;
				Container.BackgroundTransparency = 1;
				local List = Instance.new("UIListLayout",Container:GetGUIRef());
				
				for _,v in pairs(leaderstats:GetChildren())do
					local x,rightside,object;
					if(v:IsA("IntValue") or v:IsA("NumberValue"))then
						x,rightside,object = EditableObject(v.Name, "TextInput", {Text = tostring(v.Value), ClearTextOnFocus = false;});
						object.FocusLost:Connect(function(ep)
							if(ep)then
								CommandService:ExecuteCmdFromStr("setStat "..PlayerInfo.Username.." "..v.Name.." "..object.Text);
							end;
						end)
					elseif(v:IsA("BoolValue"))then
						x,rightside,object = EditableObject(v.Name, "Toggle" , {Toggle = v.Value});
						object.Toggled:Connect(function()
							CommandService:ExecuteCmdFromStr("setStat "..PlayerInfo.Username.." "..v.Name.." "..tostring(object.Toggle));
						end)
					end;
					
					x.Parent = Container:GetGUIRef();
				end;
				
			end;
			
			

			
		end
		
	
		
		return Frame;
	end,
}