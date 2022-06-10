-- @ light atmosphere component
-- @ Created by XxprofessgamerxX

-- @ Services
local replicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local players: Players = game:GetService("Players")
local lighting: Lighting = game:GetService("Lighting")

-- @ Player variables
local player = players.LocalPlayer

-- @ Packages
local components = require(replicatedStorage.Packages.component)
local trove = require(replicatedStorage.Packages.trove)
local promise = require(replicatedStorage.Packages.promise)

-- @ Create component
local lightingAtmosphere = components.new {
    Tag = "lightingRegion",
    Extensions = {}
}

function lightingAtmosphere:Construct()
    self.trove = trove.new()
    self._lightingConfigs = require(script.Parent.lightingConfigs)
end

function lightingAtmosphere:Start(component)
    local lightingConfig
    for _, config in pairs(self._lightingConfigs:GetChildren()) do
        if config:IsA("ModuleScri[t") and config.Name:match("Config$") then
            lightingConfig = require(config)
        end
    end
    if not lightingConfig then
        return
    end

    self.trove:Extend():AttachToInstance(component.Instance):Connect(component.Instance.Touched, function(partHit)
        local getPlayer: Player = players:GetPlayerFromCharacter(hit.Parent)
        if not getPlayer == player then
            return
        end

        local tween = promise.new(function(resolve, reject, onCancel)
            local tweens = {}
            
            for name, values in pairs(lightingConfig) do
                
            end
        end)
    end)
end

return lightingAtmosphere