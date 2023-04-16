local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local SignalClass = require(ReplicatedStorage.Shared.Classes.SignalClass)

return {
    LocalPlayer = Players.LocalPlayer,
    Services = {
        ReplicatedStorage = ReplicatedStorage,
        Workspace = Workspace,
        Players = Players,
    },
    Events = {},
    Networking = {
        Player = require(ReplicatedStorage.Shared.Networking.Player)
    }
}