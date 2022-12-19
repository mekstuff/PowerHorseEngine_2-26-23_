local Engine = require(script.Parent.Parent.Parent.Engine);

local VoteKickEvent = Engine:FetchStorageEvent("VoteKickService_VoteKickUser");

--[=[
	@class VoteKickService
]=]
local VoteKickService = {}
local Tokens = {};

local function EndVote(id)
	
	if(Tokens[id])then

		local currtoken = Tokens[id];
		local totalYes = currtoken.TotalYVotes;
		local TotalYesVotesNeeded = currtoken.TotalYesVotesNeeded;
		local targetInstance = game:GetService("Players"):FindFirstChild(currtoken.TargetUsername);
		if(totalYes>=TotalYesVotesNeeded)then
			
		
			print("Kicking Player!");
			if(targetInstance)then
				
				local NotificationService = require(script.Parent.Parent.Providers.ServiceProvider):LoadServiceAsync("NotificationService");

				NotificationService:SendNotificationToAllPlayers(targetInstance.Name.." has been booted from the session.", 8);
			end
		else
			print("Can't Kick Player");
		end
		

		VoteKickEvent:FireAllClients("%update%", {
			id = id;
			dismiss = true;
			y = Tokens[id].TotalYVotes;
			n = Tokens[id].TotalNVotes;
		})
		
		Tokens[id]=nil;
		--local totalplayers = #game:GetService("Players"):GetPlayers();
	end	
end

--[=[]=]
function VoteKickService:SpawnToken(TargetUser:Player, TargetSender:Player?, TotalTime:number?, TotalVotes:number?)

	if(not game.Players:FindFirstChild(TargetUser.Name))then
		Engine.ErrorService.tossWarn(tostring(TargetUser and TargetUser.Name or "[?Unknown Argument?]").." is not a valid player instance. VoteKickService:SpawnToken(instance Player)");
		return;	
	end
	
	if(Tokens[TargetUser.UserId])then
		Engine.ErrorService.tossWarn(TargetUser.Name.." already has an existing token.");return;
	end
	
	local id = TargetUser.UserId;
	TotalVotes = TotalVotes or math.max(#game:GetService("Players"):GetPlayers()/2,1);


	local cln = TargetUser.Name or TargetUser;
	
	Tokens[id]={
		TargetUsername = cln;
		TotalNVotes = 0;
		TotalYVotes = 0;
		TotalYesVotesNeeded = TotalVotes;
		Voted = {};
	}
	
	local t = TotalTime or 60;
	
	VoteKickEvent:FireAllClients(cln, TargetSender.Name or "[Server]", t, id,TotalVotes);
	
	local thread=coroutine.create(function()
		wait(t+1);
		EndVote(id);
	end);coroutine.resume(thread);
	--
end;


VoteKickEvent.OnServerEvent:Connect(function(Plr,vote,id)
	if(Tokens[id])then
		local currToken = Tokens[id];
		if(table.find(currToken.Voted, Plr.Name))then print("Vote Already casted!"); return end;
		
		table.insert(currToken.Voted, Plr.Name);
		
		vote = vote == "y" and true or false;
		
		if(vote)then
			currToken.TotalYVotes+=1;else currToken.TotalNVotes+=1;
		end;
		
		local end_;
		
		if(#currToken.Voted >= currToken.TotalYesVotesNeeded)then EndVote(id);return;end;
		
		if(currToken.TotalYVotes >= currToken.TotalYesVotesNeeded)then EndVote(id);return; end;
		
		VoteKickEvent:FireAllClients("%update%", {
			id = id;
			y=currToken.TotalYVotes,
			n=currToken.TotalNVotes;
		})
		
	else
		print("Invalid Token");
	end
end)


return VoteKickService
