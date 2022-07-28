local ReplicatedStorage = game:GetService("ReplicatedStorage")

local knit = require(ReplicatedStorage:WaitForChild("Packages").knit)
local promise = require(ReplicatedStorage:WaitForChild("Packages").promise)

local lightingInstances = require(script.Parent.LightingInstances)

local atmosphereController = knit.CreateController {
    Name = "AtmosphereController",
    __lightingInstances = lightingInstances,
    __currentlyTweening = nil,
    __tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
}
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

function atmosphereController:setAtmosphere(ligthingSettings)
    if self.__currentlyTweening then
        if self.__currentlyTweening:getStatus() == promise.Status.Started then
            self.__currentlyTweening:cancel()
        end
    end

    self.__currentlyTweening = promise.new(function(resolve, _, onCancel)
        local tweens = {}

        for _, instance: PostEffect in Lighting:GetChildren() do
            if ligthingSettings[instance] then
                continue
            end
            local propertyList = {}
            for property, value in self.__lightingInstances[instance.Name] do
                if property == "Name" or property == "ClassName" then
                    continue
                end
                propertyList[property] = value
            end
            tweens[#tweens+1] = TweenService:Create(instance, self.__tweenInfo, propertyList)
            tweens[#tweens]:Play()
        end
        tweens[#tweens].Completed:Wait()

        for instance, properties in ligthingSettings do
            if not self.__lightingInstances[instance] then
                continue
            end

            local lightingInstanceExists = Lighting:FindFirstChild(instance)
            if not lightingInstanceExists then
                lightingInstanceExists = Instance.new(instance.ClassName)
                for propety, value in self.__lightingInstances[instance] do
                    if propety == "ClassName" or propety == "Name" then
                        continue
                    end
                    if typeof(value) == "number" then
                        lightingInstanceExists[propety] = 0
                    elseif typeof(value) == "Color3" then
                        lightingInstanceExists[propety] = Color3.new()
                    end
                end
                lightingInstanceExists.Parent = Lighting
            end

            local propertiesList = {}
            for property, value in properties do
                if not self.__lightingInstances[instance][property] then
                    continue
                end

                propertiesList[property] = value
            end
            tweens[#tweens+1] = TweenService:Create(lightingInstanceExists, self.__lightingInstances, propertiesList)
            tweens[#tweens]:Play()
        end

        onCancel(function()
            for _, tween: Tween in tweens do
                if tween.PlaybackState == Enum.PlaybackState.Playing then
                    tween:Cancel()
                end
                tween = nil
            end
        end)
        tweens[#tweens].Completed:Wait()
        for _, _tween: Tween in tweens do
            _tween = nil
        end
        resolve()
    end)
end

function atmosphereController:KnitStart()
    
end

return atmosphereController