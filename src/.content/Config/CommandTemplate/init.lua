return {
	cmd = "Command"; --// Name of the command (cannot be an existing command)
	desc = "Description"; --// Description of the command
	req = "Admin";--// Rank of the command, ("Owner", "Admin", "Mod", "Player")
	args = { --//arguments that are needed for command
		{
			--//name of argument
			var="name",
			--//type of argument
			type="string",
			--//is this argument required?
			req=false,
			--//description of argument (can be nil)
			desc="awesome description",
			--//default value of this argument (can be nil)
			default="awesome sauce"};
	};
	--//executable that is triggered when the command is called. (will run on the server)
	exe = function(argument1)
		print(argument1); -->"awesome sauce"
	end,
}