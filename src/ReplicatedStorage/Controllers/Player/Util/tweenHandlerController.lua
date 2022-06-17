-- handles tweens
-- Created by StrongBigeMan9

--[=[
    Keeps player on the tween item rather than have them being weld.
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
    _raycastWhitelist = {workspace.g},
    _raycastVerticalLength = -13
}

function tweenHandler:includeParts(instance: BasePart)
    if not instance:IsA("BasePart") then
        return
    end

    table.insert(self._raycastWhitelist, instance)
end

function tweenHandler:run()
    -- Local player
    local player = players.LocalPlayer

    -- raycast variables
    local raycastObject0 = nil
    local objectCFrame0 = nil


    runService.Heartbeat:Connect(function()
        -- variables needed.
        local character = player.Character
        local humanoidRootPart = (character) and character:FindFirstChild("HumanoidRootPart")
        local humanoid = (character) and character:FindFirstChildWhichIsA("Humanoid")

        if not humanoidRootPart or humanoid then
            return
        end

        local raycastParams = RaycastParams.new()
        raycastParams.FilterDescendantsInstances = self._raycastWhitelist
        raycastParams.FilterType = Enum.RaycastFilterType.Whitelist

        local raycastParams2 = raycastParams.new()
        raycastParams2.FilterDescendantsInstances = {raycastObject0}
        raycastParams.FilterType = Enum.RaycastFilterType.Whitelist

        local downVector = humanoidRootPart.CFrame.UpVector * self._raycastVerticalLength
        local moveDirection = humanoid.MoveDirection * 2.5
        local angle = downVector - Vector3.new(moveDirection.X, 0, moveDirection.Z)

        local raycastResult0 = workspace:Raycast(humanoidRootPart.CFrame.Position, angle, raycastParams)
        local raycastObject = workspace:Raycast(humanoidRootPart.CFrame.Position, angle, raycastParams2)

        local raycastResult

        if raycastObject0 and raycastObject then
            raycastResult = raycastObject
        else
            raycastResult = raycastResult0
            raycastObject0 = nil
        end

        if raycastResult then
            local raycastInstance = raycastResult.Instance

            if not objectCFrame0 then
                objectCFrame0 = raycastInstance.CFrame
            end

            local currentCFrame

            if raycastObject0 and raycastInstance ~= raycastObject0 then
                currentCFrame = raycastObject0.CFrame
            else
                currentCFrame = raycastInstance.CFrame
            end

            local deltaDistance = currentCFrame * objectCFrame0:Inverse()
            humanoidRootPart.CFrame *= deltaDistance

            raycastObject0 = raycastInstance
            objectCFrame0 = raycastInstance.CFrame
        else
            raycastObject0 = nil
        end
    end)
end

function tweenHandler:KnitStart()
    --[[
    local tweenHandlerService = knit.GetService("tweenHandlerService")
    tweenHandlerService.onInclude:Connect(function(instance: BasePart)
        self:includeParts(instance)
    end)]]
    print("d")
    self:run()
end
print("g")
return tweenHandler