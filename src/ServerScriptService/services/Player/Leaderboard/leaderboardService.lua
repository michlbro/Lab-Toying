-- @ leaderboard service
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- @ Packages
local knit = require(replicatedStorage.Packages.knit)

-- @ Create leaderboard service
local leaderboardService = knit.CreateService {
    Name = "leaderboardService",
    Client = {},

    -- @ Configs
    _leaderboardConfig = require(script.Parent.leaderboardConfig),
    _playerConnections = {},
    _playerLeaderboard = {}
}

function leaderboardService._onPlayerAdded(self, player: Player)
    local leaderboardFolder = Instance.new("Folder")
    leaderboardFolder.Parent = player
    leaderboardFolder.Name = "leaderstats"
    self._playerLeaderboard[player] = leaderboardFolder

    for name, value in pairs(self._leaderboardConfig) do
        local instance = Instance.new(value[1])
        instance.Name = name
        instance.Parent = leaderboardFolder
    end

    -- @ Callback function for when money changes.
    local moneyService = knit.GetService("moneyService")
    self._playerConnections[player] = moneyService.onMoneyChange:Connect(function(value)
        local moneyValue: NumberValue = leaderboardFolder:FindFirstChild("Money")
        if leaderboardFolder then
            moneyValue.Value = tonumber(value)
        end
    end)
end

function leaderboardService:KnitStart()
    players.PlayerAdded:Connect(function(player)
        self._onPlayerAdded(self, player)
    end)
    players.PlayerRemoving:Connect(function(player)
        self._playerConnections[player]:Disconnect()
        self._playerConnections[player] = nil
    end)
end

return leaderboardService