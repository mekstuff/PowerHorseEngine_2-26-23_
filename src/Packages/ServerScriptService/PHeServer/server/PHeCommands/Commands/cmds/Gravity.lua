return {
	cmd = "Gravity";
	desc = "Sets the gravity of the game";
	req = "Admin";
	author = "me";
	args = {
		{
			var="Gravity",
			type="number",
			req=false,
			desc="",
			default=workspace.Gravity;
		};
	};
	exe = function(gravity)
		workspace.Gravity = gravity;
		return{
			success = true;
			message = "World gravity is now "..tostring(gravity);
		}
	end,
}