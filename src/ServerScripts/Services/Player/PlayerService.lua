local ReplicatedStorage = game:GetService("ReplicatedStorage")

local knit = require(ReplicatedStorage:WaitForChild("Packages").knit)

local playerService = knit.CreateService {
    Name = "PlayerService",
    Client = {},
    __Players = {}
}
local Players = game:GetService("Players")

function playerService:onPlayerAdded(player)
    self.__Players[player] = {}

    local leaderboard, leaderboardStructure = self.leaderboardService:createLeaderboard(player)
    self.dataService:getPlayerLeaderboardData(player, leaderboard, leaderboardStructure)

end

function playerService:KnitStart()
    self.leaderboardService = knit.GetService("LeaderboardService")
    self.dataService = knit.GetService("DataService")
    Players.PlayerAdded:Connect(function(player)
        self:onPlayerAdded(player)
    end)
end

return playerService