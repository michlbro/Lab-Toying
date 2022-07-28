local ReplicatedStorage = game:GetService("ReplicatedStorage")

local knit = require(ReplicatedStorage:WaitForChild("Packages").knit)
local ServerScripts = script.Parent

local function loadServices()
    local Services = ServerScripts:FindFirstChild("Services")

    if not Services then
        error("[Knit-Server]: Service folder does not exist.")
    end

    local startTick = tick()
    for _, module: ModuleScript in Services:GetDescendants() do
        if module.ClassName == "ModuleScript" and string.match("Service$", module.Name) then
            print(string.format("[%s]-[Knit-Server]: Loading: %s", (tick() - startTick), module.Name))
            require(module)
        end
    end
end

local function loadComponents()
    local Components = ServerScripts:FindFirstChild("Components")
    if not Components then
        return
    end

    local startTick = tick()
    for _, module: ModuleScript in Components:GetDescendants() do
        if module.ClassName == "ModuleScript" and string.match("Component$", module.Name) then
            print(string.format("[%s]-[Components-Server]: Loading: %s", (tick() - startTick), module.Name))
            require(module)
        end
    end
end

local startTick = tick()
loadServices()
knit.Start():andThen(function()
    warn(string.format("[Knit-Server]: Started in %s!", (tick() - startTick)))
    startTick = tick()
    loadComponents()
    warn(string.format("[Components-Server]: Started in %s!", (tick() - startTick)))
end)