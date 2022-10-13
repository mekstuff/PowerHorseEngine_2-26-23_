local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local CommandService = App:GetService("CommandService");
local Stack = App:Import("Stack");
local pColor = Color3.fromRGB(85, 170, 255);


local Scroller;

local function createCommand(t,hover)
	local f = Instance.new("Frame",Scroller);
	f.Size = UDim2.new(1,0,0,35);
	f.BackgroundTransparency = 1;
	f.Name = t;
	local Text = App.new("Button",f);
	Text.ButtonFlexSizing = false;

	Text.TextAdjustment = App:GetGlobal("Enumeration").Adjustment.Center;
	Text.Size = UDim2.fromScale(1,1)
	Text.TextXAlignment = Enum.TextXAlignment.Left;
	--Text.BackgroundColor3 = Color3.fromRGB(30, 30, 30);
	Text.BackgroundTransparency = 1;
	Text.StrokeTransparency = .1;
	Text.TextSize = 14;
	Text.Font = Enum.Font.GothamBold
	Text.Text = t;
	Text.ToolTip = hover or "";
	--Text.StrokeTransparency = 1;
	return f,Text;
end;


return {
	Name = "";
	Icon = "ico-mdi@action/view_list";
	Func = function()
		local Frame = App.new("Frame");
		Frame.StrokeTransparency = 1;
		
		local Topbar = App.new("Frame");
		Topbar.Size = UDim2.new(1,0,0,36);
		Topbar.BackgroundTransparency = 1;
		Topbar.Parent = Frame;
		
		local SearchCommand = App.new("TextInput");
		SearchCommand.AnchorPoint = Vector2.new(0,.5);
		SearchCommand.Position = UDim2.fromScale(0,.5);
		SearchCommand.Size = UDim2.new(1,-130,.85,0);
		SearchCommand.BackgroundColor3 = Color3.fromRGB(0);
		SearchCommand.BackgroundTransparency = .7;
		SearchCommand.PlaceholderText = "Filter...";
		SearchCommand.Roundness = UDim.new(0);
		SearchCommand.StrokeTransparency = 1;
		SearchCommand.ClearTextOnFocus = false;
		SearchCommand.RichText = true;
		SearchCommand.Parent = Topbar;
		
		local SortByDropdownButton = App.new("DropdownButton");
		SortByDropdownButton.ButtonFlexSizing = false;
		SortByDropdownButton.AnchorPoint = Vector2.new(1,.5);
		SortByDropdownButton.Position = UDim2.new(1,-5,.5);
		SortByDropdownButton.Size = UDim2.new(0,120,.85,0);
		SortByDropdownButton.Text = "Sort by";
		
		SortByDropdownButton.Parent = Topbar;
		
		SortByDropdownButton:AddButton("A-Z","a-z");
		SortByDropdownButton:AddButton("List Order","time");
		
	

		
		Scroller = App.new("ScrollingFrame",Frame);
		Scroller.Size = UDim2.new(1,0,1,-(Topbar.Size.Y.Offset+5));
		Scroller.Position = UDim2.fromOffset(0,(Topbar.Size.Y.Offset+5));
		Scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		Scroller.BackgroundTransparency = 1;
		Scroller = Scroller:GetGUIRef();
		
		SearchCommand.TextChanged:Connect(function()
			for _,v in pairs(Scroller:GetChildren())do
				if not (v:IsA("UIListLayout"))then
					if(v.Name:lower():match(SearchCommand.Text:lower()))then
						v.Visible = true;
					else
						v.Visible = false;
					end;
				end;
			end
		end)
		
		local List = Instance.new("UIListLayout", Scroller);
		List.Padding = UDim.new(0,5);
		List.SortOrder = Enum.SortOrder.Name;
		
		for _,cmd in pairs(CommandService:GetCommands())do
			--[[
			local argumentdata = "";
			if(cmd.args)then
				for index,x in pairs(cmd.args)do
					x.type = x.type or "??";
					x.description = x.description or "??";
					local t = "Var \""..x.var.."\" ["..x.type.."]".." ("..x.description..")"
					if(index > 1)then
						t = "\n\n"..t;
					end;
					argumentdata = argumentdata..t;
				end
			end
			
			local cmdframe,cmdbtn = createCommand(cmd.cmd, "("..cmd.cmd..") "..cmd.desc.."\n rank:"..cmd.req.."\n\n"..argumentdata);	
			]]
			local cmdframe,cmdbtn = createCommand(cmd.cmd,cmd.desc_str);
			cmdbtn.Icon = cmd.icon or "";
		end
		
		
		return Frame;
	end,
}