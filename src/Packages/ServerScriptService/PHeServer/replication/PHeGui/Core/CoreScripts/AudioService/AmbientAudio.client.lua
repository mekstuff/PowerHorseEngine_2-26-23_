local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Config = App:GetConfig();
local ConfigGame = Config.Game;
local AudioService = App:GetService("AudioService");


local AmbientChannel;

if(ConfigGame.AmbientMusic)then
	AmbientChannel = AudioService:CreateChannel("AmbientMusic",1,1,false,false);
	for index,v in pairs(ConfigGame.Sound.Music.Ambient)do
		local SongName,SongId = v.Name,v.SoundId;
		AmbientChannel:AddAudio(SongName,SongId,nil,nil,false);
	end;
end


while ConfigGame.AmbientMusic do
	local AmbientMusicChannel = AudioService:GetChannel("AmbientMusic");
	local ChannelAudios = AmbientMusicChannel:GetAudios();
	for AudioName,v in pairs(ChannelAudios) do
		local Audio = AmbientMusicChannel:PlayAudio(AudioName);
		v.AudioInstance.Ended:Wait();
	end
	wait();
end
