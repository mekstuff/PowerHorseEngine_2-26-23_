local CoreProviderService = {};

function CoreProviderService:CalculateUIAbsolutePosition(Position:UDim2,AnchorPoint:Vector2,Relative:Vector2)
    if(typeof(Position) ~= "UDim2")then 
        local i = Position;
        Relative = AnchorPoint;
        Position = i.Position;
        AnchorPoint = i.AnchorPoint;
        i = nil;
    end;

    if(typeof(Relative) ~= "Vector2")then Relative = Relative.AbsoluteSize;end;

    print(Position,Relative);

    -- print(Position-Relative)
    -- return Vector2.new()
end;

-- function CoreProviderService:GetIsWithinUI(TargetPosition:Vector3?,TargetAnchorPoint:Vector2?,TargetSize:Vector3?,ContentPosition:Vector3?,ContentAnchorPoint:Vector2,ContentSize:Vector2?):boolean
--     if(typeof(TargetPosition) ~= "Vector3")then
--         local object1 = TargetPosition;
--         local object2 = TargetAnchorPoint;

--         TargetPosition,TargetAnchorPoint,TargetSize = object1.Position,object1.AnchorPoint,object1.Size;
--         ContentPosition,ContentAnchorPoint,ContentSize = object2.Position,object2.AnchorPoint,object2.Size;
--     end;
-- end;


return CoreProviderService;