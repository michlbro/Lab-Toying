local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local RunService = game:GetService("RunService")
local C

local classes = ReplicatedFirst.Client.Classes
local Signal = require(classes.Signal)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local ui = ReplicatedFirst.Client.Ui
local loadingScreen = require(ui.LoadingScreen)

ReplicatedFirst:RemoveDefaultLoadingScreen()

-- Loading Screen Gui
local loadingBar = {
    loadingBarTitle = Signal.new(),
    loadingBarDetails = Signal.new(),
    loadingBarTotal = Signal.new(),
    loadingBarCurrent = Signal.new(),
}

local screen = loadingScreen(loadingBar)
screen.Parent = playerGui

-- Preloading Assets
