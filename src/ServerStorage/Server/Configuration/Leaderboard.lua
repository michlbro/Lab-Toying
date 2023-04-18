return {
    leaderboardStructure = {
        {"GBP", "NumberValue"},
        {"Team", "StringValue"}
    },
    leaderboardValueLocation = function(player, leaderboard)
        leaderboard.GBP.Value = player.cached.money
        leaderboard.Team.Value = player.team:GetTeam()
    end
}