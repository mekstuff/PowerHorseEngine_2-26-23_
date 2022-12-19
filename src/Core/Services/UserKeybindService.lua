local UserKeybindService = {}
local UIS = game:GetService("UserInputService");

local UISConnection;

local UserKeybindDataList = {};

local function addKeys(...)
	local event = Instance.new("BindableEvent",workspace);
	event.Name = "UserKeyBindKeyEvent";
	local id = math.random(1,300)+math.random(1,300);
	table.insert(UserKeybindDataList, {binds = {...}, event = event, id = id});
	
	return event, id;
end

local function handleKeys()
	local KeysDown = UIS:GetKeysPressed();
	local TotalKeysDown = #KeysDown;
	
	for _,v in pairs(UserKeybindDataList) do
		if(#v.binds == TotalKeysDown)then
			local x = 0;
			for _,q in pairs(KeysDown)do
				if(table.find(v.binds, q.KeyCode))then x+=1;end;
				if(x == #v.binds)then
					v.event:Fire();
					break;
				end
				
			end
		end
	end
end

function UserKeybindService:BindKeybind(...:any):(RBXScriptSignal,any,...any)
	local e,id = addKeys(...)
	if(not UISConnection)then
		UISConnection = UIS.InputBegan:Connect(handleKeys);
	end;
	return e.Event, id, e;
end;


--//
function UserKeybindService:UnbindKey(id:any)
	for index,v in pairs(UserKeybindDataList) do
		if(v.id == id)then
			v.event:Destroy();v.event=nil;
			v.binds=nil;
			table.remove(UserKeybindDataList,index);
			print("Removed");
			break;
		end
	end
end;

--//
function UserKeybindService:ConvertBindsToString(...:any):string
	local Binds = {...};
	local String = "";
	
	for index,v in pairs(Binds) do
		--print(v)
		if(index == 1)then
			String = String..v.Name;
		else
			String = String.."+"..v.Name;
		end
	end
	
	return String;
	--if(#Binds < 0)then return String;end;
end

return UserKeybindService
