local componentsToLoad = {}
local componentsLoaded = {}

local function load()
    for _, component: ModuleScript? in pairs(componentsToLoad) do
        if component:IsA("ModuleScript") then
            componentsLoaded[component.Name] = require(component)
        end
    end
end

return {load = load, componentsLoaded}