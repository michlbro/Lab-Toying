-- @ Knit Controller, Server controller and component controller.

local replicatedStorage = game:GetService("ReplicatedStorage")
local knit = require(replicatedStorage.Packages.knit)

for _, v in pairs(replicatedStorage.controller:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:match("Controller$") then
        require(v)
    end
end


knit.Start():andThen(function()
    print("[KNIT-CLIENT: Started.")
end):catch(warn)