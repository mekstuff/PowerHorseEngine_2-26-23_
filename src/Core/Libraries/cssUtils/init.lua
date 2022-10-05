local App = require(script.Parent.Parent.Parent);
local Engine = App:GetGlobal("Engine");
local Content = Engine:RequestContentFolder();
local cssFile = require(Content:WaitForChild("css"));

local usinglibs = {}

local cssUtils = {};

function cssUtils:using(lib)
    if(usinglibs[lib])then return end;
    assert(script:FindFirstChild(lib), "Unknown css util library \""..tostring(lib).."\".");
    local c = require(script:FindFirstChild(lib));
    for a,b in pairs(c) do
        if(cssFile[a])then
            warn("cssUtils force overwrite on \""..a.."\" by library : \""..lib.."\". any existing components using old properties will still apply until changed/removed.");
        end
        cssFile[a]=b;
    end
end;


return cssUtils;