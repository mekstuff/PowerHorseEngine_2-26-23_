local Theme = require(script.Parent.Parent.Parent.Theme);
local Enumeration = require(script.Parent.Parent.Parent.Enumeration);
local Core = require(script.Parent.Parent.Parent);
local IsClient = game:GetService("RunService"):IsClient();

local RadioGroup = {
	Name = "RadioGroup";
	ClassName = "RadioGroup";
    Selection = "**any";
};

RadioGroup.__inherits = {};

function RadioGroup:_Render(App)
	local StackProvider = App.new("StackProvider");
    StackProvider.Filter = "Radio";
    StackProvider.Provider = self:GetRef();
    local SelectedRadio;
    self._dev._connections = {};

    local SelectionChanged = self:AddEventListener("SelectionChanged",true);

    StackProvider.PseudoAdded:Connect(function(Pseudo)
        self._dev._connections[Pseudo._dev.__id] = Pseudo:GetPropertyChangedSignal("Selected"):Connect(function()
            if(Pseudo.Selected)then
                    if(self.Selection ~= Pseudo)then
                        local oldSelection = self.Selection;
                        if(oldSelection)then
                            oldSelection.Selected = false;
                        end
                        SelectionChanged:Fire(Pseudo, oldSelection);
                        self.Selection = Pseudo;
                    end
            else
                if(self.Selection == Pseudo)then
                    -- SelectionChanged:Fire(nil, Pseudo);
                    self.Selection = "**any";
                end
            end
        end);
    end);
    StackProvider.PseudoRemoved:Connect(function(Pseudo)
        if(SelectedRadio == Pseudo)then
            SelectionChanged:Fire(nil, Pseudo);
            self.Selection = "**any";
        end
        if(self._dev._connections[Pseudo._dev.__id])then
            self._dev._connections[Pseudo._dev.__id]:Disconnect();
            self._dev._connections[Pseudo._dev.__id] = nil;
        end;
    end);

	return {
		["Property"] = function(Value)
			
		end,
		_Components = {};
		_Mapping = {};
	};
end;


return RadioGroup
