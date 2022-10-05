local initiated=false;

return function()
	if(initiated)then return end;
	initiated=true;
	local App = require(script.Parent.Parent.Parent)
	--local main = require(script.Parent);
	
	local MainNotificationGroup = App.new("NotificationGroup");
	MainNotificationGroup.Name = "PluginUtil-NotificationGroup";
	MainNotificationGroup.Parent = script.Parent.CoreGui;
end