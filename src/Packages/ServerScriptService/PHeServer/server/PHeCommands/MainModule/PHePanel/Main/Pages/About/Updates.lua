local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Players = game:GetService("Players");
local Player = Players.LocalPlayer;

local Components = script.Parent.Parent.Parent.Components;

local createHeader = require(Components.createHeader);
local createUpdate = require(Components.createSubheader);

return {
	Name = "Updates";
	Icon = "ico-mdi@action/system_update_alt";
	Func = function()
		local Frame = App.new("Frame");
		
		local UpdatesScroller = App.new("ScrollingFrame",Frame);
		UpdatesScroller.Size = UDim2.fromScale(1,1);
		UpdatesScroller.AutomaticCanvasSize = Enum.AutomaticSize.Y;
		UpdatesScroller.BackgroundTransparency = 1;
		
		local List = Instance.new("UIListLayout", UpdatesScroller:GetGUIRef());
		
		local Manifest = require(game.ReplicatedStorage.PowerHorseEngine:WaitForChild("Manifest"));
		
		createUpdate("Version "..Manifest.Upd.Version, UpdatesScroller:GetGUIRef());
		
		for t,v in pairs(Manifest.Upd.VersionNotes) do
			local frame= createHeader(t,UpdatesScroller:GetGUIRef());
			for _,x in pairs(v) do
				createUpdate("	"..x,UpdatesScroller:GetGUIRef());
			end
		end
		
		
		return Frame;		
	end,
	
}