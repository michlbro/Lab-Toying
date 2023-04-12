local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")

local Common = ReplicatedStorage.Common
local ModuleLoader = require(Common.ModuleLoader)

local clientClasses = ModuleLoader.new(playerScripts.Classes)

-- SoundClass
-- // Handles all the ambient sounds etc.
