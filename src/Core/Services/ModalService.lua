local CustomClassService = require(script.Parent.CustomClassService);
local Types = require(script.Parent.Parent.Parent.Types);

--[=[
    @class ModalService
]=]
local ModalService = {
    Name = "ModalService",
    ClassName = "ModalService",
};

--[=[
    Converts the target frame into a modal. For prompt usage, use Prompt:GET("Modal")
    if target Frame is an Instance, the [Pointer] Library will be used to convert to Pseudo.
]=]
function ModalService:ConvertToModal(Frame:any,TargetModal:Types.Modal|any?,ModalCloseButton:any?,ModalAppender:any?,ModalHeader:any?)
    local App = self:_GetAppModule();
    local ErrorService = App:GetService("ErrorService");
    if not(Frame:IsA("Pseudo"))then
        local Pointer = App:Import("Pointer");
        ErrorService.tossWarn("ConvertToModal expected a Pseudo, Pointer library will be used to convert.");
        Frame = Pointer(Frame);
    end;

    ModalHeader = ModalHeader or Frame:FindFirstChild("ModalHeader");
    ModalCloseButton = ModalCloseButton or Frame:FindFirstChild("ModalCloseButton");
    ModalAppender = ModalAppender or Frame:GetGUIRef();

    TargetModal = TargetModal or App.new("Modal");

    local Modal = TargetModal:GET("Modal");
    TargetModal._Components = {};
    local Components = TargetModal._Components;
    Components._Appender = ModalAppender;
    Components.FatherComponent = Frame:GetGUIRef();
    Components.Header = ModalHeader;

    TargetModal._Header = ModalHeader;
    TargetModal._MainFrame = Frame;
    
    if(TargetModal._dev._closebuttonconnection)then
        TargetModal._dev._closebuttonconnection:Disconnect();
        TargetModal._dev._closebuttonconnection = nil;
    end;
    
    Frame.Visible = TargetModal.Visible;
    Frame.Parent = TargetModal:GetRef();

    Modal:Destroy();

    return TargetModal;
end;

function ModalService:_Render()
    return {};
end;


return CustomClassService:Create(ModalService);