-- handles tweens
-- Created by StrongBigeMan9

--[=[
    Keeps player on the tween item rather than have them being weld.
    USAGE: Server
    tweenHandlerService:addInstance(instance: basepart)
    -- will then add the part to a table to check if raycasted part is allowed.
]=]

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- Packages
local knit = require(replicatedStorage.Packages.knit)

-- Create tween handler controller
local tweenHandler = knit.CreateController {
    Name = "tweenHandler",
    _raycastWhitelist = {},
    _raycastVerticalLength = -13
}

function tweenHandler:run()
    -- Local player
    local player = players.LocalPlayer

    -- raycast variables
    local lastObjectRaycast = nil
    local lastobjectCFrame = nil


    runService.Heartbeat:Connect(function()
        local character = player.Character
        local humanoidRootPart = (character) and character:FindFirstChild("HumanoidRootPart")
        local humanoid = (character) and character:FindFirstChildWhichIsA("Humanoid")

        if not humanoidRootPart or not humanoid then
            return
        end

        local initalParams = RaycastParams.new()
        initalParams.FilterDescendantsInstances = self._raycastWhitelist
        initalParams.FilterType = Enum.RaycastFilterType.Whitelist

        local finalParams = RaycastParams.new()
        finalParams.FilterDescendantsInstances = {lastObjectRaycast}
        finalParams.FilterType = Enum.RaycastFilterType.Whitelist

        local downVector = humanoidRootPart.CFrame.UpVector * self._raycastVerticalLength
        local moveDirection = humanoid.MoveDirection * 1
        local angle = downVector - Vector3.new(moveDirection.X, 0, moveDirection.Z)

        local verifiedRaycastResult = nil

        local initalRaycastResult = workspace:Raycast(humanoidRootPart.CFrame.Position, angle, initalParams)
        local lastObjectRaycastResult = workspace:Raycast(humanoidRootPart.CFrame.Position, angle, finalParams)

        if initalRaycastResult and lastObjectRaycast then
            verifiedRaycastResult = lastObjectRaycastResult
        else
            verifiedRaycastResult = initalRaycastResult
            lastObjectRaycast = nil
        end

        if verifiedRaycastResult then
            local raycastInstance = verifiedRaycastResult.Instance

            if not lastobjectCFrame then
                lastobjectCFrame = raycastInstance.CFrame
            end

            local currentCFrame = nil

            if lastObjectRaycast and raycastInstance ~= lastObjectRaycast then
                currentCFrame = lastObjectRaycast.CFrame
            else
                currentCFrame = raycastInstance.CFrame
            end

            local relativeCFrame = currentCFrame * lastobjectCFrame:Inverse()
            humanoidRootPart.CFrame = relativeCFrame * humanoidRootPart.CFrame

            lastObjectRaycast = raycastInstance
            lastobjectCFrame = raycastInstance.CFrame
        else
            lastobjectCFrame = nil
        end
    end)
end

function tweenHandler:KnitStart()
    local tweenHandlerService = knit.GetService("tweenHandlerService")
    tweenHandlerService.onInclude:Connect(function(listOfPartTweens)
        self._raycastWhitelist = listOfPartTweens
    end)
    self:run()
end

return tweenHandler