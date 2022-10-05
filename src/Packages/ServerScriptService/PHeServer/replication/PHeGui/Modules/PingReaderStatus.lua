local PowerHorseEngine = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local PingReader = PowerHorseEngine:GetService("PingService"):RequestUserPingAsync();
local keybind = Enum.KeyCode.F8;
local HighestPingDetected = {
	p = 0;
	t = os.time();	
};
local curr;

local function getMs()
	return tostring(PingReader.ms);
end;local function getStatus()
	return PingReader.ConnectionStatus.Name;
end;local function getHighestPing()
	local time_ = math.floor(os.time()-HighestPingDetected.t);
	return tostring(HighestPingDetected.m).." from "..tostring(time_).."s ago";
end;

function m(link)
	local x = PowerHorseEngine.new("PHePrompt");
	x.Header = "Connection Status";
	x.Parent = script.Parent;
	local function s()
		if(PingReader.Ping > HighestPingDetected.p)then HighestPingDetected.p = PingReader.Ping;HighestPingDetected.t=os.time();HighestPingDetected.m = PingReader.ms;end;
		if(not PingReader.Enabled)then
			x.Body = "Your ping couldn't be determined because the PingReader is disabled.\n\nLast known ping: "..PingReader.ms;
		else
			x.Body = "Ping: "..getMs().."\n\nConnection Status: "..getStatus().."\n\nHighest Detected Ping: "..getHighestPing().."\n\n(Your ping is determined by how long it takes for you to request and recieve information from the server || Press "..keybind.Name.." to reset highest ping)";
		end;
	end;
	s();
	x._dev._pingreaderstatusc = PingReader:GetPropertyChangedSignal("Ping"):Connect(function()
		s();
	end);x._dev._pingreaderstatusa = PingReader:GetPropertyChangedSignal("Enabled"):Connect(function()
		s();
	end);
	if(link)then
		link:GetPropertyChangedSignal("Destroying"):Connect(function() x:Destroy();end);
	end;
	curr = x;

	x:GetPropertyChangedSignal("Destroying"):Connect(function()
		curr = nil;
	end)
	
	return x;
end


game:GetService("UserInputService").InputBegan:Connect(function(key)
	if(key.KeyCode == keybind)then
		if(curr)then
			HighestPingDetected = {
				p=0;
				m = "0";
				t = os.time();
			}
		else
			local z = m();
			local ended;
			ended = game:GetService("UserInputService").InputEnded:Connect(function(key)
				if(key.KeyCode == keybind)then
					ended:Disconnect();
					ended=nil;
					z:Destroy();
				end
			end)
		end
		
	end
end)

return m;