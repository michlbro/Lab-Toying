return {
    leaderboardStructure = {
        {"Team", "StringValue"},
        {"GBP", "NumberValue"}
    },
    leaderboardValueLocation = function(player, leaderboard)
        leaderboard.GBP.Value = player.cached.money
        leaderboard.Team.Value = player.team:GetTeam()
    end
}