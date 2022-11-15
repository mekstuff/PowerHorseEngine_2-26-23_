local App = require(script.Parent.Parent.Parent);

--[=[
	@class StateLibrary
	@tag Library

	The state library is a library that manages states across your software. It elimates having the create a state with
	the .new constructor.

	:::warning
	This Library is only called `StateLibrary` for documentation purposes! You'll use `:Import("State")` to access this library not `:Import("StateLibrary")`.
	:::

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

local function getValue(v:any)
	if(v == nil)then return "**any";end;
	return v;
end;

return function(default:any)
	local res = App.new("State");
	res.State = getValue(default);
	return res,function(newValue)
		if(typeof(newValue) == "function")then
			local resfromstatecallback = newValue(res.State);
			res.State = getValue(resfromstatecallback);
		else
			res.State = getValue(newValue);
		end;
	end;
end