local core = {
    player = {}
}

function core.player:Destroy()

end

local function new(playerInstance: Player)
    local self = {}
    self.instance = playerInstance
    self.cached = {} -- Datastore, ...
    self.
    self.team = core._G.net.ServerClasses.TeamClass.new(core._G.net.ENUMS.Team.Visitor)
    return setmetatable(self, {
        __index = core.player
    })
end

local function OnPlayerAdded(playerInstance)
    local playerObject = new(playerInstance)
    
    core._G.net.Players[playerInstance] = playerObject
end

local function OnPlayerRemoving(playerInstance)
    local playerObject = core._G.net.Players[playerInstance]
    playerObject:Destroy()
    -- SAVE DATA HERE
    if core._G.net.GAMERULES.SaveData then
        
    end

    core._G.net.Players[playerInstance] = nil
end

return function(main)
    core = main
    core._G.net.ServerClasses["PlayerClass"] = setmetatable({new = new}, {})
    core._G.Start:Connect(function()
        for _, playerInstance in core._G.net.Services.Players:GetPlayers() do
            task.spawn(OnPlayerAdded(playerInstance))
            core._G.net.Events.Players.PlayerAdded:Fire(playerInstance)
        end
        core._G.net.Services.Players.PlayerAdded:Connect(function(playerInstance)
            OnPlayerAdded(playerInstance)
            core._G.net.Events.Players.PlayerAdded:Fire(playerInstance)
        end)
        core._G.net.Services.Players.PlayerAdded:Connect(function(playerInstance)
            core._G.net.Services.Players.PlayerRemoving:Fire(playerInstance)
            OnPlayerRemoving(playerInstance)
        end)
    end)
end