local core = {
    Leaderboard = {}
} :: any

function core.Leaderboard:Update()
    core.LeaderboardValueLocation(self.player, self.leaderboard)
end

local function new(player)
    local self = {}
    self.player = player
    self.leaderboard = core.LeaderboardInstance:Clone()
    
    self.leaderboard.Parent = self.player.instance
    return setmetatable(self, {
        __index = core.Leaderboard
    })
end

return function(main)
    core = main(core)
    local leaderboardConfig = require(core._G.net.Paths.ServerConfiguration.Leaderboard)
    core.Structure = leaderboardConfig.leaderboardStructure
    core.LeaderboardValueLocation = leaderboardConfig.leaderboardValueLocation
    
    local leaderboardFolder = Instance.new("Folder")
    leaderboardFolder.Name = "leaderstats"
    for _, leaderboardObject in core.Structure do
        local valueObject = Instance.new(leaderboardObject[2])
        valueObject.Name = leaderboardObject[1]
        valueObject.Parent = leaderboardFolder
    end
    core.LeaderboardInstance = leaderboardFolder
    leaderboardFolder.Parent = script
    core._G.net.ServerClasses.LeaderboardClass = setmetatable({new = new}, {
        __index = new
    })
end