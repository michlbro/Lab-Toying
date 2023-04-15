local core = {
    team = {}
}

function core.Team:_UpdateCharacter()

end

function core.Team:Destroy()

end


local function new(teamEnum, character)
    if not core._G.net.GAMERULES.Team then
        return
    end

    local self = {}
    self.team = teamEnum
    self.characterEvent
    return setmetatable(self, {
        __index = core.Team
    })
end

return function(main)
    core = main
    -- // Teams init
    -- Get Enum. Shared/Enums
    -- Get Character Config. ServerStorage/Server/Configuration
    core._G.net.ENUMS["Team"] = require(core._G.net.Services.ReplicatedStorage.Shared.Enums.Team)

    core._G.net.ServerClasses["TeamClass"] = setmetatable({new = new}, {})
end