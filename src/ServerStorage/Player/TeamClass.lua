local team = {
    HumanoidDescriptions = {}
}

function team:_UpdateCharacter()
    local character = self.instance.Character or self.instance.CharacterAdded:Wait()
    if not character then
        return
    end
    local humanoid = character:WaitForChild("Humanoid")
    if team.HumanoidDescriptions[self.team] then
        humanoid:ApplyHumanoidDescription(team.HumanoidDescriptions[self.team])
    end
    humanoid.Died:Once(function()
        self.instance:LoadCharacter()
    end)
end

function team:ChangeTeam(team)
    self.currentTeam = team
    self:_UpdateCharacter()
end

local function new(team, player)
    local self = {}
    self.currentTeam = team
    self.instance = player
    
    task.spawn(team._UpdateCharacter, self)
    self.instance.CharacterAdded:Connect(function()
        team._UpdateCharacter(self)
    end)
    return setmetatable(self, {})
end

local function ApplyHumanoidDescription(humanoidDescription)
    local humnaoidDescriptionObject = Instance.new("HumanoidDescription")
    humnaoidDescriptionObject.Parent = script
    humnaoidDescriptionObject:SetAccessories(humanoidDescription.accessories)
    for property, clothingID in humanoidDescription.clothing do
        humnaoidDescriptionObject[property] = clothingID
    end
    team.HumanoidDescriptions[humanoidDescription.team] = humnaoidDescriptionObject
end

return setmetatable({new = new, ApplyHumanoidDescription = ApplyHumanoidDescription}, {})