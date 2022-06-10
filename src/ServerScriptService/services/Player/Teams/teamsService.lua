-- @ Teams Service
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- @ Packages
local knit = require(replicatedStorage.Packages.knit)
local signal =  require(replicatedStorage.Packages.signal)

-- @ Create teamsService
local teamsService = knit.CreateService {
    Name = "teamsService",
    Client = {},
    _teamsConfig = require(script.Parent.teamsConfig),
    _playerTeamCallback = {}
}

-- @ Client Events

-- @ Set player team
function teamsService.Client:setTeam(player: player, team: Team)
    self.Server:setTeam(player, team)
end

-- --

function teamsService:setTeam(player: Player, team: Team)
    team = team or game:GetService("Teams"):FindFirstChild(self._teamsConfig.Default.team)

    if not team then
        print("[teamsService]: Teams not configured properly. (team does not exist)")
        return
    end

    if not self._playerTeamCallback[player] then
        self._playerTeamCallback[player] = signal.new()
    end

    -- @ Set player team
    -- @ Change leaderboard team name.
    player.Team = team
    self._playerTeamCallback[player]:Fire(team)

    -- @ Set player character
    local characterService = knit.GetService("characterService")
    characterService:changeCharacter(player, self._teamsConfig[team.Name][2])
end

-- @ Services that needs the team callback
function teamsService:getTeamCallback(player)
    if not self._playerTeamCallback[player] then
        self._playerTeamCallback[player] = signal.new()
    end
    return self._playerTeamCallback[player]
end

function teamsService:KnitStart()
    players.PlayerRemoving:Connect(function(player)
        if self._playerTeamCallback[player] then
            self._playerTeamCallback[player]:Destroy()
            self._playerTeamCallback[player] = nil
        end
    end)
end

return teamsService