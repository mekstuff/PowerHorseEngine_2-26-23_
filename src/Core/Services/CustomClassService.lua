local CustomClassService = {}

--[[
function module:CreateClassAsync(ClassData,Parent,...)
	local Pseudo_CoreUtil = require(script.Parent.Parent.Parent.Pseudo.Core.Util);
	return Pseudo_CoreUtil.Create(ClassData,Parent,...);
end;
]]

--[=[
@class CustomClassService

`CustomClassService` is a way to create custom Pseudo elements into your projects.

:::warning
CustomClasses will not replicate, They are completely bounded to their environment. After creating a custom class
it cannot be constructed with .new
:::

:::warning
CustomClasses require a `.ClassName` property and a `:_Render` method. more about this is included in the example below
:::

Let's create a class that is responsible for teleporting players during rounds

```lua
	local TeleportClass = {
		Name = "TeleportClass", --> Optional
		ClassName = "TeleportClass", --> Required (Cannot be an existing built in ClassName)
		OtherProperty = "string",
		TextColor3 = Color3.new()
	};

	--//Required
	function TeleportClass:_Render()
		--//Before we continue, let's understand the :_Render Method
	end;
```

## :_Render

Whenever a class is in the process of being created, the `:_Render` method will be called upon. This method
will only be called `once` in the classes lifecycle. The class expects the :_Render function to return some sort of value
to understand how the component should be rendered.

There are two types of rendering, Array Rendering and Functional Rendering

### Array Rendering
With array rendering, you return a dictionary within the :_Render function.

```lua
	function TeleportClass:_Render()
		return {};
	end;
```
Within that dictionary you can pass a string as a key which represents a property of the class and a value which is callback
function that will be called whenever that property is changed

```lua
	function TeleportClass:_Render()
		-- You would most likely create components here (this is called only once)
		local TextLabel = Instance.new("TextLabel");
		return {
			["OtherProperty"] = function(newValue)
				-- this is called everytime "OtherProperty" changed, you must likely would not create components here.
				print("OtherPropertyChanged to : ", newValue);
				TextLabel.Text = newValue; -- this will now give the TextLabel a type of "Reactive" feel, since the text is now dynamically linked with our "OtherProperty" property.
			end;
		};
	end;
```

There's also some keys that are reserved that have different functionalities

#### _Components

Anything listed here will be stored in the components _Components list, which you can then use :GET to retrieve

```lua
	function TeleportClass:_Render()
		local TextLabel = Instance.new("TextLabel");
		return {
			["OtherProperty"] = function(newValue)
				print("OtherPropertyChanged to : ", newValue);
				TextLabel.Text = tostring(newValue);
			end;
			_Components = {
				ImportantTextLabel = TextLabel
			}
		};
	end;
	--Elsewhere:
		TeleportClassObject:GET("ImportantTextLabel");
```

#### _Mapping

Mapping is used to automatically link two properties with the same key and value type together.

```lua
	function TeleportClass:_Render()
		local TextLabel = Instance.new("TextLabel");
		return {
			["OtherProperty"] = function(newValue)
				print("OtherPropertyChanged to : ", newValue);
				TextLabel.Text = tostring(newValue);
			end;
			_Components = {
				ImportantTextLabel = TextLabel
			}
			_Mapping = {
				[TextLabel] = {
					"OtherProperty", -- this will not work because text labels do not have a property called "OtherProperty"
					"TextColor3", -- this will work because both the component and textlabel has a "TextColor3" which are Color3's
				}
			}
		};
	end;
```

### Functional Rendering

When using functional rendering, you need to return a function instead of a dictionary within the :_Render Method


```lua
	function TeleportClass:_Render()
		return function ()
			print("This is called whenever any property of the component is changed");
		end;

	end;
```

All :_Render functions pass a argument of "App" being the PowerHorseEngine module which it was created from.
With functional rendering, you now have access to a second argument which is passed "hooks"

learn more about functional rendering hooks `here`

Here's a quick example of using the `useEffect` along side the `useState` hook. We highly recommending viewing the `documentation` on it
for a better understanding


```lua
	function TeleportClass:_Render(App,hooks)
		local useState = hooks.useState;
		local useEffect = hooks.useEffect;

		local AwesomeState,setAwesomeState = useState(0);

		useEffect(function()
			print("This is only called when the state is changed")
		end,{AwesomeState});

		useEffect(function()
			print("This is only called when \"OtherProperty\" and \"TextColor3\" are changed")
		end,{"OtherProperty","TextColor3"})

		useEffect(function()
			local doCleanupOnPreviousLoop = false;
			for i = 1,AwesomeState,1 do
				if(doCleanupOnPreviousLoop)then break;end;
				print("Running at index : ",i);
				wait(1);
			end;
			return function ()
				--//This will cause the previous for loop if still running to end whenever this useEffect hook is called
				doCleanupOnPreviousLoop = true; 
			end;
			
		end,{AwesomeState})


		return function ()
			print("This is called whenever any property of the component is changed");
		end;

	end;
```

Great. Now that we understand the :_Render method, let's actually make the teleporting class

```lua
	-- somewhere is a module script on the server
	-- this is a very very basic example just for you to understand. we recommend looking into the `framework` library which is similar to `Knit`.

local TeleportClass = {
		Name = "TeleportClass",
		ClassName = "TeleportClass", 
		BannedFromTeleporting = {};
	};
	function TeleportClass:_Render()
		return {};
	end;

	function TeleportClass:TeleportUser(Player)
		if(self.BannedFromTeleporting[Player.UserId])then return end;
		Player.Character.BlahBlahBlah = BlahBlahBlah;
	end;

return CustomClassService:CreateClassAsync(TeleportClass);
```

]=]

--[=[
	Creates a custom class
	@return Pseudo
]=]
function CustomClassService:CreateClassAsync(ClassData:table,Parent:any,...:any)
	return require(script.Parent.Parent.Parent.Pseudo)._create(ClassData,Parent,...);
end

--[=[
	Alias for :CreateClassAsync
]=]
function CustomClassService:Create(...:any) return self:CreateClassAsync(...);end;

return CustomClassService

