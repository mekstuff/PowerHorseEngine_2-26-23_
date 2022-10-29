return function(Wrapper:Frame)
    local App = require(script.Parent.Parent.Parent);

    local DatePicker = App.new("DatePicker");

    DatePicker.Parent = Wrapper;
    return function ()
        DatePicker:Destroy();
    end;
end;