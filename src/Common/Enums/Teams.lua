local ReplicatedStorage = game:GetService("ReplicatedStorage")

local common = ReplicatedStorage.Common
local classes = common.Classes

local EnumClass = require(classes.Enums)

return EnumClass.setup({
    "Visitor"
})