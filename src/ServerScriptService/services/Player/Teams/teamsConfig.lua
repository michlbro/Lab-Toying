-- @ Character Config
-- @ Created by XxprofessgamerxX

-- @ Services
local insertService: InsertService = game:GetService("InsertService")
local teamsService = game:GetService("Teams")

-- @ Load character assets
local function loadAssets(assetId: Number): Model?
    local success, model = pcall(insertService.LoadAsset, insertService, assetId)
    if success then
        model.Parent = script
        return model
    else
        return nil
    end
end

local characters = {
    ["Subject"] = loadAssets()
}

local teams =  {
    ["Default"] = {accessLevel = 0, characters.Subject, team = "Subject"},
    ["Subject"] = {accessLevel = 0, characters.Subject}
}

-- @ Setup teams
for team, _ in pairs(teams) do
    if team == "Default" then
        continue
    end

    local teamInstance = Instance.new("Team")
    teamInstance.Parent = teamsService

    teamInstance.Name = team
    teamInstance.AutoAssignable = false
    teamInstance.TeamColor = _.color or BrickColor.random()
end


return teams