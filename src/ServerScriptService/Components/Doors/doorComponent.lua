local singleDoor = {}
singleDoor.__index = singleDoor

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")

-- Packages
local knit = require(replicatedStorage.Packages.knit)
local promise = require(replicatedStorage.Packages.promise)

function singleDoor.ShouldConstruct(component)
    local doorType = component.Instance:GetAttribute("doorType")

    if not doorType or doorType == 0 or doorType > 2 then
        return false
    end

    return true
end

function singleDoor.ShouldExtend(component)
    local door = component.Instance:FindFirstChild("Door")
    local pivot = (door) and door.PrimaryPart or nil

    if not door or not pivot then
        return false
    end

    return true
end

function singleDoor.Constructed(component)
    local singleDoorClass = singleDoor.new(component)
    
    local proxyPrompt = Instance.new("ProximityPrompt")
    proxyPrompt.KeyboardKeyCode = Enum.KeyCode.E
    proxyPrompt.Parent = singleDoorClass.Instance.Door.PrimaryPart
end

local function weld(model: Model)
    local primaryPart = model.PrimaryPart

    for _, part in pairs(model:GetDescendants()) do
        if part:IsA("BasePart") and part ~= primaryPart then
            local weld = Instance.new("WeldConstraint")
            weld.Parent = primaryPart
            weld.Part0 = primaryPart
            weld.Part1 = part
            part.Anchored = false
        end
    end
end

function singleDoor:tweenTarget(angle: number, tweenInfo: TweenInfo)
    self.doorPromise = promise.new(function(resolve)
        local partToTween: BasePart = self.Instance.Door.PrimaryPart
        
        tweenInfo = tweenInfo or TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
        local tween = tweenService:Create(partToTween, tweenInfo, {CFrame = partToTween.CFrame * CFrame.Angles(0, angle, 0)})
        tween:Play()
        tween.Completed:Wait()
        tween = nil
        tweenInfo = nil
        resolve()
    end)
end

function singleDoor:interact(doorState)
    if self.doorState == doorState then
        return true
    end

    if self.doorPromise and self.doorPromise:getStatus() == promise.Status.Starting then
        return false
    end

    if doorState == self.types.opened then
        self:tweenTarget(-self.targetAngle)
        self.runSound(self.Instance.PrimaryPart, self.soundProperties)
    else
        self:tweenTarget(self.targetAngle)
        self.runSound(self.Instance.PrimaryPart, self.soundProperties)
    end
end

function singleDoor.runSound(primaryPart, soundProperties)
    return promise.new(function(resolve)
        local sound = Instance.new("Sound")
        sound.Parent = primaryPart
        
        for property, value in pairs(soundProperties) do
            sound[property] = value
        end

        sound:Play()
        sound.Ended:Wait()
        sound:Destroy()
        resolve()
    end)
end

function singleDoor.new(component)
    local self = setmetatable({
        types = {
            opened = true,
            closed = false
        },
        targetAngle = 90
    }, singleDoor)

    self.Instance = component.Instance
    weld(component.Instance.Door)
    self.doorState = self.types.closed

    return self
end

function singleDoor



return singleDoor