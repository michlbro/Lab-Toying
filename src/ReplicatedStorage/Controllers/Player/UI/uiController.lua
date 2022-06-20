-- ui controller
-- created by XxprofessgamerxX

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- Packages
local knit = require(replicatedStorage.Packages.knit)
local fusion = require(replicatedStorage.Packages.fusion)

-- Player Variables
local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Fusion variables
local New = fusion.New
local Value = fusion.Value

-- Create controller
local uiController = knit.CreateController {
    Name = "uiController",
    currentlyMounted = {}
}

function uiController:mountScreen(frame: Frame, name: String)
    if not name then
        return false
    end

    if currentlyMounted[name] then
        return false
    end

    currentlyMounted[name] = frame
    self.mainScreenMount:Set(currentlyMounted)
    return true
end

function uiController:unmountScreen(name: String)
    if not currentlyMounted[name] then
        return false
    end

    local mountedScreen = currentlyMounted[name]
    currentlyMounted[name] = nil
    self.mainScreenMount:Set(currentlyMounted)
    return true, mountScreen
end


function uiController:KnitIni()
    self.mainScreenMount = Value.new()
    local screenGui = New "ScreenGui" {
        Parent = playerGui,
        [Children] = self.mainScreenMount,
        Name = "MainScreen"
    }
end

return uiController