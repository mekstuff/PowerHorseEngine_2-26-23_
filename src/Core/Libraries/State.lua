local App = require(script.Parent.Parent.Parent);
--[[
local State = {};

function State.new(default)
	local s = App.new("State");
	if(default)then s.State = default;end;
	return s;
end;

function State.useState(...)
	local res = State.new(...);

	return res,function(newValue)
		if(newValue)then
			if(typeof(newValue) == "function")then
				-- print(res.State);
				local resfromstatecallback = newValue(res.State);
				res.State = resfromstatecallback;
			else
				res.State = newValue;
			end;
		end;
	end
end
-- State.useState = State.new;
]]

--[=[
	@class StateLibrary

	The state library is a library that manages states across your software. It elimates having the create a state with
	the .new constructor.

	Using :Import("State"); to import this library.

	```lua
		local State = :Import("State");
	```

	You can create new state by calling the state library as a function, it takes an optional argument of the default value of the state
	```lua
		local State = :Import("State");

		local NumberState = State(0);
	```

	The state function returns the new created state and a set function which you can use to set the state later on.

	```lua
		local State = :Import("State");

		local NumberState,setNumberState = State(0);

		task.wait(2);
		setNumberState(1) --> NumberState will now be one
	```

	You can also use a callback function when using the set function, here you will be provided with the old state as an argument
	```lua
		setNumberState(function(oldState)
			return oldState+1; --> NumberState will now be 2, because it was previously 1
		end);
	```
]=]

return function(default)
	local res = App.new("State");
	res.State = default;

	return res,function(newValue)
		-- if(newValue)then
			if(typeof(newValue) == "function")then
				-- print(res.State);
				local resfromstatecallback = newValue(res.State);
				res.State = resfromstatecallback;
			else
				res.State = newValue;
			end;
		end;
	-- end
end