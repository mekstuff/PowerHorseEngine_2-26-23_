local CustomClassService = require(script.Parent.Parent.Services.CustomClassService);

local module = {}

local Class = {
	ClassName = "CutsceneSequence";
	Paused = false;
	Looped = false;
}

function Class:Play()
	self._stateBeforeAnimation = workspace.CurrentCamera.CameraType;
	for index,v in pairs(self._scenes)do
		local Anim = v:PlayScene();
		self._currentSceneAnimation = Anim;
		self:GetEventListener("SceneChanged"):Fire(self._scenes[index],index)
		Anim.Completed:Wait();
	end;
	self.Completed:Fire();
	self:ResetCamera();
	
end;


function Class:Pause()
	self.Paused = true;
end

function Class:ResetCamera()
	workspace.CurrentCamera.CameraType = self._stateBeforeAnimation;
end

function Class:_Render()
	
	self:AddEventListener("SceneChanged",true)
	self:AddEventListener("Completed",true)
	return {
		["Paused"] = function(State)
			if(self._currentSceneAnimation)then
				if(State)then
					self._currentSceneAnimation:Pause();
				else
					self._currentSceneAnimation:Play();
				end
			end
		end,
	};
end

function module.new(Cutscenes)
	local x = CustomClassService:Create(Class);
	x._scenes = Cutscenes;
	
	return x;
end;

return module
