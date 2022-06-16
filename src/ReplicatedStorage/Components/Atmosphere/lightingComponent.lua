-- lighting atmosphere
-- Created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local tweenService = game:GetService("TweenService")
local playersService = game:GetService("Players")
local lightingService = game:GetService("Lighting")

-- Packages
local promise = require(replicatedStorage.Packages.promise)
local component = require(replicatedStorage.Packages.component)
local trove = require(replicatedStorage.Packages.trove)

-- Extentions
local lightingExtention = require(script.Parent.lightingConfigs.lightingExtentions)

-- Create component
local lightingComponent = component.new({
    Tag = "lightingRegion",
    Ancestors = {workspace},
    Extensions = {lightingExtention}
})

-- variables
local promises = nil


-- Checks if instance exists
local function checkInstance(instance)
    local exists, instanceCreated = pcall(function()
        return Instance.new(instance)
    end)

    if exists then
        instanceCreated:Destroy()
        return exists
    end
    return exists
end

-- Checks if property exists in instance
local function checkProperty(instance, property)
    local exists = pcall(function()
        return instance[property]
    end)
    return exists
end

function lightingComponent:changeAtmosphere()
    return promise.new(function(resolve, _, onCancel)
        local tweens = {}

        task.spawn(function()
            for _, instance in pairs(lightingService:GetChildren()) do
                if not self._lightingConfig[instance.ClassName] and not instance.Name == "Sky" and not instance.Name == "Atmosphere" then
                    instance:Destroy()
                end
            end
        end)

        for className, properties in pairs(self._lightingConfig) do
            if not checkInstance(className) and not className == "Lighting" or className == "tweenInfo" then
                continue
            end

            if className == "Lighting" then
                for property, value in pairs(properties) do
                    if not checkProperty(lightingService, property) then
                        continue
                    end
                    pcall(function()
                        tweens[#tweens+1] = tweenService:Create(lightingService, self._lightingConfig["tweenInfo"] or TweenInfo.new(1), {[property] = value})
                        tweens[#tweens]:Play()
                    end)
                end
                continue
            end
            
            local instance = lightingService:FindFirstChildOfClass(className)
            if not instance then
                instance = Instance.new(className)
                instance.Parent = lightingService
            end

            for property, value in pairs(properties) do
                if not checkProperty(instance, property) then
                    continue
                end
                pcall(function()
                    tweens[#tweens+1] = tweenService:Create(instance, self._lightingConfig["tweenInfo"] or TweenInfo.new(1), {[property] = value})
                    tweens[#tweens]:Play()
                end)
            end
        end

        onCancel(function()
            for _, tween in pairs(tweens) do
                tween:cancel()
                tween = nil
            end
        end)

        tweens[#tweens].Completed:Wait()
        tweens = nil
        resolve()
    end)
end

function lightingComponent:onTouch()
    if promises and promises:getStatus() == promise.Status.Started then
        promises:cancel()
    end

    promises = self:changeAtmosphere()
end

function lightingComponent:Construct()
    self._lightingConfig = require(self.Instance.lightingConfig)

    self._trove = trove.new()
    self._trove:Connect(self.Instance.Touched, function(hit: BasePart)
        local model = hit:FindFirstAncestorOfClass("Model")
        local player = (model) and playersService:GetPlayerFromCharacter(model)

        if player == playersService.LocalPlayer then
            self:onTouch()
        end
    end)
end

return lightingComponent