local ReplicatedStorage = game:GetService("ReplicatedStorage")

local knit = require(ReplicatedStorage:WaitForChild("Packages").knit)
local ClientScripts = ReplicatedStorage:WaitForChild("ClientScripts")

local function loadControllers()
    local Controllers = ClientScripts:FindFirstChild("Controllers")

    if not Controllers then
        error("[Knit-Server]: Service folder does not exist.")
    end

    local startTick = tick()
    for _, module: ModuleScript in Controllers:GetDescendants() do
        if module.ClassName == "ModuleScript" and string.match("Controller$", module.Name) then
            print(string.format("[%s]-[Knit-Client]: Loading: %s", (tick() - startTick), module.Name))
            require(module)
        end
    end
end

local function loadComponents()
    local Components = ClientScripts:FindFirstChild("Components")
    if not Components then
        return
    end

    local startTick = tick()
    for _, module: ModuleScript in Components:GetDescendants() do
        if module.ClassName == "ModuleScript" and string.match("Component$", module.Name) then
            print(string.format("[%s]-[Components-Client]: Loading: %s", (tick() - startTick), module.Name))
            require(module)
        end
    end
end

local startTick = tick()
loadControllers()
knit.Start():andThen(function()
    warn(string.format("[Knit-Client]: Started in %s!", (tick() - startTick)))
    startTick = tick()
    loadComponents()
    warn(string.format("[Components-Client]: Started in %s!", (tick() - startTick)))
end)