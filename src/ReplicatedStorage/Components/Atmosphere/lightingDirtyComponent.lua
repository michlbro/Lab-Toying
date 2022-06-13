-- Atmosphere Lighting
-- Created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local lighting = game:GetService("Lighting")
local tween = game:GetService("TweenService")

-- Packages
local components = require(replicatedStorage.Packages.component)
local trove = require(replicatedStorage.Packages.trove)
local promise = require(replicatedStorage.Packages.promise)

-- Client variables
local localPlayer = players.LocalPlayer

-- Extentions
local lightingExtention = require(script.Parent.lightingConfigs.lightingExtentions)

local lightingComponent = components.new({
    Tag = "lightingRegion",
    Extensions = {lightingExtention}
})

-- Component variables
local runningPromise = nil
local lightingClasses = require(script.Parent.lightingConfigs.lightingClasses)

local function hasProperty(instance, property)
    local exists = pcall(function()
        return instance[property]
    end)
    return exists
end

function lightingComponent:runAtmosphere()
    return promise.new(function(resolve, _, onCancel)
        local tweens = {}

        for _, instance in pairs(lighting:GetChildren()) do
            if not self._lightingConfig[instance.ClassName] and not (instance.ClassName == "Sky" or instance.ClassName == "Atmosphere") then
                instance:Destroy()
            end
        end

        for instance, properties in pairs(self._lightingConfig) do
            if not table.find(lightingClasses, instance) then
                continue
            end

            if instance == "Lighting" then
                for property, value in pairs(properties) do
                    if hasProperty(instance, property) then
                        if not value then
                            continue
                        end
                        tweens[#tweens+1] = tween:Create(lighting, self._tweenInfo, {[property] = value})
                        tweens[#tweens]:Play()
                    end
                end
                continue
            end

            local existingInstance = lighting:FindFirstChildOfClass(instance)
            if not existingInstance then
                existingInstance = Instance.new(instance)
                existingInstance.Parent = lighting
            end

            for property, value in pairs(properties) do
                if hasProperty(existingInstance, property) then
                    if not value then
                        continue
                    end
                    tweens[#tweens+1] = tween:Create(existingInstance, self._tweenInfo, {[property] = value})
                    tweens[#tweens]:Play()
                end
            end
        end

        onCancel(function()
            for _, tweensRunning in pairs(tweens) do
                tweensRunning:cancel()
                tweensRunning = nil
            end
            tweens = nil
        end)

        tweens[#tweens].Completed:Wait()
        tweens = nil
        resolve()
    end)
end

function lightingComponent:Construct()
    self._tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

    self._lightingConfig = script.Parent.lightingConfigs:FindFirstChild(self.Instance:GetAttribute("lightingConfig"))
    if not self._lightingConfig then
        return
    end

    self._lightingConfig = require(self._lightingConfig)
    self._trove = trove.new()

    self._trove:Connect(self.Instance.Touched, function(partHit: BasePart)
        local model = partHit:FindFirstAncestorOfClass("Model")
        local player =(model) and players:GetPlayerFromCharacter(model)

        if player.Name == localPlayer.Name then
            if runningPromise then
                runningPromise:cancel()
            end

            runningPromise = self:runAtmosphere()
        end
    end)
end

function lightingComponent:Destroy()
    self._trove:Destroy()
end

return lightingComponent