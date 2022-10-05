local UI = Instance.new("ScreenGui",game.Players.LocalPlayer.PlayerGui)

local Prompt = _G.Pseudo.new("Prompt",UI);


script.Parent = UI;

Prompt.Header = "Connection Lost";
Prompt.Body = "You lost connection from the server, Please try restarting your client.";
Prompt:AddButton("Rejoin");

