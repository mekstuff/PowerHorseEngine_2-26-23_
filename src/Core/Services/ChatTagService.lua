--[=[
	@class ChatTagService
]=]
local ChatTagService = {}
local IsClient = game.Players.LocalPlayer;
local ErrorService = require(script.Parent.ErrorService);

local ServerScriptService = game:GetService("ServerScriptService");
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"));

--[=[]=]
function ChatTagService:AddChatTag(Player:Player, TagInformation:{[any]:any}?)
	
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

--[=[]=]
function ChatTagService:GetChatTags(Player:Player)
	
end;

return ChatTagService
