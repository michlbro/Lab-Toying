local tramlineTrackerExtention = {}

function tramlineTrackerExtention.ShouldConstruct(component)
    local componentInstance = component.Instance

    local tramlineIdentifier = componentInstance:GetAttribute("TramlineIdentifier")
    local stationNumber = componentInstance:GetAttribute("TramlineStation")

    if not tramlineIdentifier and not stationNumber then
        print("g")
        return false
    end

    return true
end

return tramlineTrackerExtention