local Main = {};

function Main:Init()

end;
function Main:FetchItems(...:any)
    return self:GetService(self.Name):FetchItems(...)
end;


return Main;