--[=[
	@class PromptService
]=]
local PromptService = {}
local IsServer = game:GetService("RunService"):IsServer();
local ErrorService = require(script.Parent.ErrorService);
local Engine = require(script.Parent.Parent.Globals.Engine);
local CustomClassService = require(script.Parent.CustomClassService);
local PromptUserAsyncEvent = Engine:FetchStorageEvent("PromptUserAsyncEvent");

--[=[
	@class PromptResponse
	Pseudo returned from [PromptService]
]=]
local PromptResponse = {
	Name = "PromptResponse";
	ClassName = "PromptResponse";
};

local PromptsStorage = {};

function PromptResponse:_Render()
	return {};
end;
--[=[
	@return PromptResponse
]=]
function PromptService:PromptUser(User:Player,Header:string|{[any]:any},Body:string|nil?,Buttons:{[any]:any}?)
	if(not IsServer)then ErrorService.tossWarn("PromptUserAsync() can only be called by the server.");return end;
	if(not User)then ErrorService.tossWarn(tostring(User).." is not a valid user");return;end;
	
	if(typeof(Header) == "table")then
		Buttons = Body;
	else
		Header = {
			Header = Header;
			Body = Body;
		}
	end;

	local id = tostring(math.random(1,500));
	if(not  Buttons)then
		Buttons = {{
			Text = "Okay"; Id = "close";
		}}
	end
	
	PromptUserAsyncEvent:FireClient(User,Header,Buttons,id);
	
	local newPromptResponse = CustomClassService:CreateClassAsync(PromptResponse);
	
	newPromptResponse:AddEventListener("Response",true);
	--newPromptResponse.ID = id;
	--newPromptResponse._User = User;
	PromptsStorage[id]=newPromptResponse;
	
	task.delay(20*1000,function()
		print("Removing prompt from storage because of time");
		if(PromptsStorage[id])then
			if(PromptsStorage._dev)then
				PromptsStorage[id]:GetEventListener("Response"):Fire("close", "Close because of no response (Content could still be shown on the client, but the server no longer considers the prompt)");	
				PromptsStorage[id]:Destroy();
			end;
			PromptsStorage[id]=nil;
		end
	end)
	
	return newPromptResponse;
end;

if(IsServer)then
	PromptUserAsyncEvent.OnServerEvent:Connect(function(Player,id,...)
		--print(Player,id,PromptsStorage);
		if(PromptsStorage[id])then
			PromptsStorage[id]:GetEventListener("Response"):Fire(...);
			PromptsStorage[id]:Destroy();
			PromptsStorage[id]=nil;
		end
	end);
end;




return PromptService
