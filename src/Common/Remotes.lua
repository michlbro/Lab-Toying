local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Link = require(ReplicatedStorage.Packages.link)

return {
    sounds = {
        alerts = Link.event(),
    }
}