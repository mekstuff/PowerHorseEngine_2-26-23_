local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);
local CoreGuiService = require(script.Parent.CoreGuiService);
local Engine = require(script.Parent.Parent.Parent.Engine);
local MessagingService = require(script.Parent.MessagingService);
local SerializationService = require(script.Parent.SerializationService);
local AudioService = require(script.Parent.AudioService);
local CustomClassService = require(script.Parent.CustomClassService);
local ErrorService = require(script.Parent.ErrorService);
local PluginService = require(script.Parent.PluginService);

local NotificationsEnabled = true;

local AudioChannel = AudioService:CreateSoundEffectsChannel();

--[=[
	@class NotificationService
]=]
local NotificationService = {};


if(game:GetService("RunService"):IsClient())then
	NotificationService.OnNotification = SignalProvider.new("NotificationInbound");
end;

--[=[]=]
function NotificationService:SetNotificationsEnabled(State:boolean)
	State = State or false;
	if(State == NotificationsEnabled)then return end;
	if(State)then
		CoreGuiService:WaitFor("NotificationGroup").Visible = true;
	else
		CoreGuiService:WaitFor("NotificationGroup").Visible = false;
	end;
	NotificationsEnabled=State;
end;

local BroadcastSubscriber;
--[=[
	Sends A notification to everyone in every server

	:::warning
	Limited to [MessagingService] limits
	:::
]=]
function NotificationService:BroadcastNotification(Data:table)
	if(not BroadcastSubscriber)then
		BroadcastSubscriber = MessagingService:SubscribeAsync("NotificationBroadcast",function(serial)
			NotificationService:SendNotificationToAllPlayers(SerializationService:DeserializeTable(serial));
		end);
	end
	if(game.Players.LocalPlayer)then ErrorService.tossError("Broadcasting Notifications can only be performed by the server.");end;
	MessagingService:PublishAsync("NotificationBroadcast",SerializationService:SerializeTable(Data));
end;

--[=[
	Sends A notification to everyone in the current server
]=]
function NotificationService:SendNotificationToAllPlayers(Data:table,...:any)
	Engine:FetchStorageEvent("NotificationService_SendNotificationAsync"):FireAllClients(Data,...);
end;

--[=[
	Alias for [SendNotificationAsync]
]=]
function NotificationService:SendNotification(...:any) 
	return NotificationService:SendNotificationAsync(...);
end;

--[=[
	@class NotificationResponse
	Pseudo that is returned from Sending a notification
]=]
local NotificationResponse = {
	Name = "NotificationResponse",
	ClassName = "NotificationResponse",
};

function NotificationResponse:Destroy()
	local args = self._dev.args;
	if(args.TargetPlayer)then
		args.Channel:FireClient(args.TargetPlayer,"dismiss");
	end;
	args.Channel:Destroy();
	self:GetRef():Destroy();
end

--[=[
	Destroys the notification
]=]
function NotificationResponse:Dismiss()
	self:Destroy();
end;

function NotificationResponse:_Render()
	
	local AttachButtonDown,AttachButton2Down,Dismissed = self:AddEventListener("AttachButtonDown",true),self:AddEventListener("AttachButton2Down",true),self:AddEventListener("Dismissed",true)
	
	local Channel = self._dev.args.Channel
	--self._dev.ChannelTrace = Channel;
	local TargetUserId = Channel.Name:match("->(%d+)")
	Channel.OnServerEvent:Connect(function(Player,event,...)
		if(tostring(Player.UserId) ~= TargetUserId)then
			return --> Player fired event ... add to warning list or something?
		end;
		if(event == "attachbuttondown")then
			AttachButtonDown:Fire(...);
		elseif(event == "attachbutton2down")then
			AttachButton2Down:Fire(...);
		elseif(event == "dismissed")then
			self:Dismiss();
			Dismissed:Fire(...);
		end
		
	end);
	
	return {
		
	}
end

--[=[
	@return NotificationResponse
]=]
function NotificationService:SendNotificationAsync(Plr:Player,Data:table,...:any)
	local passed = (...);
	local Player = Plr;
	
	
	if(typeof(Player) == "Instance")then
		if(Player ~= game.Players.LocalPlayer)then
			local TempCommunicationChannel = Engine:FetchStorageEvent("%Temp"..tostring(math.random(1,100)).."%CommunicationChannel-Server->"..Plr.UserId);
			local NotificationResponse = CustomClassService:Create(NotificationResponse,nil,{TargetPlayer = Player, Channel = TempCommunicationChannel});
			
			Engine:FetchStorageEvent("NotificationService_SendNotificationAsync"):FireClient(Player,TempCommunicationChannel,Data,...);
			--print("Send Notification To Seperate Client -> From Server?");
			return NotificationResponse;	
		end
	else
		Player = game.Players.LocalPlayer;
		passed = Data;
		Data = Plr;
	end

	return NotificationService:HandleNotificationRequest(Data,passed);
	--local DefaultNotificationGroupForClient 
end;



local lastNotification

local function count(t)
	local i = 0;
	for _,_ in pairs(t) do
		i+=1;
	end;
	return i;
end

local function match(t1,t2)
	if(typeof(t1)=="table" and typeof(t2) == "table")then
		if(count(t1) ~= count(t2))then return false;end;
		for key,value in pairs(t1) do
			if t2[key] ~= value then return false;end;
		end;
		return true;
	elseif(typeof(t1) == "string" and typeof(t2)=="string")then
		return t1 == t2;
	else
		return false;
		--return false;
	end;
end

local _t = {};

-- print(PluginService:IsPluginMode());

if(game:GetService("RunService"):IsClient() and not PluginService:IsPluginMode())then
	local GStorage = Engine:RequestUserGameContent();
	--local Channel;
	for a,b in pairs(GStorage.Sound.Effects.NotificationService)do
	
		--if(not Channel)then
			
		--end;
		local s = AudioChannel:AddAudio(a.."-Notifications",b);
			_t[a]=s;			
	end;
end;

local function HandleMusic(p)
	if(not NotificationsEnabled)then return end;
	local AudioName = p.Name.."-Notifications";
	if(AudioChannel:GetAudio(AudioName))then
		AudioChannel:PlayAudio(AudioName)
	end
	
	--if(_t[p.Name])then
		--_t[p.Name]:Play();
	--end

end;

--[=[
	@private
]=]
function NotificationService:HandleNotificationRequest(...:any)
	
	if(typeof(...) == "table")then
		local t = ...;
		if(t.NotificationMethod)then
			if(t.NotificationMethod == "Subtitle")then
				local defaultSubtitle = CoreGuiService:WaitFor("Subtitle");
				if(not defaultSubtitle)then
					return ErrorService.tossWarn("CoreSubtitle has not been registered yet, failed to send notification");
				end;
				local props = {
					TextSize = t.BodyTextSize;
					TextColor3 = t.BodyTextColor3;
				}
				local subtitle = defaultSubtitle:new(t.Body,props,t.Lifetime,t.Priority,t.Header);
				local AttachBtn1, AttachBtn2;
				if(t.AttachButton)then
					AttachBtn1 = subtitle:AddButton(t.AttachButton,"attachbutton1");
				end;if(t.AttachButton2)then
					AttachBtn2 = subtitle:AddButton(t.AttachButton2,"attachbutton2");
				end;
				return subtitle,AttachBtn1,AttachBtn2;
			elseif(t.NotificationMethod == "Chat")then
				print("Sending as chat");
				return;
			end

		end
		
	end
	
	local defaultNotificationGroup = CoreGuiService:WaitFor("NotificationGroup");
	if(not defaultNotificationGroup)then
		return ErrorService.tossWarn("CoreNotification has not been registered yet, failed to send notification");
	end;
	

	if(lastNotification and lastNotification.toast and lastNotification.toast._dev)then
		if(match(lastNotification.t,...))then
			--lastNotification
			if(not lastNotification.toast._dev.badge)then
				local Pseudo = require(script.Parent.Parent.Parent.Pseudo);
				local Badge = Pseudo.new("Badge",lastNotification.toast:GET("ToastWrapper"));
				Badge.Text = "2";
				lastNotification.toast._dev.badge = Badge;
			else
				local badge = lastNotification.toast._dev.badge;
				badge.Text = tostring(tonumber(badge.Text)+1);
			end;return;
		end
	end
	
	
	--local defaultNotificationGroup = try();
	local a,b,c,d = defaultNotificationGroup:Notify(...);
	NotificationService.OnNotification:Fire(a);
	
	lastNotification = {
		t = ...;
		toast = b;
		n = a;
	}
	
	HandleMusic(a.Priority);
	
	return a,b,c,d
end;

return NotificationService;
