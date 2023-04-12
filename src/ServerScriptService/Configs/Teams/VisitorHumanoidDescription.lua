local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage.Common
local enums = common.Enums

local teams = require(enums.Teams)

return {
    team = teams.Visitor
}