local ImageProvider = require(script.Parent.Parent.Parent):GetProvider("ImageProvider");
local ContentProvider = {};

function ContentProvider:Uri(string:string,promise:boolean?)
    return ImageProvider:RequestUri(string,promise)
end;

return ContentProvider;