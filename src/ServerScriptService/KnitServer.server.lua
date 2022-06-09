-- @ Knit Controller, Server controller and component controller.

local replicatedStorage = game:GetService("ReplicatedStorage")
local knit = require(replicatedStorage.Packages.knit)

for i,v in pairs(script.Parent.services:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:match("Service$") then
        require(v)
    end
end

knit.Start():andThen(function()
    print("[KNIT-Server]: Started!")
end):catch(warn)