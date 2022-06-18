-- Tween handler services
-- Created by XxprofessgamerxX

--[=[
    Communication between client tween handler and server
    allows to sync player with movement of tweened parts

    server side to allow components/instances to be added to clients list of tween items.

    USAGE: tweenHandlerService:addInstance(instance: BasePart)
]=]

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Packages
local knit = require(replicatedStorage.Packages.knit)

-- Create service
local tweenHandlerService = knit.CreateService {
    Name = "tweenHandlerService",
    Client = {
        onInclude = knit.CreateSignal()
    },
    _listOfInstanceTweens = {}
}

function tweenHandlerService:addInstance(instance: BasePart)
    if not instance:IsA("BasePart") then
        return
    end

    table.insert(self._listOfInstanceTweens, instance)
    tweenHandlerService.Client.onInclude:FireAll(self._listOfInstanceTweens)
end

function tweenHandlerService:KnitStart()
    players.PlayerAdded:Connect(function(player)
        tweenHandlerService.Client.onInclude:Fire(player, self._listOfInstanceTweens)
    end)

    for _, player in pairs(players:GetPlayers()) do
        tweenHandlerService.Client.onInclude:Fire(player, self._listOfInstanceTweens)
    end
end

return tweenHandlerService