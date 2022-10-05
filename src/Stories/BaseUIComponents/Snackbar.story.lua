return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Snackbar = App.new("Snackbar",Wrapper);
    return function ()
        Snackbar:Destroy();
    end;
end