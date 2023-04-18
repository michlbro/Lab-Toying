local Link = require(game:GetService("ReplicatedStorage").Packages.link)

return {
    Reactor = {
        GetTemperature = Link.fn(),
        Warning = Link.event(),
        Critical = Link.event(),
        Meltdown = Link.event()
    }
}