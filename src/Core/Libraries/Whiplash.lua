
--[=[
    @class Whiplash
    @tag Library
    
    Library similar to the awesome `Fusion`, But implemented for a more PowerHorseEngine workflow. 

    :::info How you should import
    Whiplash provides functions which you will read about below, It is recommended that you use these functions as variables

    ```lua
    local New = :Import("Whiplash").New;

    New "$Text" {
        New "$AnotherClass" {}
    }
    ```

    Than having to reference the entire library when pointer to a function

    ```lua
    local Whiplash = :Import("Whiplash");

    Whiplash.New "$Text" {
        Whiplash.New "$AnotherClass" {}
    }
    ```
    
    :::
]=]

local Whiplash = {};


--[=[
    The state library is very useful when working with whiplash. 

    You can import the state Library by using `PowerHorseEngine:Import("State")`;

    Learn more about `states` [here]

    :::info Button Increment Example
    ```lua
    --> Local script
    local State = :Import("State");
    local Whiplash = :Import("Whiplash");
    local New,OnEvent = Whiplash.New,Whiplash.OnEvent;

    local ClickCount,setClickCount = State(0);
    local ButtonDisplayText,setButtonDisplayText = State("");

    ClickCount:useEffect(function()
        setButtonDisplayText("You clicked "..tostring(ClickCount()).." times");
    end);

    New "ScreenGui" {
        Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui");
        Name = "WhiplashExample1"
        New "$Button" {
            AnchorPoint = Vector2.new(.5,.5);
            Position = UDim2.fromScale(.5,.5);
            Text = ButtonDisplayText;
            [OnEvent "MouseButton1Down"] = function()
                setClickCount(function(oldClickCount)
                    return oldClickCount+1;
                end);
                --[[
                alternatively we could've updated the ButtonDisplayText here instead of using the effect of click count
                the downside of that is if clickCount was updated elsewhere, the ButtonDisplayText will not be updated.
                    
                Alternate:
                    setButtonDisplayText("You clicked "..tostring(ClickCount()).." times);
                ]]
            end;
        }
    }

    ```

    :::


    @method State
    @within Whiplash

]=]

local function _getInstance(Class)
    local App = require(script.Parent.Parent.Parent);

    if(typeof(Class) == "string")then
        local isPseudoInstance = Class:match("^%$");
        if(isPseudoInstance)then
            local r = Class:gsub("^%$","");
            return App.new(r);
        else
            return Instance.new(Class);
        end
    end;
end;

local function getProperParent(x)
    return x:GET("_Appender") or x:GET("FatherComponent") or x:GetGUIRef();
end;

--[=[
    @within Whiplash
    Creates a new component based off of the class. Whiplash is not centered around Pseudo components, You can 
    build Instance as well.

    To create an Instance, you will just pass the ClassName as the class argument. Similar to Instance.new 
    But to create a Pseudo component, you need to put `$` at the start of the class.

    :::info
    `$Text` - Pseudo "Text" Component

    `TextLabel` - Roblox "TextLabel" Component
    :::info
]=]

local function getThisValue(object:any,thispath:string):any
    local lastDirectory = object;
    local paths = thispath:split("&/");
    for _,n in pairs(paths) do
        print(n,lastDirectory);
        lastDirectory = lastDirectory[n];
    end;
    return lastDirectory;
end;

function Whiplash.New(class:string):any
    local Obj = _getInstance(class);
    return function (props)
        local targetParent;
        local toExecute = {};
        local infollowOrder;
        if(props)then
            for property,value in pairs(props) do
                
                local skipSet = false;

                --> Using this()
                if(typeof(value) == "table" and value["_%this_meta-Lanzo%"] == true)then
                    if(value._followOrder)then
                        infollowOrder = infollowOrder or {};
                        table.insert(infollowOrder, {property = property, path=value._path});
                        skipSet = true;
                    else
                        value = getThisValue(Obj,value._path)
                    end
                end;

                if(not skipSet)then
                    if(typeof(property) == "string")then
                        if(property~="Parent")then
                            Obj[property]=value;
                            -->Tracking states to be deleted after;
                            -- if(typeof(value) == "table" and value.IsA and value:IsA("Pseudo") and )
                        else
                            targetParent = value;
                        end;
                    elseif(typeof(property) == "function")then
                        table.insert(toExecute, {property = property, value = value})
                    elseif(typeof(property) == "number" and (typeof(value) == "Instance" or typeof(value) == "table"))then
                        if(Obj:IsA("Pseudo") and value:IsA("Instance"))then
                            value.Parent = getProperParent(Obj);
                        else
                            value.Parent = Obj;
                        end
                    end
                end;
            end;
        end;
        Obj.Parent = targetParent;

        for _,x in pairs(toExecute) do
            x.property(Obj,x.value);
        end;

        if(infollowOrder)then
            for _,x in pairs(infollowOrder) do
                Obj[x.property] = getThisValue(Obj,x.path);
            end;
        end;
      
        toExecute = nil;
        return Obj;
    end

end;


--[=[]=]
function Whiplash.this(followOrder:boolean?):table
    if(followOrder == nil)then followOrder = true;end;
    local _path = "";
    local scope = {
        ["_%this_meta-Lanzo%"] = true;
        _followOrder = followOrder or false;
        _path = "";
    };
    local meta;
    meta = setmetatable(scope, {
        __index = function(t:table,key:string,...)
            if(key == "OnChange")then
                return Whiplash.OnChange;
            end;
            if(key == "OnEvent")then
                return Whiplash.OnEvent;
            end;
            t._path = _path == "" and key or _path.."&/"..key;
            _path = t._path;
            return meta;
        end;
    })
    return meta;
end

--[=[]=]
function Whiplash.Execute(a:any,b:any)
    b(a);
end;

--[=[
    `ForEach` let's you create loops within Whiplash components. If you return a component, that component will
    automatically be parented to the component in which the loop is in.

    In this example, we will create a text for every object in workspace which will be parented to our frame.
    ```lua
        local Whiplash = :Import("Whiplash");
        local New,ForEach = Whiplash.New,Whiplash.ForEach;
        New "$Frame" {
            ForEach(workspace:GetChildren()) = function(this,index)
                return New "$Text" {
                    Text = this.Name;
                    Name = tostring(index);
                }
            end;
        };
    ```
]=]
function Whiplash.ForEach(loop:{})
    return function (p,callback)
       for i,v in pairs(loop) do
            local res = callback(v,i);
            if(res)then
                assert(res and (typeof(res) == "table" or typeof(res) == "Instance") and res.IsA and (res:IsA("Instance") or res:IsA("Pseudo")), ("WhiplashError: You returned a value that is not an instance or pseudo. You returned : %s"):format(tostring(res)))
                res.Parent = p;
            end
       end 
    end
end;

--[=[
    Listen in on PropertyChanged Signals

    ```lua
    local Whiplash = :Import("Whiplash");
    local New,OnChange = Whiplash.New,Whiplash.OnChange;

    New "$Text" {
        [OnChange "Name"] = function(this) --> this/self
            print(this," New name is ", this.Name)
        end;
    }

    ```
]=]
function Whiplash.OnChange(Event:string)
    return function(obj,callback)
        return obj:GetPropertyChangedSignal(Event):Connect(function(...)
            callback(obj,...)
        end)
    end;   
end;

--[=[
    Listen in on Events

    ```lua
    local Whiplash = :Import("Whiplash");
    local New,OnEvent = Whiplash.New,Whiplash.OnEvent;

    New "$Button" {
        [OnEvent "MouseButton1Down"] = function(this) --> this/self
            print("You pressed a button!")
        end;
    }

    ```
]=]
function Whiplash.OnEvent(Event:string)
    return function(obj,callback)
        return obj[Event]:Connect(function(...)
            callback(obj,...)
        end)
    end;
end

--[=[
    Used as a wrapper for children of a Whiplash component. You do not need to use this function 
    because any Instance/Pseudo inside of a component will be automatically detected as a children
    @private
]=]
function Whiplash.Children(Parent:Instance,Value:any)

    if(typeof(Value) == "table")then
        for _,x in pairs(Value) do
            x.Parent = Parent;
        end
    else
        Value.Parent = Parent;

    end
    -- print(Parent) 
    
end



return Whiplash;