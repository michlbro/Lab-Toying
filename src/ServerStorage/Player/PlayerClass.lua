local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage.Common

local player = {}

function player:ChangeTeam(team)
    self.playerData.cached.team:ChangeTeam(team)
end

function player:InitTeam(team)
    self.playerData.cached.team = team
end

local function new(playerInstance)
    local self = {}
    self.instance = playerInstance
    self.playerData = {
        cached = {
            team = nil
        }
    }



    return setmetatable(self, {__index = player})
end

return setmetatable({new = new}, {})