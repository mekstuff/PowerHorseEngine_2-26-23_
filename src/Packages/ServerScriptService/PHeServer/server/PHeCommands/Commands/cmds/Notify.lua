--local consts = require(script.Parent.Parent.Constants)

local NotificationService = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine")):GetService("NotificationService");

return {
	cmd = "Notify";
	desc = "Sends a notification to the given player";
	req = "Mod";
	args = {
		{var="Player",type="player",req=true,desc="",default=nil};
		{var="Body",type="string",req=true,desc="The body of the notification",default=nil};
		{var="Header",type="string",req=false,desc="The header of the notification",default=""};
		{var="Lifetime",type="number",req=false,desc="How long does this notification last",default=10};
		{var="CloseButtonVisible",type="boolean",req=false,desc="Is the close button visible?",default=true};
		--{var="Priority",type="string",req=false,desc="The priority of the notificaton",default="Low"};
		{var="Canvas Image",type="string",req=false,desc="Image source",default=""};	
	};
	exe = function(Player,Body,Header,Lifetime,CloseButtonVisible,CanvasImage)
		NotificationService:SendNotification(Player,{
			Body = Body;
			Header = Header;
			Lifetime = Lifetime;
			CloseButtonVisible = CloseButtonVisible;
			CanvasImage = CanvasImage;
		})
	end,
}