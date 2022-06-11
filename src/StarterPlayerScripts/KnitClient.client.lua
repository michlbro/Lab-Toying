-- @ Knit Controller, Server controller and component controller.

local replicatedStorage = game:GetService("ReplicatedStorage")
local knit = require(replicatedStorage.Packages.knit)

for _, v in pairs(replicatedStorage.Source.Controllers:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:match("Controller$") then
        require(v)
    end
end

local function loadComponents()
    for _, v in pairs(replicatedStorage.Source.Components:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name:match("Component$") then
            require(v)
        end
    end
end



knit.Start():andThen(function()
    loadComponents()
    print("[KNIT-CLIENT]: Started.")
end):catch(warn)