local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage.Shared
local classes = shared.Classes

local SignalClass = require(classes.SignalClass)

return {
    Services = {

    },
    Path = {

    },
    Players = {},
    ServerClasses = {},
    SharedClasses = {},
    Networking = {},
    Events = {
        printG = SignalClass.new()
    }
}