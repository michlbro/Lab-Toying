-- camera menu
-- Created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Packages
local component = require(replicatedStorage.Packages.component)
local knit = require(replicatedStorage.Packages.knit)

-- Extentions
local cameraMenuExtention = require(script.Parent.cameraConfig.cameraMenuExtention)

-- create camera menu component
local cameramenuComponent = component.new({
    Tag = "cameraMenu",
    Extensions = {cameraMenuExtention}
})

function cameramenuComponent:Construct()
    self.Instance.LocalTransparencyModifier = 1

    local attachment1: Attachment = self.Instance:FindFirstChild("Attachment1")
    local attachment2: Attachment = self.Instance:FindFirstChild("Attachment2")

    local startCFrame = attachment1.WorldCFrame
    local endCFrame = attachment2.WorldCFrame

    local cameraController = knit.GetController("cameraController")

    cameraController:addMenuCameras({startCFrame = startCFrame, endCFrame = endCFrame})
end

return cameramenuComponent