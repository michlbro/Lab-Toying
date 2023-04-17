local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local DataStoreService = game:GetService("DataStoreService")

local SignalClass = require(ReplicatedStorage.Shared.Classes.SignalClass)

return {
    GAMERULES = require(ReplicatedStorage.Shared.Configuration.GAMERULES),
    GAMERULES
    Paths = {
        ServerConfiguration = ServerStorage.Server.Configuration
    },
    ENUMS = {},
    Services = {
        ReplicatedStorage = ReplicatedStorage,
        Workspace = Workspace,
        ServerStorage = ServerStorage,
        ServerScriptService = ServerScriptService,
        Players = Players,
        DataStoreService = DataStoreService 
    },
    Players = {},
    ServerClasses = {},
    SharedClasses = {},
    Networking = {
        Player = require(ReplicatedStorage.Shared.Networking.Player)
    },
    Events = {
        Player = {
            PlayerAdded = SignalClass.new(),
            PlayerRemoving = SignalClass.new(),
            TeamChanged = SignalClass.new(),
            LeaderboardUpdate = SignalClass.new()
        }
    },
    VariableContainer = {
        Version = "0.0.1"
        -- DataStorePlayer
    }
}