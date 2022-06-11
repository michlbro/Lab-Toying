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

knit.Start():andThen(function()

    

    print("[KNIT-Server]: Started!")
end):catch(warn)