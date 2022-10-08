-- Copyright © 2022 Lanzo Inc. All rights reserved.
-- Written by Olanzo James @ Lanzo, Inc.
-- Saturday, September 24 2022 @ 18:37:19
-- This will require mdi, causing it to load the actual module into your game during runtime.

local App = require(game:GetService("ReplicatedStorage"):WaitForChild("PowerHorseEngine"));
local content = App:GetGlobal("Engine"):RequestContentFolder();
local hasmdi = content:WaitForChild("ico"):FindFirstChild("mdi");
if(hasmdi)then
    require(hasmdi);
end;

script:Destroy();