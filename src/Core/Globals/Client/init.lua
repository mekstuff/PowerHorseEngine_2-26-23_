local Client = {}
local CustomClassService = require(script.Parent.Parent.Services.CustomClassService);

local PlayerMouse;

function Client:GetMouse()
	if(PlayerMouse)then
		return PlayerMouse;
	else
		PlayerMouse = CustomClassService:Create(require(script.PlayerMouse));
		return PlayerMouse;
	end
end;

return Client
