local module = {}
local IsClient = game.Players.LocalPlayer;
local ErrorService = require(script.Parent.ErrorService);



local Connection;

local UserTags = {};

local ServerScriptService = game:GetService("ServerScriptService");
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"));

--local SpeakerWaitConnection;
--local SpeakerWaitIndex = 0;


function module:AddChatTag(Player, TagInformation)
	
	if(IsClient)then ErrorService.tossWarn("Add Chat Tag Can Only Be Called By The Server") return end;
	
	local Speaker = ChatService:GetSpeaker(Player.Name);
	
	if(not Speaker)then
		local bind = Instance.new("BindableEvent");
		--bind.Name = "bindableYieldFor-"..Player.Name;
		--SpeakerWaitIndex+=1;
		local waitFor;
		waitFor = ChatService.SpeakerAdded:Connect(function(SpeakerName)
			--print(SpeakerName)
			if(SpeakerName == Player.Name)then
				--print("Found");
				waitFor:Disconnect();waitFor=nil;
				Speaker = ChatService:GetSpeaker(SpeakerName);
				bind:Fire();
			end;
		end)
		bind.Event:Wait();
		bind:Destroy();
	end;
	
	TagInformation = TagInformation or {};
	TagInformation.TagText = TagInformation.TagText or "??";
	
	
	if(Speaker)then
		local t = Speaker:GetExtraData("Tags");
		if(t)then
			table.insert(t, TagInformation);
			--print(x);
			Speaker:SetExtraData("Tags",t);
		else
			Speaker:SetExtraData("Tags",{TagInformation});
		end;
		--Speaker:SetExtraData("Tags",{TagInformation});
		--print(Speaker:GetExtraData("Tags"));
		--
	end
	
	--UserTags[Player.UserId] = UserTags[Player.UserId] or {};
	
	--table.insert(UserTags[Player.UserId], TagInformation);
	--[[
	if(not Connection)then
		Connection = ChatService.SpeakerAdded:Connect(function(name)
			
		end)
	end
	]]
	
end;

function module:GetChatTags(Player)
	
end;

return module
