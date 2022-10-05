local MainModule = require(script.Parent.Parent.Parent.MainModule);

return {
	cmd = "SetTheme";
	desc = "Sets the theme of the panel";
	req = "Player";
	args = {
		{var="Theme",type="string",req=false,desc="",default="Default"};
	};
	exe = function(Theme)
		return MainModule.SetTheme(Theme);
	end,
}