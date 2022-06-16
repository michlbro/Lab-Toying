-- Camera Controller
-- Created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Packages
local knit = require(replicatedStorage.Packages.knit)
local promise = require(replicatedStorage.Packages.promise)

-- Create camera controller
local cameraController = knit.CreateController {
    Name = "cameraController",
    _player = players.LocalPlayer,
    _promiseRunning = nil,

    -- First person settings
    _firstPerson = {
        strength = 1.3
    }

    -- Rumble settings
    _rumble = {
        intensity = 1,
        timeTaken = 10
    }
}

function cameraController

function cameraController:onStart()
    if self._promiseRunning and self._promiseRunning:getStatus() == promise.Status.Started then
        self._promiseRunning:cancel()
    end
    self._promiseRunning = promise.new(function(_, _, onCancel)
        self._player.CameraMode = Enum.CameraMode.LockFirstPerson
        local heartbeat = runService.Heartbeat:Connect(function()
            local character = self._player.Character
            local humanoidRootPart: BasePart = (self._player.Character) and self._player.Character:FindFirstChild("HumanoidRootPart") or nil

            if not humanoidRootPart then
                return
            end

            local torso: BasePart = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")

            if not torso then
                return
            end

            local deltaCFrame = humanoidRootPart.CFrame:ToObjectSpace(torso.CFrame)
            character.Humanoid.CameraOffset = character.Humanoid.CameraOffset:lerp(Vector3.new(0, deltaCFrame.Y, 0), self._firstPerson.strength)
        end)

        onCancel(function()
            local character = self._player.Character
            local humanoid: Humanoid = (self._player.Character) and self._player.Character:FindFirstChild("Humanoid") or nil

            if humanoid then
                humanoid.CameraOffset = Vector3.new(0,0,0)
            end

            heartbeat:Disconnect()
            heartbeat = nil
        end)
    end)
end

function cameraController:onRumble()
    local cameraService = knit.GetService("cameraService")
    cameraService._onRumble:Connect(function()
        local t0 = self._rumble.intensity
        local drainIntensity = 1-(self._rumble.intensity/self._rumble.timeTaken)
        local rumbleRun = runService.Heartbeat:Connect(function()
            if t0 < 0.01 then
                rumbleRun:Disconnect()
            end
        end)
    end)
end

function cameraController:KnitStart()
    self:onStart()
    self:onRumble()
end

return cameraController