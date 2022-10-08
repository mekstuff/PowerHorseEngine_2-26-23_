# What is a Pseudo?

`Pseudo` is PowerHorseEngine's way of ROBLOX `Instances`, It is the name given PowerHorseEngine objects. To create a `Pseudo` you need to use the `Pseudo` global. You can also directly create Pseudo's from the MainModule using `.new`

---

All Pseudo's will inherit a baseclass called `Pseudo` as well, You can differenciate between ROBLOX Instances and Pseudo Instances by calling 
```lua 
:IsA("Instance")
|| 
:IsA("Pseudo")
```
