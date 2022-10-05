local MainModule = require(script.Parent.Parent.Parent.MainModule);

return {
	cmd = "ClearOutput";
	desc = "Clears all logs in the console";
	req = "Player";
	args = {
		--{var="",type="",req=nil,desc="",default=""};
	};
	exe = function()
		task.delay(game:GetService("RunService").RenderStepped:Wait(),function()
			MainModule.Console.clear();
		end)
		
	end,
}