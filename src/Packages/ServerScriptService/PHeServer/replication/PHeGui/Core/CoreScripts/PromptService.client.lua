local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local Engine = PowerHorseEngine:GetGlobal("Engine");
local PromptUserAsyncEvent_ClientWait = Engine:FetchStorageEvent("PromptUserAsyncEvent");

PromptUserAsyncEvent_ClientWait.OnClientEvent:Connect(function(Content,Buttons,id)
	local Prompt = PowerHorseEngine.new("Prompt");
	--if(typeof(Header) == "table")then
		--Buttons = Body;
		--id = Buttons;
		for prop,val in pairs(Content)do
			Prompt[prop]=val;
		end
	--else
		--Prompt.Header = Header;
		--Prompt.Body = Body;
	--end

	if(Buttons)then
		for _,v in pairs(Buttons) do
			if(v.Id == "closeButton")then
				Prompt.CloseButtonVisible = true;
			else
				local btn = Prompt:AddButton(v.Text or "Button", v.Id);
				if(v.Color)then btn.BackgroundColor3 = v.Color;end;
			end;
		end
	end
	Prompt.ButtonClicked:Connect(function(btn,btnid)
		PromptUserAsyncEvent_ClientWait:FireServer(id,btnid,btn.Text);
		Prompt:Destroy();
	end)
	Prompt.Parent = script.Parent.Parent.Parent
end);