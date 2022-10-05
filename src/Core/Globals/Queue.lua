local module = {}

local CustomClassService = require(script.Parent.Parent.Services.CustomClassService);

local QueueClass = {
	ClassName = "Queue";
	Name = "Queue";
	Size = 2;
	AutoQueue = true;
};

function QueueClass:SetCallback(callBack)
	self._AutoCallback = callBack;
end

function QueueClass:Add(funcHandler, callBack)
	

	if(#self._QueueList > self.Size)then
		if(callBack)then
			callBack("Queue size of \""..self.Size.."\" cannot be exceeded.");
		else
			if(self._AutoCallback)then
				self._AutoCallback("Queue size of \""..self.Size.."\" cannot be exceeded.")
			end
		end
	else
		table.insert(self._QueueList, {
			Func = funcHandler;
			
		})
		if(#self._QueueList <= 1)then
		
			--print("Blah")
			self:Next();
		end;
	
		--QueueClass:
		--[[
		if(#self._QueueList == 0) then
			funcHandler(self);
		else
			--//Trigger Queue
		end
		]]
	end
end;
--//
function QueueClass:Clear()
	self._QueueList = {};
	self._CurrentQueue = 0;
end

--//

function QueueClass:Next()
	--print(self._QueueList);
local thread = coroutine.create(function()
	local nextQueue = self._CurrentQueue+1;
		local TargetQueue = self._QueueList[nextQueue];
	
	if(TargetQueue)then
			TargetQueue.Func(self);
			self._CurrentQueue = nextQueue;
		local NextInQueue = self._QueueList[nextQueue+1];
			if(NextInQueue) then
				if(self.AutoQueue)then
					self:Next();
				end
		else
			self:Clear();
		end
	end
end);coroutine.resume(thread)
end

function QueueClass:_Render()
	
	self._QueueList = {};
	self._CurrentQueue = 0;
	
	local firstRun = true;
	return {
		["AutoQueue"]=function(v)
			if(v == true)then
				--if(firstRun)then firstRun=false;return;end;
				
			end
		end,
	};
end

function module.new()
	local f = CustomClassService:Create(QueueClass);
	
	return f;
end

return module
