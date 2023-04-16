local Link = require(game:GetService("ReplicatedStorage").Packages.link)

return {
    PlayerInit = {
        DataStoreInvoke = Link.fn(),
        PlayerCreated = Link.event()
    },
    Team = {
        TeamRequest = Link.fn(),
        UpdateCamera = Link.event()
    }
}