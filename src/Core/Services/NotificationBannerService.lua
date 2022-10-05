--[[
local module = {}
local IsClient = game.Players.LocalPlayer;
local Engine = require(script.Parent.Parent.Parent.Engine);
local CoreGuiService = require(script.Parent.CoreGuiService)
local NH = CoreGuiService:WaitFor("NotificationBanner");

if(IsClient)then
	local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);
	--module.QueueEnded = SignalProvider.new("NotificationBanner QueueEnded");
	--module.QueueStarted = SignalProvider.new("NotificationBanner QueueStarted");
	--module.QueueChanged = SignalProvider.new("NotificationBanner QueueChanged");
	--module.Notified = SignalProvider.new("NotificationBanner QueueChanged");
end

function module:Notify(Player,Message,LifeTime)
	if(IsClient)then
		if(not Message)then LifeTime = Message; Message = Player; end;
		module:_handleNotify(Message,LifeTime);
	else
		local NotificationBannerServiceEvent = Engine:FetchStorageEvent("NotificationBannerService_Notify");
		NotificationBannerServiceEvent:FireClient(Player, Message, LifeTime);
	end;
end;

--local Stamp;
local Queue={};

local function show(Message,LifeTime)
	LifeTime = LifeTime or 4;

	NH.Text = Message or "Information Error";
	NH.Visible = true;
	
	--module.Notified:Fire(NH,Message,LifeTime);
	
	delay(LifeTime,function()
		NH.Visible = false;
	end)
end;

local Queuing = false;
local function ExecuteQueue()
	--module.QueueStarted:Fire(Queue);
	for _,v in pairs(Queue) do
		NH:GetPropertyChangedSignal("Visible"):Wait();
		wait(1);
		show(v.msg,v.t);
		--module.QueueChanged:Fire(v);
	end;
	--module.QueueEnded:Fire();
	Queuing=false;
	Queue={};
end;

function module:_handleNotify(Message,LifeTime)
	if(IsClient)then
		
		if(NH.Visible == true)then
			table.insert(Queue,{msg = Message;t = LifeTime});
		end;
		if(#Queue <= 0)then
			show(Message,LifeTime);
			if(Queuing)then Queuing=false;end;
		else
			if(not Queuing)then
				ExecuteQueue();
			end
		end;
	end;
	--[[
	if(IsClient)then
		if(NH.Visible == true)then
			print("Waiting");
			local c;
			c = NH:GetPropertyChangedSignal("Visible"):Connect(function()
				print("Show now")
				--NH.Visible = true;
				c:Disconnect();
				c=nil;
				show(Message,LifeTime)
			end);
			return;
		end
	show(Message,LifeTime);
	end;
	]
end;

return module
]]
return {};
