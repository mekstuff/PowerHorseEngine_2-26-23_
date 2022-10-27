local TweenService = game:GetService("TweenService");
local SignalProvider = require(script.Parent.Parent.Providers.SignalProvider);

--[=[
	@class AudioService
]=]
local AudioService = {}
AudioService.ChannelCreated = SignalProvider.new();

local Channels = {};

--[=[]=]
function AudioService:GetChannel(Name:string)
	if(not Channels[Name]) then
		local ct = 0;
		local t = 120;
		repeat wait(); ct+=1; until Channels[Name] or ct>=t;
		local App = require(script.Parent.Parent.Parent);
		local ErrorService = App:GetService("ErrorService");
		ErrorService.tossWarn("Infinite Possible Yield Waiting For Audio Channel: "..Name);
	end
	return Channels[Name];
end;

--[=[]=]
function AudioService:GetChannels() return Channels;end;

--[=[]=]
function AudioService:RemoveChannel(ChannelName:string)
	local Channel = Channels[ChannelName];
	for _,v in pairs(Channel.Audios)do
		v:Destroy();
	end;
	
	Channel.MuteChanged:Destroy();
	Channel.AudioAdded:Destroy();
	Channel.AudioRemoved:Destroy();
	Channel.AudioMuteChanged:Destroy();
	Channel.DefaultAudioTriggered:Destroy();
	
	setmetatable(Channels[ChannelName], nil);
	Channels[ChannelName]=nil;Channel=nil;
	print("Removed Channel: "..ChannelName)
end

--[=[
	@class AudioChannel
]=]
local AudioChannel = {};

--[=[]=]
function AudioChannel:Destroy()
	AudioService:RemoveChannel(self.Name);
end;
--[=[]=]
function AudioChannel:SetAudioMuted(AudioName:string,State:boolean,AudioInstance:any)
	if(not AudioInstance)then
		for _,q in pairs(self.Audios)do
			if(q.Name == AudioName)then	
				AudioInstance = q;
				break;
			end;
		end
	end
	if(State == true) then
		AudioInstance.Muted=true;
		AudioInstance.AudioInstance.Volume = 0;
	else
		AudioInstance.Muted=false;
		AudioInstance.AudioInstance.Volume = AudioInstance.Volume;
	end;
end

--[=[]=]
function AudioChannel:GetAudio(AudioName:string)
	return self.Audios[AudioName];
end
--[=[]=]
function AudioChannel:GetAudios()
	return self.Audios;
end

--//
local function getAudioFromChannel(Channel,AudioName)
	if(not Channel.Audios[AudioName])then
		local ct = 0;
		local t = 60;
		repeat wait(); ct+=1; until Channel.Audios[AudioName] or ct>=t;
		local App = require(script.Parent.Parent.Parent);
		local ErrorService = App:GetService("ErrorService");
		ErrorService.tossWarn("Infinite Possible Yield Waiting For Audio Channel: "..AudioName);
		return;
	end
	return Channel.Audios[AudioName];
end
--[=[]=]
function AudioChannel:SetDefaultAudio(AudioName:string)
	for _,v in pairs(self.Audios)do
		v.isDefaultAudio=false
	end;
	getAudioFromChannel(self,AudioName).isDefaultAudio=true;

end


--//
local function defaultAudioPlay(self)
	if(#self.ActiveAudios <= 0)then
		if(self.DefaultAudio)then
			local targetDefault = getAudioFromChannel(self,self.DefaultAudio);
			if(targetDefault)then
				self:PlayAudio(self.DefaultAudio);
				self.DefaultAudioTriggered:Fire(targetDefault);
			end;
		end;
	end
end;

local function removeFromActiveList(self,AudioName)
	for index,v in pairs(self.ActiveAudios)do
		if(v.Name == AudioName)then
			table.remove(self.ActiveAudios,index); break;
		end
	end;
end
--[=[]=]
function AudioChannel:SetVolume(Volume:number)
	for _,v in pairs(self.ActiveAudios)do
		v.Volume = Volume;
	end;
	self.DefaultVolume = Volume;
end;

--//
local _info = TweenInfo.new(2,Enum.EasingStyle.Quart);
local _infoOut = TweenInfo.new(.4,Enum.EasingStyle.Quart);

local function TweenAudioIn(Obj,self)
	local Vol = Obj.Muted and 0 or Obj.Volume;
	if(Obj.Instant)then
		Obj.AudioInstance.Volume = Vol;
		return;
	end;
	TweenService:Create(Obj.AudioInstance, _info,{Volume=Vol}):Play();
end;
--//

local function TweenAudioOut(Obj,self)
	if(Obj.Instant)then
		--Obj.AudioInstance.Volume = 0;
		return;
	end
	local t = TweenService:Create(Obj.AudioInstance, _infoOut,{Volume=0});
	t:Play();
	t.Completed:Wait();
end;
--[=[]=]
function AudioChannel:Mute()
	if(not self.Muted)then
		self.Muted=true;
		for _,v in pairs(self.Audios)do
			--v.Muted=true;
			AudioChannel:SetAudioMuted(nil,true,v);
		end
	end
end;
--[=[]=]
function AudioChannel:Unmute()
	if(self.Muted)then
		self.Muted=false;
		for _,v in pairs(self.Audios)do
			v.Muted=false;
			self:SetAudioMuted(nil,false,v);
		end;
		for _,q in pairs(self.ActiveAudios)do
			--print(q.Name);
			--AudioChannel:SetAudioMuted(nil,false,q);
			--self:PlayAudio(q.Name,true);
		end
	end;
end;

--[=[]=]
function AudioChannel:PlayAudio(AudioName:string,FromPaused:boolean)
	
	local TargetAudio = getAudioFromChannel(self,AudioName);
	
	if(TargetAudio.AudioInstance.IsPlaying)then return end;
	
	--if(TargetAudio.Muted)then return;end;


	if(#self.ActiveAudios+1 > self.AudiosAllowedInParallel)then
		self:PauseAudio(self.ActiveAudios[1].Name,true)
	end;

	TweenAudioIn(TargetAudio,self);
	
	if(TargetAudio.AudioInstance.IsPaused or FromPaused)then
		--TargetAudio:Resume();
		TargetAudio.AudioInstance:Resume();
	else
		--TargetAudio:Play();
		TargetAudio.AudioInstance:Play();
	end
	
	--print("Here x2");
	
	table.insert(self.ActiveAudios, TargetAudio);
	return TargetAudio;
end
--[=[]=]
function AudioChannel:StopAudio(AudioName:string,ignoreDefault:boolean)
	local TargetAudio = getAudioFromChannel(self,AudioName)
	if not (TargetAudio.AudioInstance.IsPlaying)then return end;
	TweenAudioOut(TargetAudio,self);
	--TargetAudio:Stop();
	TargetAudio.AudioInstance:Stop();
	removeFromActiveList(self,AudioName);
	if(not ignoreDefault)then
		defaultAudioPlay(self);
	end;
end



--[=[]=]
function AudioChannel:PauseAudio(AudioName:string,ignoreDefault:boolean,DoNotRemove:boolean)
	local TargetAudio = getAudioFromChannel(self,AudioName)
	if not (TargetAudio.AudioInstance.IsPlaying)then return end;
	TweenAudioOut(TargetAudio,self);
	--TargetAudio:Pause();
	TargetAudio.AudioInstance:Pause();
	if(not DoNotRemove)then
		removeFromActiveList(self,AudioName)
	end
	if(not ignoreDefault)then
		defaultAudioPlay(self);
	end;
end
--//
local AudioObjectMethods = {}
function AudioObjectMethods:Play()
	self.Channel:PlayAudio(self.Name);
	--self.AudioInstance:Play();
end;function AudioObjectMethods:Resume()
	self.AudioInstance:Resume();
end;function AudioObjectMethods:Stop()
	self.Channel:StopAudio(self.Name);
	--self.AudioInstance:Stop();
end;function AudioObjectMethods:Pause()
	self.Channel:PauseAudio(self.Name);
	--self.AudioInstance:Pause();
end;

function AudioObjectMethods:Destroy()
	removeFromActiveList(Channels[self.Channel],self.Name)
	self.AudioInstance:Destroy();
end
--[=[]=]
function AudioChannel:AddAudio(AudioName:string,AudioID:number,AudioVolume:number,Looped:boolean,PlayAudio:boolean,Instant:boolean)
	if(self.Audios[AudioName])then
		local App = require(script.Parent.Parent.Parent);
		local ErrorService = App:GetService("ErrorService");
		ErrorService.tossWarn("Audio ["..AudioName.."] Is Already A Audio Of Channel ["..self.Name.."]");
		return self.Audios[AudioName];
	end;
	
	AudioVolume = AudioVolume or self.DefaultVolume;
	if(typeof(AudioID)~="string")then tostring(AudioID);end;
	AudioID = AudioID and (AudioID:match("^rbxassetid://") and AudioID or "rbxassetid://"..AudioID) or ""
	-- AudioID = AudioID and "rbxassetid://"..tostring(AudioID) or "";
	Looped = Looped or self.DefaultLoop;
	
	local newAudio = Instance.new("Sound");
	--newAudio.Volume = AudioVolume;
	newAudio.SoundId = AudioID;
	newAudio.Volume=0;
	newAudio.Parent = workspace;
	
	local Audio = {};
	local AudioProxy = {
		Name = AudioName;
		SoundId = AudioID;
		Volume = AudioVolume;
		AudioInstance = newAudio;
		Looped = Looped;
		--Channel = self.Name;
		Channel = self;		
		Instant = Instant or self.AudiosInstant;
		Muted=false;
	};
	
	
	for prop,v in pairs(AudioProxy)do
		if not (prop == "Muted" or prop == "AudioInstance" or prop =="Volume" or prop == "Channel" or prop == "Instant" )then
			newAudio[prop]=v;
		end
	end
	
	setmetatable(Audio, {
		__index = function(t,k)
			if(AudioObjectMethods[k])then
				return AudioObjectMethods[k];
			end
			return AudioProxy[k];
		end,
		__newindex = function(t,k,v)
			pcall(function()
				Audio.AudioInstance[k]=v;
			end);
			rawset(AudioProxy,k,v);
			if(k == "Muted")then
				--selfself:Pause
				--self:PauseAudio(AudioName);
				--Audio:Pause();
				--if(k == )
				self.AudioMuteChanged:Fire(newAudio, v);
			end
		end,
	})
	
	
	self.Audios[AudioName]=Audio;
	self.AudioAdded:Fire(Audio);
	if(PlayAudio)then
		self:PlayAudio(Audio.Name);
	end;
	return Audio;
end;
--[=[]=]
function AudioService:CreateSoundEffectsChannel(ChannelName:string)
	return AudioService:CreateChannel(ChannelName or "SoundEffects",15,nil,nil,true);
end
--[=[
	@return AudioChannel
]=]
function AudioService:CreateChannel(ChannelName:string, AudiosAllowedInParallel:number, DefaultVolume:number, DefaultLoop:boolean, AudiosInstant:boolean):Instance
	
	if(Channels[ChannelName])then  return Channels[ChannelName];end;
	--local SignalProvider = require(script.Parent.Parent.Parent.):GetProvider("SignalProvider");
	
	
	local ChannelMuteChangedSignal = SignalProvider.new();
	local ChannelAudioAddedSignal = SignalProvider.new();
	local ChannelAudioRemovedSignal = SignalProvider.new();
	local ChannelAudioMuteChangedSignal = SignalProvider.new();
	local ChannelAudioDefaultTriggeredSignal = SignalProvider.new();
	
	
	
	AudiosAllowedInParallel = AudiosAllowedInParallel or 1;
	DefaultVolume = DefaultVolume or 1;
	DefaultLoop = DefaultLoop or false;
	
	local newChannel = {};
	newChannel.Name = ChannelName;
	newChannel.Audios = {};
	newChannel.AudiosAllowedInParallel = AudiosAllowedInParallel;
	newChannel.DefaultVolume = DefaultVolume;
	newChannel.DefaultLoop = DefaultLoop;
	newChannel.ActiveAudios = {};
	newChannel.DefaultAudio=nil;
	newChannel.AudiosInstant = AudiosInstant or false;
	
	newChannel.MuteChanged = ChannelMuteChangedSignal;
	newChannel.AudioAdded = ChannelAudioAddedSignal;
	newChannel.AudioRemoved = ChannelAudioRemovedSignal;
	newChannel.AudioMuteChanged = ChannelAudioMuteChangedSignal;
	
	newChannel.DefaultAudioTriggered = ChannelAudioDefaultTriggeredSignal;
	
	
	
	--newChannel.
	
	setmetatable(newChannel, {__index=AudioChannel});
	
	Channels[ChannelName]=newChannel;
	
	AudioService.ChannelCreated:Fire(newChannel);
	
	return newChannel;
	
end;

--[=[]=]
function AudioService:MuteChannel(ChannelName:string)
	if(Channels[ChannelName])then
		Channels[ChannelName]:Mute();
	end;
	self.MuteChanged:Fire(true);
end
--[=[]=]
function AudioService:UnmuteChannel(ChannelName:string)
	if(Channels[ChannelName])then
		Channels[ChannelName]:Unmute();
	end
	self.MuteChanged:Fire(false);
end


return AudioService
