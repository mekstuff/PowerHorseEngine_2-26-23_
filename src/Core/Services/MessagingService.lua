local MessagingService = game:GetService("MessagingService");
local ErrorService = require(script.Parent.ErrorService);

local module = {}
local u = "PHeUnique-";

local _StudioSafety_ = {};
function _StudioSafety_:PublishAsync() return end;
function _StudioSafety_:SubscribeAsync() return end;

if(game:GetService("RunService"):IsStudio())then
	return _StudioSafety_;
end;

function module:PublishAsync(topic,message)
	topic = u..topic;
	local ran,res = pcall(function()
		return MessagingService:PublishAsync(topic,message);
	end)
	if(not ran)then
		ErrorService.tossError("[MessagingService] Failed To Execute :PublishAsync() : "..res);
	end;
	return res;
	--MessagingService:PublishAsync(topic)
end;

function module:SubscribeAsync(topic,callback)
	topic = u..topic;
	local ran,res = pcall(function()
		return MessagingService:SubscribeAsync(topic,callback);
	end)
	if(not ran)then
		ErrorService.tossError("[MessagingService] Failed To Execute :SubscribeAsync() : "..res);
	end;
	return res;
	--MessagingService:PublishAsync(topic)
end;

return module
