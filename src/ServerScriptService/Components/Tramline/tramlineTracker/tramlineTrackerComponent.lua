-- tram line tracker components
-- created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local components = require(replicatedStorage.Packages.component)

-- create component
local tramlineTrackerComponent = components.new({
    Tag = "tramLineTrackerComponent"
})

function tramlineTrackerComponent:getType()
    return self._tramlineIdentifier, self._stationNumber, self._trackers
end

function tramlineTrackerComponent:Construct()
    local componentInstance = self.Instance

    componentInstance.PrimaryPart.Transparency = 1

    self._tramlineIdentifier = componentInstance:GetAttribute("TramlineIdentifier")
    self._stationNumber = componentInstance:GetAttribute("TramlineStation")

    self._trackers = {
        station = componentInstance.PrimaryPart,
        waypoints = {},
        distanceToStation = 0
    }

    for _, part: Attachment in pairs(componentInstance:GetDescendants()) do
        if not part:IsA("Attachment") then
            continue
        end
        self._trackers.waypoints[tonumber(part.Name)] = part.WorldCFrame
        part:Destroy()
    end

    for i, point in ipairs(self._trackers.waypoints) do
        local nextWaypoint = self._trackers.waypoints[i+1]
        if not nextWaypoint then
            self._trackers.distanceToStation += (point.Position - self._trackers.station.CFrame.Position).magnitude
            break
        end

        self._trackers.distanceToStation += (point.Position - nextWaypoint.Position).magnitude
    end
end

return tramlineTrackerComponent