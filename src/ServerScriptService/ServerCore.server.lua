local ServerStorage  = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

-- Modules
local modules = ServerScriptService.Server.Modules

-- Common
local common = ReplicatedStorage.Common
local ModuleLoader = require(common.ModuleLoader)

-- Enums
local enums = common.Enums
local teamEnums = require(enums.Teams)

-- Classes
local commonClasses = ModuleLoader.new(common.Classes)
local serverClasses = ModuleLoader.new(ServerStorage.Server)

-- configs
local configs = ServerScriptService.Server.Configs
local requiredConfigs = {
    GAMERULES = require(configs.GAMERULES);
    playerDataStoreConfig = require(configs.PlayerDataStoreConfig);
    reactorCoreConfig = require(configs.ReactorCoreConfig)
}

-- GAMERULES
if requiredConfigs.GAMERULES.TEAMS then
    Players.CharacterAutoLoads = false
end

-- Events
local gameEvents = {}
local remotes = require(common.Remotes)

-- Datastore
local playerDataStore = serverClasses.DataStoreClass.new(requiredConfigs.playerDataStoreConfig)

-- Players
local players = {}

Players.PlayerAdded:Connect(function(playerInstance)
    local player = serverClasses.PlayerClass.new(playerInstance)
    if requiredConfigs.GAMERULES.TEAMS then
        player:SetTeam(serverClasses.TeamClass.new(teamEnums.Visitor))
    end
    player.playerData.datastore = playerDataStore:GetPlayerData(playerInstance)
    players[playerInstance] = player
end)

Players.PlayerRemoving:Connect(function(playerInstance)
    local player = players[playerInstance]

    if requiredConfigs.GAMERULES.SAVEDATA then
        -- serialisedata first
        playerDataStore:SavePlayerData(playerInstance, player.playerData.datastore)
    end
end)

-- Sound Alert System
task.spawn(function()
    while true do
        task.wait(math.random(5, 10))
        remotes.sounds.alerts:FireAllClients()
    end
end)

-- Reactor
local reactor = serverClasses.ReactorClass.new(requiredConfigs.reactorCoreConfig)
if requiredConfigs.GAMERULES.REACTOR then
    gameEvents.reactor = {
        warning = reactor.warning;
        critical = reactor.critical;
        meltdown = reactor.meltdown;
        optimal = reactor.optimal;
        temperatureChanged = reactor.temperatureChanged
    }
    -- Reactor module
    -- // Handles all of the coolant buttons etc.
    local reactorModule = require(modules.Reactor)
    reactorModule.OnSetup(reactor)
    reactor:Activated(true)
end