local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Players = game:GetService("Players");
local Player = Players.LocalPlayer;

local Components = script.Parent.Parent.Parent.Components;

local createHeader = require(Components.createHeader);
local createCredit = require(Components.createSubheader);


local credits = App.Manifest.Credits;


return {
	Name = "Credits";
	Icon = "ico-mdi@file/request_quote";
	Func = function()
		local Frame = App.new("Frame");
		
		
		local UpdatesScroller = App.new("ScrollingFrame",Frame);
		UpdatesScroller.Size = UDim2.fromScale(1,1);
		UpdatesScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		UpdatesScroller.BackgroundTransparency = 1;
		
		local Scroller = UpdatesScroller:GetGUIRef();
		
		local List = Instance.new("UIListLayout", UpdatesScroller:GetGUIRef());
		
		local Manifest = require(game.ReplicatedStorage.PowerHorseEngine:WaitForChild("Manifest"));
		
		for a,b in pairs(credits)do
			createHeader(a,Scroller);
			for _,x in pairs(b)do
				createCredit(x,Scroller);
			end
		end;
		
		createHeader("Become a Donator ",Scroller);
		local f = Instance.new("Frame",Scroller)
		f.Size = UDim2.new(1,0,0,100);
		f.BackgroundTransparency = 1;
		local btnDonate25 = App.new("Button",f);
		btnDonate25.Text = "Donate 25R$";
		btnDonate25.Position = UDim2.new(.5,0,0,5);
		btnDonate25.AnchorPoint = Vector2.new(.5)

		local btnDonate100 = App.new("Button",f);
		btnDonate100.Text = "Donate 100R$";
		btnDonate100.Position = UDim2.new(0,5,0,60);
		btnDonate100.BackgroundColor3 = Color3.fromRGB(255, 167, 176);
		local btnDonate500 = App.new("Button",f);
		btnDonate500.Text = "Donate 500R$";
		btnDonate500.Position = UDim2.new(1,-5,0,60);
		btnDonate500.AnchorPoint = Vector2.new(1);
		btnDonate500.BackgroundColor3 = Color3.fromRGB(255, 186, 102);
		local btnDonate1000 = App.new("Button",f);
		btnDonate1000.Text = "Donate 1,000R$";
		btnDonate1000.Position = UDim2.new(.5,0,0,60);
		btnDonate1000.AnchorPoint = Vector2.new(.5);
		btnDonate1000.BackgroundColor3 = Color3.fromRGB(255, 172, 55);
		
		return Frame;		
	end,
	
}