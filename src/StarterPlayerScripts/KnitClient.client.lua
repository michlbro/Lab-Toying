-- @ Knit Controller, Server controller and component controller.

local replicatedStorage = game:GetService("ReplicatedStorage")
local knit = require(replicatedStorage.Packages.knit)

knit.AddServicesDeep(replicatedStorage)

knit.Start():andThen(function()
    
end):catch(warn)