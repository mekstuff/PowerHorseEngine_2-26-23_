return function (App,...)
	return App:GetService("NotificationService"):SendNotification(...);
end;