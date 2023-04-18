local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local SignalClass = require(ReplicatedStorage.Shared.Classes.SignalClass.Signal)

return {
    GAMERULES = require(ReplicatedStorage.Shared.Configuration.GAMERULES),
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
        DataStoreService = DataStoreService,
        RunService = RunService
    },
    Players = {},
    ServerClasses = {},
    SharedClasses = {},
    Networking = {
        Player = require(ReplicatedStorage.Shared.Networking.Player),
        Reactor = require(ReplicatedStorage.Shared.Networking.Reactor)
    },
    Events = {
        Player = {
            PlayerAdded = SignalClass.new(),
            PlayerRemoving = SignalClass.new(),
            TeamChanged = SignalClass.new(),
            LeaderboardUpdate = SignalClass.new()
        },
        Reactor = {
            Step = SignalClass.new(),
            Current = SignalClass.new(),
            Power = SignalClass.new(),
            Warning = SignalClass.new(),
            Critical = SignalClass.new(),
            Meltdown = SignalClass.new()
        }
    },
    VariableContainer = {
        Version = "0.0.1"
        -- DataStorePlayer
    }
}