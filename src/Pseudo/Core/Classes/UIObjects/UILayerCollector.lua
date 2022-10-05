local UILayerCollector = {
    Name = "UILayerCollector";
    ClassName = "UILayerCollector";
    Provider = "**any";
};

function UILayerCollector:_Render(App)
    
    local StackProvider = App.new("StackProvider",self:GetRef());
    -- StackProvider.DirectChildrenOnly = true;
    StackProvider.Filter = "Pseudo";

    StackProvider.PseudoAdded:Connect(function()
        print("Added");
    end);

    StackProvider.PseudoRemoved:Connect(function()
        print("Removed");
    end);

    return {
        _Components = {
            StackProvider = StackProvider;
        };
        _Mapping = {
            [StackProvider] = "Provider";
        }
    };
end;

return UILayerCollector;