A Servant is a Pseudo class similar to `Maid` or `Janitor`. It is responsible for properly cleaning up your components where you will normally forget. `Servants` are good to prevent memory leaks

---

## Methods


### Task
```lua
Servant:Task(callback:function):nil
```

Gives a function task to the servant that will be removed once the task was completed.
If `Servant` is destroyed while trying to complete task, the task will end as well.

```lua
    local function loopFunction()
        for i = 1,1000, do
            print("Task is still running!");
            task.wait();
        end;
    end;
    Servant:Task(loopFunction); --> Will print "Task is still running" multiple times
    print("Lanzo,inc. Demonstration"); --> This will print even though a loop is running
    task.wait(5); 
    Servant:Destroy(); --> Will no longer print "Task is still running"
```

---

### Keep

```lua
Servant:Keep(...:any):any
```

Tells the servant to track the Instance/Pseudo

---

### Free

```lua
Servant:Free(...:any):any
```

---

### Connect

```lua
Servant:Connect(connection:RBXScriptSignal, handler:any,id:any):RBXScriptConnect
```
