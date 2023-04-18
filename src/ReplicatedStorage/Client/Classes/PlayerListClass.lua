local core = {
    PlayerList = {}
}

local function new(playerList)
    local self = {}
    self.config = playerList

    return setmetatable(self, {
        __index = core.PlayerList
    })
end

return function(main)
    core = main(core)
    core._G.net.VariableContainer.PlayerList = new(core._G.net.Paths.ClientConfiguration.PlayerList.PlayerList)
end