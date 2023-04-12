local loader = {}

local function SearchPathAndLoad(loaded, path)
    -- append loaded modules here
    local loadedModules = {}

    -- search through children for modules
    for _, instance in path:GetChildren() do
        if instance:IsA("ModuleScript") and string.match(instance.Name, "Class$") then
            local module = require(instance)
            loadedModules[instance.Name] = module
        elseif instance:IsA("Folder") then
            SearchPathAndLoad(loadedModules, instance)
        end
    end

    -- append loaded modules to the main table
    for name, class in loadedModules do
        loaded[name] = class
    end
end

local function new(path)
    local self = {}
    SearchPathAndLoad(self, path)

    return setmetatable(self, {__index = loader})
end

return setmetatable({new = new}, {})