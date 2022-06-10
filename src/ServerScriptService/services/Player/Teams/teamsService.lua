-- @ Teams Service
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:Ge

-- @ Packages
local knit = require(replicatedStorage.Packages.knit)

-- @ Create teamsService
local teamsService = knit.CreateService {
    Name = "teamsService",
    Client = {},
    _teamsConfig = require(script.Parent.teamsConfig)
}

function teamsService:KnitStart()
    playe
end

return teamsService