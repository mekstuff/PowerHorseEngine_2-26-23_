-- Written by Olanzo James @ Lanzo, Inc.
-- Tuesday, September 06 2022 @ 19:41:10
-- This icon pack uses roblox's /content/textures folder in local directory
-- This icon pack can only be used in ROBLOX studio, so plugin use only.
-- Built mainly for PowerHorseEngine projects


return function (uri)
    local fileType = uri:match("%.%w+$") and "" or ".png";
    local link = "rbxasset://textures/"..uri..fileType;
    return link;
end
