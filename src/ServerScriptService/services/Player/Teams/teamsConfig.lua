-- @ Character Config
-- @ Created by XxprofessgamerxX

-- @ Services
local insertService = game:GetService("InsertService")

-- @ Load character assets
local loadAssets(assetId: Number): Model
    local success, model = pcall(insertService.loadAssets, insertService, assetId)
    if success then
        return model
    else
        return nil
    end
end

local characters = {
    ["Subject"] = loadAssets()
}

return {
    ["Default"] = {accessLevel = 0, characters.Subject}
    ["Subject"] = {accessLevel = 0, characters.Subject}
}