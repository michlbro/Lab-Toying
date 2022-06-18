-- @ Knit Controller, Server controller and component controller.

-- @ Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- @ Packages
local knit = require(replicatedStorage.Packages.knit)

-- @ Load knit services
for _,v in pairs(script.Parent.Services:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name:match("Service$") then
        require(v)
    end
end

-- @ Load knit components
local function loadComponents()
    for _, v in pairs(script.Parent.Components:GetDescendants()) do
        if v:IsA("ModuleScript") and v.Name:match("Component$") then
            require(v)
        end
    end
end

knit.Start():andThen(function()

    loadComponents()

    print("[KNIT-Server]: Started!")
end):catch(warn)