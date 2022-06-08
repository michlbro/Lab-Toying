local modulesToLoad = {
    
}

local modulesLoaded = {}

function load()
    for _, module: ModuleScript? in pairs() do
        if module:IsA("ModuleScript") then
            modulesLoaded[module.Name] = require(module)
        end
    end
end

return {load = load, modulesLoaded}