-- Camera Controller
-- Created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")

-- Packages
local knit = require(replicatedStorage.Packages.knit)
local promise = require(replicatedStorage.Packages.promise)

-- Create camera controller
local cameraController = knit.CreateController {
    Name = "cameraController",
    _player = players.LocalPlayer,
    _promiseRunning = nil,

    _firstPerson = {
        strength = 1.3
    },
    _rumble = {
        intensity = 1,
        timeTaken = 10
    },
    _menu = {
        cameras = {}
    }
}

function cameraController:onStart()
    if self._promiseRunning and self._promiseRunning:getStatus() == promise.Status.Started then
        self._promiseRunning:cancel()
        workspace.CurrentCamera.CameraType = Enum.CameraType.Follow
        workspace.CurrentCamera.CameraSubject = (self._player.Character) and self._player.Character:FindFirstChild("Humanoid")
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
        promise.new(function(resolve)
            for i = 1, self._rumble.timeTaken do
                local x = math.random(-100,100)/100
                local y = math.random(-100,100)/100
                local humanoid: Humanoid = (self._player.Character) and self._player.Character:FindFirstChild("Humanoid")

                if not humanoid then
                    task.wait()
                    continue
                end
                humanoid.CameraOffset = humanoid.CameraOffset:lerp(Vector3.new(x,y,0), self._rumble.intensity/i)
            end
            resolve()
        end):andThen(function()
            
        end)
    end)
end

function cameraController:addMenuCameras(cameraTable)
    self._menu.cameras[#self._menu.cameras] = cameraTable
end

function cameraController:onMenu()
    Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    if self._promiseRunning and self._promiseRunning:getStatus() == promise.Status.Started then
        self._promiseRunning:cancel()
    end

    local function 

end

function cameraController:KnitStart()
    self:onStart()
    self:onRumble()
end

return cameraController