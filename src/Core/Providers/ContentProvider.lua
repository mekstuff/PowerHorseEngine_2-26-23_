local ImageProvider = require(script.Parent.Parent.Parent):GetProvider("ImageProvider");
--[=[
    @class ContentProvider
    A Provider that uses ImageProvider that uses [ImageProvider]:RequestUri
    Content Provider does not provide any extra features but only has 
    a different name because [ImageProvider] Uri's can also be sounds, etc.
]=]
local ContentProvider = {};

--[=[
    @return Promise|string
]=]
function ContentProvider:Uri(string:string,promise:boolean?)
    return ImageProvider:RequestUri(string,promise)
end;

return ContentProvider;