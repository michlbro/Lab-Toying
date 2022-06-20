-- tramline component
-- Created by XxprofessgamerxX

--[=[
    need to require tramlineTracker

    check if tracker is a station or not
]=]

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")

-- Packages
local components = require(replicatedStorage.Packages.component)
local promise = require(replicatedStorage.Packages.promise)
local knit = require(replicatedStorage.Packages.knit)

local tramlineComponent = components.new({
    Tag = "tramLine"
})

-- tramlineTrackerVariables
local tramlineTrackerComponentModule = script.Parent.tramlineTracker.tramlineTrackerComponent

local tramlineDoorState = {
    opened = 1,
    closed = 0
}

function tramlineComponent:Construct()
    self.tramWait = 2
    self.timeForDoor = 1
    self.tramSpeed = 10
    self._tramlineIdentity = self.Instance:GetAttribute("TramlineIdentity")
    self.progress = 0 -- percentage 1-0
    self:onWeld() -- creates self._partsToTween = {base, door}
end

function tramlineComponent:onWeld()
    --[=[
        tram line heirarchy (MODEL):
        Base = { -- GET DESCENDANTS
            instances,... | (floorTWEEN) -- allow players to move in tram
        },
        Doors = { -- GET DESCENDANTS
        instances,...
        }
    ]=]
    -- Knit sevices for allowing players to move in tram tween
    local tweenHandlerService = knit.GetService("tweenHandlerService")

    local model = self.Instance
    local base: Model = model:FindFirstChild("Base")
    local doors: Model = model:FindFirstChild("Doors")

    tweenHandlerService:addInstance(base)

    local primaryBasePart = (base) and base.PrimaryPart
    local primaryDoorPart = (doors) and doors.PrimaryPart

    self._partsToTween = {tram = primaryBasePart, door = primaryDoorPart}
    self._doorSettings = {
        doorWeldBody = Instance.new("WeldConstraint"),
        doorState = tramlineDoorState.closed,
        doorPositions = {closed = CFrame.new(3.66, -0.34, 0), opened = CFrame.new(-3.66, 0.34, 0)}
    }
    
    local doorWeld = self._doorSettings.doorWeldBody
    doorWeld.Parent = primaryDoorPart
    doorWeld.Part0 = primaryDoorPart
    doorWeld.Part1 = primaryBasePart

    for _, part: BasePart in pairs(base:GetDescendants()) do
        if not part:IsA("BasePart") then
            continue
        end

        if part ~= primaryBasePart then

            local weld = Instance.new("WeldConstraint")
            weld.Parent = primaryBasePart
            weld.Part0 = primaryBasePart
            weld.Part1 = part

            part.Anchored = false
        end
    end

    for _, part: BasePart in pairs(doors:GetDescendants()) do
        if not part:IsA("BasePart") then
            continue
        end

        if part ~= primaryDoorPart then
            local weld = Instance.new("WeldConstraint")
            weld.Parent = primaryDoorPart
            weld.Part0 = primaryDoorPart
            weld.Part1 = part

            part.Anchored = false
        end
    end
    doors.PrimaryPart.Anchored = false
end

function tramlineComponent:setupTrackers()
    self._tramlineTrackerComponents = self._tramlineTrackerComponents:GetAll()

    for _, component in pairs(self._tramlineTrackerComponents) do
        local tramlineIdentifier, stationNumber, trackers = component:getType()
        if not tramlineIdentifier == self._tramlineIdentity then
            continue
        end

        self._tramlineTracker[stationNumber] = trackers
    end
end

function tramlineComponent:Start()
    self._tramlineTracker = {} --[[
        waypoint system: {
            [1] = { -- STATION
                instance,... -- waypoint to STATION ^
            }
        }
    ]]
    self._tramlineTrackerComponents = require(tramlineTrackerComponentModule)
    self:setupTrackers()
    self:startEngineSound()
    self:startMain(2)
end

function tramlineComponent:startEngineSound()
    -- tram engine sound, get magnitude of previous
    -- change sound depending on value
    return promise.new(function()
        local soundInstance = Instance.new("Sound")
        soundInstance.Parent = self._partsToTween.tram
        soundInstance.SoundId = "rbxassetid://532147820"
        soundInstance.Looped = true
        soundInstance.PlaybackSpeed = 0
        soundInstance:Play()

        local previousPosition: Vector3 = nil
        runService.Heartbeat:Connect(function(deltaTime)
            local currentPosition = self._partsToTween.tram.CFrame.Position
            if not previousPosition then
                previousPosition = currentPosition
            end
            local magnitude = (currentPosition - previousPosition).magnitude
            local speed = (magnitude > 0) and magnitude/deltaTime or 7
            soundInstance.PlaybackSpeed = (speed/self.tramSpeed >= 1) and 1 or (speed <= 7) and (7/self.tramSpeed) * 1 or speed/self.tramSpeed * 1
            previousPosition = currentPosition
        end)
    end)
end

function tramlineComponent.chooseWaypoint(tramlineTracker: table, count: number)
    if not count then
        return tramlineTracker[1]
    end

    if not tramlineTracker[count] then
        return tramlineTracker[1]
    end

    return tramlineTracker[count]
end

function tramlineComponent:tweenTram(choosenWaypoint, inverse, currenWaypoint)
    return promise.new(function(resolve)

        local tramline: BasePart = self._partsToTween.tram

        -- work out speed through time. calculate distance between points / speed

        local tween
        if not inverse then
            local waypoints = choosenWaypoint.waypoints
            local distanceToNextStation = math.floor(choosenWaypoint.distanceToStation) + (tramline.CFrame.Position - waypoints[1].Position).magnitude
   
            local timeTaken = distanceToNextStation/self.tramSpeed
 
            for i, points in ipairs(waypoints) do
                self.progress = i/(#waypoints+1)
                local distance = (tramline.CFrame.Position - points.Position).magnitude
                local timeForTween = (distance/distanceToNextStation) * timeTaken

                local easingStyle = Enum.EasingStyle.Linear
                if i == 1 then
                    easingStyle = Enum.EasingStyle.Sine
                end

                tween = tweenService:Create(tramline, TweenInfo.new(timeForTween, easingStyle, Enum.EasingDirection.In) ,{CFrame = points})
                tween:Play()
                tween.Completed:Wait()
                tween = nil
            end
            local station = choosenWaypoint.station.CFrame
            local distance = (tramline.CFrame.Position - station.Position).magnitude
            local timeForTween = (distance/distanceToNextStation) * timeTaken
            tween = tweenService:Create(tramline, TweenInfo.new(timeForTween, Enum.EasingStyle.Sine, Enum.EasingDirection.Out) ,{CFrame = station})
            tween:Play()
            tween.Completed:Wait()
            tween = nil
            resolve()
        else
            local waypoints = currenWaypoint.waypoints

            local distanceToNextStation = (waypoints[#waypoints].Position - choosenWaypoint.station.CFrame.Position).magnitude + currenWaypoint.distanceToStation
            local timeTaken = distanceToNextStation/self.tramSpeed

            for i = #waypoints, 1, -1 do
                local waypoint = waypoints[i]
                self.progress = (#waypoints - (#waypoints - i))/#waypoints

                local distance = (tramline.CFrame.Position - waypoint.Position).magnitude
                local timeForTween = (distance/distanceToNextStation) * timeTaken

                local easingStyle = Enum.EasingStyle.Linear
                if i == #waypoints then
                    easingStyle = Enum.EasingStyle.Sine
                end

                tween = tweenService:Create(tramline, TweenInfo.new(timeForTween, easingStyle, Enum.EasingDirection.In), {CFrame = waypoint})
                tween:Play()
                tween.Completed:Wait()
                tween = nil
            end

            local station = choosenWaypoint.station
            local distance = (tramline.CFrame.Position - station.CFrame.Position).magnitude
            local timeForTween = (distance/distanceToNextStation) * timeTaken
            tween = tweenService:Create(tramline, TweenInfo.new(timeForTween, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = station.CFrame})
            tween:Play()
            tween.Completed:Wait()
            tween = nil
            resolve()
        end
    end)
end

function tramlineComponent:tramDoor(state)
    return promise.new(function(resolve)
        -- close door
        if state == tramlineDoorState.closed then
            if self._doorSettings.doorState ~= tramlineDoorState.closed then
                self._doorSettings.doorState = tramlineDoorState.closed

                -- anchor and disable weld on door before tweening door
                self._partsToTween.door.Anchored = true
                self._doorSettings.doorWeldBody.Enabled = false

                local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                local tween = tweenService:Create(self._partsToTween.door, tweenInfo, {CFrame = self._partsToTween.door.CFrame * self._doorSettings.doorPositions.closed:Inverse()})
                tween:Play()
                tween.Completed:Wait()
                tween = nil
                tweenInfo = nil

                -- unanchor door again for next step to tween tram and enabled weld
                self._doorSettings.doorWeldBody.Enabled = true
                self._partsToTween.door.Anchored = false
                resolve()
            end
            resolve()

        -- open door
        elseif state == tramlineDoorState.opened then
            if self._doorSettings.doorState ~= tramlineDoorState.opened then
                self._doorSettings.doorState = tramlineDoorState.opened

                -- anchor and disable weld on door before tweending door
                self._partsToTween.door.Anchored = true
                self._doorSettings.doorWeldBody.Enabled = false

                local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
                local tween = tweenService:Create(self._partsToTween.door, tweenInfo, {CFrame = self._partsToTween.door.CFrame * self._doorSettings.doorPositions.opened:Inverse()})
                tween:Play()
                tween.Completed:Wait()
                tween = nil
                tweenInfo = nil

                -- unanchor door again for next step to tween tram and enable weld
                self._doorSettings.doorWeldBody.Enabled = true
                self._partsToTween.door.Anchored = false
                resolve()
            end
            resolve()
        end
    end)
end

function tramlineComponent:startMain(start)

    local choosenWaypoint0 = nil
    for i = start or 1, #self._tramlineTracker do
        local choosenWaypoint = self.chooseWaypoint(self._tramlineTracker, i)
        task.wait(self.tramWait)
        self:tramDoor(tramlineDoorState.closed):await()
        task.wait(self.timeForDoor)
        self:tweenTram(choosenWaypoint):await()
        task.wait(self.timeForDoor)
        self:tramDoor(tramlineDoorState.opened):await()
        choosenWaypoint0 = choosenWaypoint
    end
    for i = #self._tramlineTracker-1, 1, -1 do
        local choosenWaypoint = self.chooseWaypoint(self._tramlineTracker, i)
        task.wait(self.tramWait)
        self:tramDoor(tramlineDoorState.closed):await()
        task.wait(self.timeForDoor)
        self:tweenTram(choosenWaypoint, true, choosenWaypoint0):await()
        task.wait(self.timeForDoor)
        self:tramDoor(tramlineDoorState.opened):await()
    end

    self:startMain(2)
end

return tramlineComponent