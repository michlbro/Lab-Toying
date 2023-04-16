local ReplicatedStorage = game:GetService("ReplicatedStorage")

local shared = ReplicatedStorage.Shared
local client = ReplicatedStorage.Client

local configuration = client.Configuration
local classes = client.Classes

local ModuleInitialiser = require(shared.ModuleInitialiser)
local GlobalEnvironment = require(configuration.GlobalEnvironment)

local initialiser = ModuleInitialiser.new(GlobalEnvironment, true)

for _, instance in classes:GetDescendants() do
    if not instance:IsA("ModuleScript") then
        continue
    end
    initialiser:Require(instance, nil)
end
print("\n[ClientCore Explorer]:", initialiser, `\n----\n{initialiser:GetLoadedModules()}----\n`, 
        `Loaded: {initialiser:GetLoadedModulesCount()}\n`,
        `Errored: {initialiser:GetErroredModulesCount()}`)
initialiser:Start()
