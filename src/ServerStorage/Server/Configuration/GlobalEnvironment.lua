local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local SignalClass = require(ReplicatedStorage.Shared.Classes.SignalClass)

return {
    GAMERULES = {
        SaveData = false,
        Team = false,
    },
    Paths = {
        ServerConfiguration = ServerStorage.Server.Configuration
    },
    ENUMS = {},
    Services = {
        ReplicatedStorage = ReplicatedStorage,
        Workspace = Workspace,
        ServerStorage = ServerStorage,
        ServerScriptService = ServerScriptService,
        Players = Players 
    },
    Players = {},
    ServerClasses = {},
    SharedClasses = {},
    Networking = {},
    Events = {
        Players = {
            PlayerAdded = SignalClass.new(),
            PlayerRemoving = SignalClass.new(),
            
        }
    },
    Vars = {
        Version = "0.0.1"
    }
}