local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local _SignalClass = require(ReplicatedStorage.Shared.Classes.SignalClass)

return {
    LocalPlayer = Players.LocalPlayer,
    Services = {
        ReplicatedStorage = ReplicatedStorage,
        Workspace = Workspace,
        Players = Players,
    },
    Paths = {
        ClientConfiguration = ReplicatedStorage.Client.Configuration
    },
    ClientClasses = {},
    Events = {},
    Networking = {
        Player = require(ReplicatedStorage.Shared.Networking.Player)
    },
    GuiContainer = {},
    VariableContainer = {}
}