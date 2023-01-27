# Building A Game With Sillito

## Server

On the server, Create a folder, Inside that folder add a server script and another nested folder, we recommended calling this nested folder `"Services"`

ServerScript:

```lua
--> Remove :PHeApp if you're not using ts
local App:PHeApp = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"))
local Sillito = App:Import("Sillito");

local Services = script.Parent:FindFirstChild("Services") --> Or Whatever you called the nested folder.

Sillito:PortServices(Services):Start():Then(function(res)
    print("Sillito Is Running On The Server");
end):Catch(function(err)
    error("Sillito Failed To Start On The Server! Error: "..err);
end);
```

Within the nested folder, create two Modules and name them Service1 & Service2. Paste the following scripts respectively.

```lua
local Service1 = {
    Shared = {} --> Service 1 Allows Client -> Server Communication with this Shared Prop
};

function Service1.Shared:MakeServerRequest(Player:Player)
    return "Request Done 1";
end

function Service1:Init()
    print(self.Name, "Was Initiated") --> Service1 Will be converted to a Pseudo, So it inherits Pseudo properties and methods
end;

function Service1:Start()
    print(self.Name, "Has Started");
    local Service2 = self:GetService("Service2");
    print(Service2:MakeServerRequest()) --> Request Done 2
end

return Service1;
```

```lua
local Service2 = {};

function Service2:Init()
    print(self.Name, "Was Initiated") --> Service2 Will be converted to a Pseudo, So it inherits Pseudo properties and methods
end;

function Service2:MakeServerRequest()
    return "Request Done 2";
end;

function Service2:Start()
    print(self.Name, "Has Started");
end

return Service2;
```

## Client

Now on the client, Create a folder, Inside that folder add a local script and another nested folder, we recommended calling this nested folder `"Modulars"`

LocalScript:

```lua
--> Remove :PHeApp if you're not using ts
local App:PHeApp = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"))
local Sillito = App:Import("Sillito");

local Modulars = script.Parent:FindFirstChild("Modulars") --> Or Whatever you called the nested folder.

Sillito:PortModulars(Modulars):Start():Then(function(res)
    print("Sillito Is Running On The Client");
end):Catch(function(err)
    error("Sillito Failed To Start On The Client! Error: "..err);
end);
```

Within the nested folder, create a `ModuleScript` and name it `Modular1` and paste the following script.

```lua
local Modular1 = {};

function Modular1:Init()
    print(self.Name, "Was Initiated") --> Modular1 Will be converted to a Pseudo, So it inherits Pseudo properties and methods
end;

function Modular1:Start()
    print(self.Name, "Has Started");
    local Service1 = self:GetService("Service1");
    print(Service1:MakeServerRequest())--> "Request Done 1"
    local Service2 = self:GetService("Service2") --> Results in an error because Service2 Does not have a Shared property
end

return Modular1;
```

This tutorial is just to give you a basic understanding of Sillito, There are more advanced features, Please learn more by reading its [API](/api/Sillito)