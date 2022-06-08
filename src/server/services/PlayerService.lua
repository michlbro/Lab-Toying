-- @ playerService
-- @ Created by XxprofessgamerxX

-- @ Free to use if you manage to get it??

-- @ Get knit module.
local knit: Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)

local serverScriptService = game:GetService("ServerScriptService")
local playerGameService = game:GetService("Players")

local gameScripts = serverScriptService.Game
local moduleAPI = require(gameScripts.modules)

-- @ Add playerService to knit environment.
local playerService = knit.CreateService {
    Name = "playerService"
}

-- @ Create playerClass
local players = {}
players.__index = players

-- @ OnPlayerAdded:
function players.new(player: Player): table
    local self = setmetatable({}, players)

    -- @ Add player as an instance.
    self.instance = player

    -- @ Get/create players data
    -- @ Save into table to be accessed by other services
    -- @ Use dataService module. (self.dataService)
    self.playerData = playerService.dataService:getPlayerData(player)

    return self
end

-- @ OnPlayerRemoving:
-- @ Destroy any events.
-- @ Save player data.
function players:removing()
    playerService.dataService:savePlayerData(self.instance)
end

function playerService:KnitInit()

    -- @ Get dataService for:
    local dataStore = "Lab Toying"
    -- @ Setup dataService
    -- @ dataStore structure
    -- @ {
    -- @    Money = true -- Check if value is different to starting value
    -- @    TimeInGame = false
    -- @    Achievements = false
    -- @ }

    local dataStructure = {
        Money = {checkData = true, typeOfData = "number"},
        TimeInGame = {checkData = false, typeOfData = "number"},
        Achievements = {checkData = false, typeOfData = "table"}
    }

    local dataService = moduleAPI.dataService
    self.dataService = dataService.new(dataStore, dataStructure)
    
    -- @ Create table to store players
    self.players = {}
end

function playerService:KnitStart()

    -- @ Check if players are added in before event was able to fire.
    task.spawn(function()
       local playerList = playerGameService:GetPlayers()
       for _, player: Player in pairs(playerList) do
           task.spawn(function()
               if not self.players[player] then
                   self.players[player] = players.new(player)
               end
           end)
       end
    end)

    -- @ Setup Player Adding/Removing Events
    -- @ Put them into a table to be accessed by other services.
    self.playerAddedConnection = playerGameService.PlayerAdded:Connect(function(player: Player)
       self.players[player] = players.new(player)
    end)
    self.playerRemovingConnection = playerGameService.PlayerRemoving:Connect(function(player: Player)
       self.players[player]:removing()
    end)
end

return playerService