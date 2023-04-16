local core = {
    TeamLevel = {},
    Characters = {},
    RespawnTime = {},
    ENUMS = {},
    Team = {}
} :: any

function core.Team:_UpdateCharacter()
    local character = core.Characters[self.team]
    if not character then
        return false
    end
    if character == "default" then
        self.player.Character.Humanoid.Died:Once(function()
            task.wait(core.RespawnTime[self.team])
            for _, objects in self.player.Character:GetChildren() do
                if not objects:IsA("BasePart") then
                    continue
                end
                objects.CanCollide = true
            end
            self.player:LoadCharacter()
        end)
        return true
    end
    local mainCharacter = self.player.Character
    local clonedHumanoid = self.player.Character.Humanoid:Clone()
    local clonedAnimate = self.player.Character.Animate:Clone()
    local teamCharacter = core.Characters[self.team]:Clone()
    teamCharacter.Name = mainCharacter.Name
    teamCharacter.Humanoid:Destroy() -- ?? maybe
    self.player.Character = teamCharacter
    clonedHumanoid.Parent = teamCharacter
    clonedAnimate.Parent = teamCharacter
    core._G.net.Networking.Player.Team.UpdateCamera:FireClient(self.player, teamCharacter.HumanoidRootPart)
    mainCharacter:Destroy()
    self.player.Character.Humanoid.Died:Once(function()
        task.wait(core.RespawnTime[self.team])
        self.player:LoadCharacter()
    end)
    return true
end

function core.Team:_SetupPlayer()
    if self.characterAddedConnection then
        self.characterAddedConnection:Disconnect()
    end
    self.player:LoadCharacter()
    self.characterAddedConnection = self.player.CharacterAdded:Connect(function(character)
        self:_UpdateCharacter()
    end)
    return self:_UpdateCharacter()
end

function core.Team:GetTeam()
    return self.team
end

function core.Team.GetTeamLevel(team)
    if not core.ENUMS[team] then
        return
    end
    return core.TeamLevel[team]
end

function core.Team:ChangeTeam(team)
    if not core.ENUMS[team] then
        return false
    end
    self.team = team
    local success = core.Team:_SetupPlayer()
    if not success then
        return false
    end
    core._G.net.Events.Players.TeamChanged:Fire(self.player, team)
    return true
end

function core.Team:Destroy()

end


local function new(teamEnum, player: Player)
    local self = {}
    self.player = player
    self.team = teamEnum
    if not core._G.net.GAMERULES.Team then
        self.team = nil
        return setmetatable(self, {
            __index = core.Team
        })
    end
    local teamObject = setmetatable(self, {
        __index = core.Team
    })
    teamObject:_SetupPlayer()
    return teamObject
end

return function(main)
    core = main(core)

    if core._G.net.GAMERULES.Team then
        core._G.net.Services.Players.CharacterAutoLoads = false
    end

    -- // Teams init
    -- Get Enum. Shared/Enums
    -- Get Character Config. ServerStorage/Server/Configuration
    local ENUMS = require(core._G.net.Services.ReplicatedStorage.Shared.Enums.Team)
    core._G.net.ENUMS["Team"] = ENUMS
    core.ENUMS = ENUMS
    local characters = require(core._G.net.Paths.ServerConfiguration.Team.CharacterConfig)
    for enum, config in characters do
        if not core.ENUMS[enum] then
            continue
        end
        core.Characters[enum] = config.character
        core.TeamLevel[enum] = config.level
        core.RespawnTime[enum] = config.respawnTime or 0
    end
    core._G.net.ServerClasses["TeamClass"] = setmetatable({new = new}, {
        __index = core.Team
    })
end