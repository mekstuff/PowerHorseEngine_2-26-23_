local App = require(script.Parent.Parent.Parent);
local matcher = "^ico%-(%w+)@(.+)";
local loadedpacks={};

--[=[
    @class ImageProvider
    @tag Provider
]=]

local ImageProvider = {};

--[=[
    @return string | Promise
]=]
function ImageProvider:RequestUri(src:string,promise:boolean):string?
    return promise and self:RequestImageUri(src) or self:GetImageUri(src,true);
end

--[=[
    @return Promise
]=]
function ImageProvider:RequestImageUri(img:string)
    local Promise = App.new("Promise");
    Promise:Try(function(resolve,reject)
        local s,r = pcall(function()
            return ImageProvider:GetImageUri(img,true);
        end)
        if(s)then
            resolve(r or "");
        else
            reject(r);
        end
    end);
    return Promise;
end

--[=[]=]
function ImageProvider:GetImageUri(img:string,warnsAreErrors:boolean):string
    local warn = warn;
    if(warnsAreErrors)then warn = error;end;
    if(not img)then return nil end;
    local iconpack,iconname = img:match(matcher);

    if(not iconpack and not iconname)then
        -- ImageContent.Image = img;
        return img;
    else
        local Engine = App:GetGlobal("Engine");
        local ContentFolder = Engine:RequestContentFolder();
        local ico = ContentFolder:FindFirstChild("ico");
        if(not ico)then
            warn("tried using "..img.." but the ico folder is missing from content. Will now WaitForChild");
        end;
        ico = ContentFolder:WaitForChild("ico");
        local packmodule = loadedpacks[iconpack];
        if(not packmodule)then
            local t = ico:FindFirstChild(iconpack);
            if(not t)then
                warn("tried using "..img.." but the icon pack module is missing from ico. Will now WaitForChild");
            end;
            t = ico:WaitForChild(iconpack);
            loadedpacks[iconpack] = require(t);
            packmodule = loadedpacks[iconpack];
        end;
        if(loadedpacks[iconpack] == "$wait")then
            return "";
        end
        local link;
        if(typeof(loadedpacks[iconpack]) == "table")then
            local path = iconname:split("/");
            if(#path == 1)then
                link = packmodule[path[1]];
            else
                local lastpath = packmodule;
                for _,v in pairs(path) do
                    local t = lastpath[v];
                    if(not t)then
                        warn("could not find ico path "..img.." failed @ "..v);
                        return "" --> your software won't error, images will just not be shown
                    end
                    lastpath = t;
                end;
                link = lastpath;
            end;
        else
            link = loadedpacks[iconpack](iconname);
        end;
        return link;
    end;
end;

return ImageProvider;