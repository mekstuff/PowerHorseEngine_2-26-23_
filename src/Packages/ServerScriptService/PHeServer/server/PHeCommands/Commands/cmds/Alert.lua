--local consts = require(script.Parent.Parent.Constants)
local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local PromptService = PowerHorseEngine:GetService("PromptService");

return {
	cmd = "Alert";
	desc = "Sends a prompt to the given player";
	req = "Mod";
	args = {
		{var="Player",type="player",req=true,desc="Player to be alerted."};
		{var="Message",type="string",req=true,desc=""};
		{var="Button 1",type="string",req=true,desc="Text for button 1, if this button is clicked the text will be outputed in the console", default = "Dismiss"};
		{var="Button 2",type="string",req=false,desc="Text for button 2, if this button is clicked the text will be outputed in the console"};
	};
	exe = function(plr,message,b1,b2)
		local t = {
			{Text = b1, Id = b1};
		};if(b2)then table.insert(t, {Text = b2, Id = b2});end;
		local Prompt = PromptService:PromptUserAsync(plr,"Prompt",message,t);
		local PromptResponse = Prompt.Response:Wait();
		return {
			message = "responded with "..PromptResponse;
		}

		
	end,
}