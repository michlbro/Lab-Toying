-- Camera Controller
-- Created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

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
        cameras = {},
        tweenInfo = TweenInfo.new(6, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    }
}

function cameraController:onStart()
    if self._promiseRunning and self._promiseRunning:getStatus() == promise.Status.Started then
        self._promiseRunning:cancel()
        local camera = workspace.CurrentCamera
        camera.CameraType = Enum.CameraType.Follow
        camera.CameraSubject = (self._player.Character) and self._player.Character:FindFirstChild("Humanoid")
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
            local humanoid: Humanoid = (self._player.Character) and self._player.Character:FindFirstChild("Humanoid")
            humanoid.CameraOffset = Vector3.new(0,0,0)
        end)
    end)
end

function cameraController:addMenuCameras(cameraTable)
    self._menu.cameras[#self._menu.cameras] = cameraTable
end

function cameraController:onMenu(countReturned)
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    if self._promiseRunning and self._promiseRunning:getStatus() == promise.Status.Started then
        self._promiseRunning:cancel()
    end

    local function chooseCamera(count: number)
        if not count then
            count = 1
        end
        local cameraChosen = self._menu.cameras[count]

        return cameraChosen, count
    end

    self._promiseRunning = promise.new(function(resolve, _, onCancel)
        local tween

        local cameraChosen, count = chooseCamera(countReturned)
        workspace.CurrentCamera.CFrame = cameraChosen.startCFrame
        tween = tweenService:Create(workspace.CurrentCamera, self._menu.tweenInfo, {CFrame = cameraChosen.endCFrame})
        tween:Play()

        onCancel(function()
            tween:Cancel()
            tween = nil
        end)
        tween.Completed:Wait()
        tween = nil
        resolve(count)
    end):andThen(function(count)
        self:onMenu(count + 1)
    end)
end

function cameraController:KnitStart()
    self:onStart()
    self:onRumble()
end

return cameraController