local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Enumeration = App:GetGlobal("Enumeration");
-- local Stack = App:Import("Stack");
local New = App:Import("Whiplash").New;
local AutocompleteSuggestion = require(script.Parent.Parent.Parent.Components.AutocompleteSuggestion);
local CommandService = App:GetService("CommandService");
local AllCommands = CommandService:GetCommands();
local pColor = Color3.fromRGB(85, 170, 255);
local MainModule = require(script.Parent.Parent.Parent.MainModule);
local MainWidget = MainModule.CreateWidget();


local ShowingAutocomplete = false;


--[[
local AutocompleteToolTip,Scroller;

local function suggest(t)
	--local i=1;
	for _,v in pairs(CommandService:GetCommands())do
		local existing = Scroller:FindFirstChild(v.cmd:lower());
		if(not existing)then
			
			local tlower = t:lower();
			
			local s = v.cmd:lower():find(tlower);
			
		
			if(s)then
				local frame = AutocompleteSuggestion(v.cmd,v.desc_str);
				frame.Name = v.cmd:lower();
				frame.Parent = Scroller;
				--i+=1;
			end;
		else
			--//edit existing component
		
		end;
	end;
		for _,q in pairs(Scroller:GetChildren())do
			if q:IsA("Frame") and not(q.Name:find(t:lower()))then
				q:Destroy();
			end;
	end;
	--print( 120*(#Scroller:GetChildren()-1), #Scroller:GetChildren())
	Scroller.Size = UDim2.new(0,0,0, math.clamp( 120*(#Scroller:GetChildren()-1),0,120*3 ));
end;
]]

return {
	Name = "";
	Icon = "ico-mdi@hardware/keyboard";
	Func = function(_,widget)
		local Frame = App.new("Frame");
		Frame.StrokeTransparency = 1;
		
		local CommandLine = New "$TextInput" {
			Parent = Frame;
			AnchorPoint = Vector2.new(0,1);
			Position = UDim2.fromScale(0,1);
			Size = UDim2.new(1,0,0,36);
			BackgroundColor3 = Color3.fromRGB(0);
			BackgroundTransparency = .7;
			PlaceholderText = "Enter a command";
			Roundness = UDim.new(0);
			StrokeTransparency = 1;
			ClearTextOnFocus = false;
			-- UseCurrentWordAsNeedle = false;
			RichText = true;
			TextXAlignment = Enum.TextXAlignment.Left;
		};
		
		local function fireCmd(focusOnCmd)
			--print(CommandLine.Text:match("[%p%w]+"));
			local str = "";
			local cmdNameFormatted,cmdVarsFormatted = CommandService:FromStringToCommand(CommandLine.Text);
			CommandService:ExecuteCommand(cmdNameFormatted,cmdVarsFormatted,focusOnCmd)
		end;
		
		--CommandLine:GetPropertyChangedSignal("Needle"):Connect(function()
		--	print(CommandLine.Needle)
		--end)
		
		local filterForCommands = false;
		
		CommandLine.TextChanged:Connect(function()
			--print(CommandLine.Text)
			--[[
			local isFirstLine = CommandLine.CurrentWordStart == 1;
		
			if(isFirstLine)then	
				if(not filterForCommands)then
					filterForCommands = true;
					for _,v in pairs(AllCommands) do
						CommandLine:AddSuggestion({
							Header = v.cmd;
							Body = v.desc_str;
							--Text = v.cmd;
						}, "cmd-"..v.cmd)
					end
				end;
				CommandLine.Needle = CommandLine.Text;
			else
				filterForCommands = false;
				CommandLine.SuggestionList = {} --> Resets suggestions
			end;
			]]
		end);
		
		CommandLine.FocusLost:Connect(function(ep)
			if(ep)then
				fireCmd(true)
			end
		end)
		
		--[[
		CommandLine.TextChanged:Connect(function()
			
			if(not AutocompleteToolTip)then
				AutocompleteToolTip = App.new("ToolTip");
				AutocompleteToolTip.IdleTimeRequired = 0;
				AutocompleteToolTip.RevealOnMouseEnter = false;
				AutocompleteToolTip.PositionBehaviour = Enumeration.PositionBehaviour.Static;
				AutocompleteToolTip.StaticXAdjustment = Enumeration.Adjustment.Flex;
				AutocompleteToolTip.Parent = script.Parent.Parent.Parent.Components.content;
				AutocompleteToolTip._Adornee = CommandLine;
				--AutocompleteToolTip:_UpdateAdornee();
				
				MainWidget:GetPropertyChangedSignal("Enabled"):Connect(function()
					if not(MainWidget.Enabled)then
						AutocompleteToolTip:_Hide();
					end
				end)
				
				
				local AutocompleteScroller = App.new("ScrollingFrame",AutocompleteToolTip);
				
				AutocompleteScroller.AutomaticSize = Enum.AutomaticSize.X;
				AutocompleteScroller.BackgroundTransparency = 1;
				AutocompleteScroller.Size = UDim2.new(0);
				
				Scroller = AutocompleteScroller:GetGUIRef();
				local Grid = Instance.new("UIListLayout",Scroller);
			
			end;
			
			if(#CommandLine.Text == 0)then
				if(ShowingAutocomplete)then
					AutocompleteToolTip:_Hide();
					ShowingAutocomplete=false;
					for _,x in pairs(Scroller:GetChildren())do
						if(x:IsA("Frame"))then x:Destroy();end;
					end
				end
			else
				if(not ShowingAutocomplete)then
					ShowingAutocomplete = true;
					AutocompleteToolTip:_Show();
				end;
				suggest(CommandLine.Text:match("%a+"))
			end
			
		
		end)
		]]
		--[[
		CommandLine.FocusLost:Connect(function()
			for _,x in pairs(keywords) do
				if(CommandLine.Text:find(x))then
					CommandLine.Text = CommandLine.Text:gsub(x,"<font color='rgb(255,165,0)'>"..x.."</font>");
				end
			end
		end)
		]]
		
		local CommandLineOutput = New "$ScrollingFrame" {
			Parent = Frame;
			Size = UDim2.new(1,-5,1,-36);
			Position = UDim2.fromScale(.5);
			AnchorPoint = Vector2.new(.5);
			BackgroundTransparency = 1;
			AutomaticCanvasSize = Enum.AutomaticSize.Y;
		};
		
		MainModule.Console._commandlineoutput = CommandLineOutput;
		
		local UIList = Instance.new("UIListLayout",CommandLineOutput:GetGUIRef());
		UIList.FillDirection = Enum.FillDirection.Vertical;
		_G.cmdLineOUTPUT_PHE_Client = CommandLineOutput;
		

		local ActionMenuController = {
			{
				text = "Clear Output";
				id = "clear";
				func = function()
					MainModule.Console.clear();
				end,
			}
		}
		
		local ActionMenu = App.new("ActionMenu", script.Parent.Parent.Parent.Components.content);
		--ActionMenu:AddAction("Clear Output","clear");
		for _,x in pairs(ActionMenuController) do
			ActionMenu:AddAction(x.text,x.id);
		end;
	
		
		CommandLineOutput.MouseButton2Down:Connect(function()
			ActionMenu:Show();
		end)
		ActionMenu.ActionTriggered:Connect(function(action)
			for _,x in pairs(ActionMenuController)do
				if(x.id == action.ID)then
					x.func();
					break;
				end
			end
		end);
		
		return Frame;
	end,
}