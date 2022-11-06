--[=[
    @class ListItem

    Inherits [BaseGui], [Toast]
]=]
local ListItem = {
    Name = "ListItem",
    ClassName = "ListItem",
    Header = "",
    Body = "ListItem",
};
ListItem.__inherits = {"BaseGui","Toast"};

function ListItem:_Render()
    local App = self:_GetAppModule();
    local ListItemToast = App.new("Toast",self:GetRef());
    return {
        _Components = {
            FatherComponent = ListItemToast:GetGUIRef();
        },
        _Mapping = {
            [ListItemToast] = {
            "CloseButtonVisible";
            "HeaderTextSize";
            "HeaderTextColor3";
            "CanvasImage";
            "IconImage";
            "BackgroundColor3";
            "BackgroundTransparency",
            "Visible",
            "ZIndex",
            "xMax";
            "Header";
            "Body";
            "BodyTextColor3";
            "BodyTextSize";
            "Subheader";
            "CanCollapse";
            "Roundness";
            "Padding";
            }
        }
    };
end

return ListItem;