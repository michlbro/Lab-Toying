-- @ light atmosphere component
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local players: Players = game:GetService("Players")
local lighting: Lighting = game:GetService("Lighting")
local tweenService: TweenService = game:GetService("TweenService")

-- @ Player variables
local player = players.LocalPlayer

-- @ Packages
local components = require(replicatedStorage.Packages.component)
local trove = require(replicatedStorage.Packages.trove)
local promise = require(replicatedStorage.Packages.promise)

-- @ Create component
local lightingAtmosphere = {
    _lightingConfigs = script.Parent.lightingConfigs,
    _tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
    _lightingClasses = require(script.Parent.lightingConfigs.lightingClasses),
    _lightingIgnore = {
        "Sky",
        "Atmosphere"
    },
    _trove = trove.new()
}
lightingAtmosphere.__index = lightingAtmosphere

function lightingAtmosphere.Started(component)
    local self = setmetatable({}, lightingAtmosphere)
    print("A")
    local lightingConfig
    for _, config in pairs(self._lightingConfigs:GetChildren()) do
        if config:IsA("ModuleScript") and config.Name:match("Config$") and config.Name == component.Instance.Name then
            lightingConfig = require(config)
        end
    end
    if not lightingConfig then
        return
    end
    self._trove = trove.new()
    self._trove:Extend():Connect(component.Instance.Touched, function(partHit)
        local getPlayer: Player = players:GetPlayerFromCharacter(partHit.Parent)
        if not getPlayer == player then
            return
        end

        if lightingAtmosphere._tween then
            lightingAtmosphere._tween:cancel()
        end

        lightingAtmosphere._tween = promise.new(function(resolve, _, onCancel)
            local tweens = {}
            for name, values in pairs(lightingConfig) do
                if not table.find(self._lightingClasses, string.format(name, "Effect")) then
                    print(name)
                    continue
                end

                if name == "Lighting" then

                    for _, postEffect in pairs(lighting:GetChildren()) do
                        if not lightingConfig[postEffect.ClassName] and not table.find(self._lightingIgnore, postEffect.ClassName) then
                            
                            postEffect:Destroy()
                        end
                    end
                    
                    for property, value in pairs(values) do
                        local checkProperty = promise.new(function(resolve, reject)
                            local success = pcall(function() return lighting[property] end)
                            if success then
                                resolve()
                            else
                                reject()
                            end
                        end):andThen(function()
                            if not value then
                                return
                            end
                            tweens[#tweens+1] = tweenService:Create(lighting, self._tweenInfo, {[property] = value})
                            tweens[#tweens]:Play()
                        end, function()
                            return
                        end):await()
                    end
                    continue
                end

                for _, postEffect in pairs(lighting:GetChildren()) do
                    if not lightingConfig[postEffect.ClassName] and not table.find(self._lightingIgnore, postEffect.ClassName) then
                        postEffect:Destroy()
                    end
                end

                local lightingInstance = lighting:FindFirstChildOfClass(name)
                if not lightingInstance then
                    lightingInstance = Instance.new(name)
                    lightingInstance.Parent = lighting
                end

                for property, value in pairs(values) do
                    local checkProperty = promise.new(function(resolve, reject)
                        local success = pcall(function() return lightingInstance[property] end)
                        if success then
                            resolve()
                        else
                            reject()
                        end
                    end):andThen(function()
                        if not value then
                            return
                        end
                        tweens[#tweens+1] = tweenService:Create(lightingInstance, self._tweenInfo, {[property] = value})
                        tweens[#tweens]:Play()
                    end, function()
                        return
                    end):await()
                end
            end

            if #tweens == 0 then
                resolve()
            end

            onCancel(function()
                for _, tweenActive: Tween in pairs(tweens) do
                    tweenActive:Cancel()
                    tweenActive = nil
                end
            end)
            tweens[#tweens].Completed:Wait()
            tweens = nil
            resolve()
        end)
    end)
end

function lightingAtmosphere.Stopped()
    lightingAtmosphere._trove:Clean()
end

local component = components.new {Tag = "lightingRegion", Extensions = {lightingAtmosphere}}

return lightingAtmosphere