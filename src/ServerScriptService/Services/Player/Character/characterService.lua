-- @ Character Service
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- @ Packages
local knit = require(replicatedStorage.Packages.knit)

-- @ Create Character Service
local characterService = knit.CreateService {
    Name = "characterService",
    Client = {},
    _playerCharacter = {}
}

-- @ Create new player
function characterService:changeCharacter(player: Player, characterModel: Model)
    
    if not characterModel or not characterModel:IsA("Model")then
        print("[characterService]: character model does not exist.")
        return
    end

    if not player.Character or not player.Character.PrimaryPart then
        print("[characterService]: character/primaryPart does not exist.")
        return
    end

    if self._playerCharacter[player] and self._playerCharacter[player] == characterModel.Name then
        return
    end

    self._playerCharacter[player] = characterModel.Name

    local characterCFrame: CFrame = (player.Character.PrimaryPart) and player.Character.PrimaryPart.CFrame or player.Character.HumanoidRootPart.CFrame
    local oldCharacter = player.Character
    local newCharacter: Model = characterModel:Clone()

    player.Character = newCharacter
    newCharacter.Parent = workspace
    newCharacter:SetPrimaryPartCFrame(characterCFrame)
    oldCharacter:Destroy()
    oldCharacter = nil
    characterCFrame = nil
end

-- @ On player leaving, clean up table.
function characterService:KnitInit()
    players.PlayerRemoving:Connect(function(player)
        if self._playerCharacter[player] then
            self._playerCharacter[player] = nil
        end
    end)
end

return characterService
