-- @ Sound Controller
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local runService: RunService = game:GetService("RunService")
local players: Players = game:GetService("Players")


-- @ Packages
local knit = require(replicatedStorage.Packages.knit)
local promise = require(replicatedStorage.Packages.promise)

-- @ Player variables
local player: Player = players.LocalPlayer

-- @ Create Sound Controller
local soundController = knit.CreateController {
    Name = "soundController",
    _soundConfig = require(script.Parent.SoundConfigs.SoundConfig),
    _soundClasses = require(script.Parent.SoundConfigs.SoundClasses),
    _activeSounds = {}
}

function soundController._maintainFootsteps(self)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") or not player.Character.HumanoidRootPart:FindFirstChild("Running") then
        return
    end

    local humanoid: Humanoid = player.Character.Humanoid
    local walkSound: Sound = player.Character.HumanoidRootPart.Running

    local floorMaterial: Enum = humanoid.FloorMaterial
    local floorSound = self._soundConfig.footsteps[floorMaterial] or self._soundConfig.footsteps.default

    if self._activeSounds[footsteps] == floorSound then
        return
    end

    walkSound.SoundId = floorSound.SoundId
    walkSound.Volume = floorSound.Volume
    walkSound.PlaybackSpeed = floorSound.PlaybackSpeed 

    self._activeSounds["footsteps"] = floorSound

    if #floorSound.misc == 0 then
        return
    end

    for _, soundChild in pairs(walkSound:GetChildren()) do
        if not table.find(floorSound.misc, soundChild.className) then
            soundChild:Destroy()
        end
    end

    for className, properties in pairs(floorSound.misc) do
        if not table.find(self._soundClasses, className) then
            continue
        end

        local soundProperty = walkSound:FindFirstChild(className)
        if not soundProperty then
            soundProperty = Instance.new(className)
            soundProperty.Parent = walkSound
        end

        for property, value in pairs(properties) do
            local propertyExist = promise.new(function()
                local success = pcall(function() return soundProperty[property] end)
            end):andThen(function()
                soundProperty[property] = value
            end):await()
        end
    end
end

function soundController:KnitStart()
    runService.Heartbeat:Connect(function()
        self._maintainFootsteps(self)
    end)
end



return soundController