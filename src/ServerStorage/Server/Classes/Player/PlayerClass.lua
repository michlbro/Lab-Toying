local core = {
    Player = {}
} :: any

function core.Player:Destroy()
    core._G.log:Log(false, "Player Removing")
end

local function new(playerInstance: Player)
    local self = {}
    self.instance = playerInstance
    self.cached = {} -- Datastore, ...
    self.team = core._G.net.ServerClasses.TeamClass.new(core._G.net.ENUMS.Team["Test Subject"], self.instance)
    self.leaderboard = core._G.net.ServerClasses.LeaderboardClass.new(self)
    return setmetatable(self, {
        __index = core.Player
    })
end

local function OnPlayerAdded(playerInstance)
    local playerObject = new(playerInstance)
    core._G.net.Players[playerInstance] = playerObject
end

local function OnPlayerRemoving(playerInstance)
    local playerObject = core._G.net.Players[playerInstance]
    -- SAVE DATA HERE
    if core._G.net.GAMERULES.SaveData then
        local PlayerSerialisedData = core._G.net.ServerClasses.DataStoreClass.Serialise(core._G.net.VariableContainer.DataStorePlayer:GetDataStructure(), playerObject.cached)
        core._G.net.VariableContainer.DataStorePlayer:SetPlayerData(playerInstance, PlayerSerialisedData)
    end
    playerObject:Destroy()
    core._G.net.Players[playerInstance] = nil
end

return function(main)
    core = main(core)
    core._G.net.ServerClasses["PlayerClass"] = setmetatable({new = new}, {})
    core._G.Start:Connect(function()
        -- Player Creation
        for _, playerInstance in core._G.net.Services.Players:GetPlayers() do
            task.spawn(OnPlayerAdded(playerInstance))
            core._G.net.Events.Player.PlayerAdded:Fire(playerInstance)
        end
        core._G.net.Services.Players.PlayerAdded:Connect(function(playerInstance)
            OnPlayerAdded(playerInstance)
            core._G.net.Events.Player.PlayerAdded:Fire(playerInstance)
        end)
        core._G.net.Services.Players.PlayerRemoving:Connect(function(playerInstance)
            core._G.net.Events.Player.PlayerRemoving:Fire(playerInstance)
            OnPlayerRemoving(playerInstance)
        end)

        -- Teams change up
        core._G.net.Networking.Player.Team.TeamRequest.OnServerInvoke = function(playerInstance, team)
            local player = core._G.net.Players[playerInstance]
            return player.Team:ChangeTeam(team)
        end

        -- DataStore Invoke
        core._G.net.Networking.Player.PlayerInit.DataStoreInvoke.OnServerInvoke = function(playerInstance)
            local player = core._G.net.Players[playerInstance]
            if not player then
                player = core._G.net.Players[core._G.net.Events.Player.PlayerAdded:Wait()]
            end
            -- GetPlayerData
            local PlayerSerialisedData = core._G.net.VariableContainer.DataStorePlayer:GetPlayerData(player.instance)
            player.cached = core._G.net.ServerClasses.DataStoreClass.Deserialise(PlayerSerialisedData)
            core._G.net.Events.Player.LeaderboardUpdate:Fire(playerInstance)
            return
        end

        -- Leaderboard Event
        core._G.net.Events.Player.LeaderboardUpdate:Connect(function(playerInstance)
            local player = core._G.net.Players[playerInstance]
            player.leaderboard:Update()
        end)
    end)
end