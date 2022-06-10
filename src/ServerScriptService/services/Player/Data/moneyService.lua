-- @ Money service
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- @ Packages
local knit = require(replicatedStorage.Packages.knit)

local moneyService = knit.CreateService {
    Name = "moneyService",
    Client = {
        onMoneyChange = knit.CreateSignal()
    },
    _defaultAmount = 100,
    _dataName = "Money",
    _playerMoney = {}
}

-- @ Check if player has got its datastore yet
function moneyService._checkPlayer(self, player: player)
    if self._playerMoney[player] then
        return self._playerMoney[player]
    end
    
    local playerMoneyDataStore = knit.GetService("dataService"):getData(player, self._dataName)
    self._playerMoney[player] = playerMoneyDataStore

    return playerMoneyDataStore
end

function moneyService._onPlayerAdded(self, player: Player)
    local playerMoneyDataStore = self._checkPlayer(self, player)

    playerMoneyDataStore:onUpdate(function(value)
        self._moneyChanged(self, player, value)
    end)
end

-- Client Events --

--  Callback function for clients
function moneyService._moneyChanged(self, player: Player, value: number)
    self.Client.onMoneyChange:FireClient(player, value)
end

-- Get data of player (client)
function moneyService.Client:getData(player: Player)
    return self.Server._checkPlayer(self, player):Get(self.Server._defaultAmount)
end

-- --

-- @ Get data store of player
function moneyService:getDataStore(player: player)
    return self._checkPlayer(self, player)
end

-- @ Get player money
function moneyService:getMoney(player: player)
    return self._checkPlayer(self, player):Get(self._defaultAmount)
end

-- @ Set player money
function moneyService:setMoney(player: player, amount: number)
    self._checkPlayer:Set(self, player):Set(amount)
end

-- @ Player event here.
function moneyService:KnitStart()
    players.PlayerAdded:Connect(function(player)
        self._onPlayerAdded(player)
    end)

    for _, player in pairs(players:GetPlayers()) do
        task.spawn(function()
            self._onPlayerAdded(player)
        end)
    end
end

return moneyService