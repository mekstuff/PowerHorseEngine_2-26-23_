return function (Wrapper)
    local App = require(script.Parent.Parent.Parent);
    local Component = App.New "$NotificationGroup" {
        Parent = Wrapper;
        AnchorPoint = Vector2.new(.5,.5);
        Position = UDim2.fromScale(.5,.5);
    };
    Component:Notify({
        Header = "Notification",
        Body = "This notification uses the :Notify method so it creates a Toast Pseudo to display it for you",
        CloseButtonVisible = true,
        CanvasImage = "ico-mdi@action/circle_notifications"
    })
    task.delay(.5,function()
        Component:Notify({
            CanvasImage = "ico-mdi@social/notifications_active",
            Header = "But...",
            Body = "You can also create custom notifications using Pseudo's!",
            CloseButtonVisible = true,
            IconImage = "ico-mdi@action/assignment_turned_in"
        });
        local ExampleText = App.New "$Text" {
            AutomaticSize = Enum.AutomaticSize.Y;
            TextWrapped = true;
            Size = UDim2.new(1,0,0,0);
            Text = "This is just a Text Pseudo but it will be treated as a notification! (Click checkbox to change my priority from a low one to a high one)",
            BackgroundTransparency = .5;
        }
        task.wait(.5);
        Component:SendNotification(ExampleText)
        local ExampleButton = App.New "$Button" {
            Text = "And this is an example using a Button (Click me!)",
            [App.OnWhiplashEvent "MouseButton1Down"] = function()
                local n,atb = Component:Notify({
                    CanvasImage = math.random(1,2) == 1 and "ico-mdi@hardware/mouse" or "";
                    Header = "Clicked",
                    Body = "You clicked the button! You can follow orders, Congratulations!",
                    AttachButton = "Dismiss",
                    CloseButtonVisible = true,
                });
                atb.MouseButton1Down:Connect(function()
                    n:Dismiss();
                end);
            end;
        }

        local n = Component:SendNotification(ExampleText);
        task.wait(.5);
        Component:SendNotification(App.New "$Checkbox" {
            [App.OnWhiplashEvent "Toggled"] = function (this)
                n.Priority = this.Toggle and App.Enumeration.NotificationPriority.Critical or App.Enumeration.NotificationPriority.Low;
            end
        });
        task.wait(.5);
        Component:SendNotification(ExampleButton);
    end);


    return function ()
        Component:Destroy();
    end;
end