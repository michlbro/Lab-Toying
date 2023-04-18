local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local shared = ReplicatedStorage.Shared
local server = ServerStorage.Server

local ModuleInitialiser = require(shared.ModuleInitialiser)
local GlobalEnvironment = require(server.Configuration.GlobalEnvironment)

local initialiser = ModuleInitialiser.new(GlobalEnvironment, true)

for _, instance in server.Classes:GetDescendants() do
    if not instance:IsA("ModuleScript") then
        continue
    end
    initialiser:Require(instance, nil)
end

for _, instance in shared.Classes:GetDescendants() do
    if not instance:IsA("ModuleScript") or not string.match(instance.Name, "Class$") then
        continue
    end
    initialiser:Require(instance, nil)
end

print("\n[ServerCore Explorer]:", initialiser, `\n----\n{initialiser:GetLoadedModules()}----\n`,`Loaded: {initialiser:GetLoadedModulesCount()}\n`, `Errored: {initialiser:GetErroredModulesCount()}`)
initialiser:Start()
