local knit: Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local serverScriptService = game:GetService("ServerScriptService")
local gameScripts = serverScriptService:WaitForChild("Game")

knit.AddServicesDeep(gameScripts.services)

function load()
    local componentsAPI = require(gameScripts.components)
    componentsAPI.load()
end

knit.Start():andThen(load):catch()