local ReplicatedStorage = game:GetService("ReplicatedStorage")

local knit = require(ReplicatedStorage:WaitForChild("Packages").knit)
local leaderboardStructure = require(ReplicatedStorage:WaitForChild("Shared").LeaderboardStructure)

local leaderboardService = knit.CreateService {
    Name = "LeaderboardService",
    Client = {},
    __leaderboardStructure = leaderboardStructure
}

local function instanceExist(instance)
    local _, value = pcall(function()
        return Instance.new(instance)
    end)
    return value
end

function leaderboardService:createLeaderboard(player)
    local leaderboard = Instance.new("Folder")
    leaderboard.Name = "Leaderboard"
    leaderboard.Parent = player

    local leaderboardTable = {}

    for name, properties in self.__leaderboardStructure do
        local instance: ValueBase = instanceExist(properties.instance)
        if instance then
            instance.Name = name
            leaderboardTable[name] = instance
        end
    end

    return leaderboardTable, self.__leaderboardStructure
end

return leaderboardService