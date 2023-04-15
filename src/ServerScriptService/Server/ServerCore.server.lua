local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local shared = ReplicatedStorage.Shared
local server = ServerStorage.Server

local configuration = server.Configuration
local classes = server.Classes

local ModuleInitialiser = require(shared.ModuleInitialiser)
local GlobalEnvironment = require(configuration.GlobalEnvironment)

local initialiser = ModuleInitialiser.new(GlobalEnvironment)

for i, instance in classes:GetDescendants() do
    if not instance:IsA("ModuleScript") then
        continue
    end
    initialiser:Require(instance, nil)
end
print(initialiser)
initialiser:Start()
