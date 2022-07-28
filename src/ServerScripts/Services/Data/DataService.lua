local ReplicatedStorage = game:GetService("ReplicatedStorage")

local knit = require(ReplicatedStorage:WaitForChild("Packages").knit)

local dataService = knit.CreateService {
    Name = "DataService",
    __databaseName = "Lab-Toying"
}
local DataStoreService = game:GetService("DataStoreService")

function dataService:getPlayerLeaderboardData(player: Player, leaderboard: table, leaderboardStructure: table)
    local dataStore: DataStore = self.dataStore

    local success, data = pcall(function()
        return dataStore:GetAsync(string.format("leaderboard_%s", player.UserId))
    end)

    if success then
        for name, value in leaderboard do
            local instance: ValueBase = value
            if data[name] then
                instance.Value = data[name]
            else
                instance.Value = leaderboardStructure[name].value
            end
        end
    else
        for name, value in leaderboard do
            local instance: ValueBase = value
            instance.Value = leaderboardStructure[name].value
        end
    end
end

function dataService:KnitInit()
    self.dataStore = DataStoreService:GetDataStore(self.__databaseName)
end

return dataService