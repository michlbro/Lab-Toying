-- camera Service
-- Created by XxprofessgamerxX

--[=[

    Used to sync certain camera actions across multiple clients.
    e.g rumble.

]=]

-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

-- Packages
local knit = require(replicatedStorage.Packages.knit)

-- create camera Service
local cameraService = knit.CreateService {
    Name = "cameraService",
    Client = {
        _onRumble = knit.CreateSignal()
    },
    _rumbleCooldown = 2.5, -- in minutes
    _rumbleRandomness = 0.4
}

function cameraService:rumbleInit()
    local time0 = os.time()
    local cooldown = self._rumbleCooldown * 60
    local randomCooldown = math.random(math.floor(cooldown), math.floor(self._rumbleCooldown-self._rumbleRandomness*60))
    runService.Heartbeat:Connect(function()
        if (os.time() - time0) >= randomCooldown then
            time0 = os.time()
            self.Client._onRumble:FireAllClients()
        end
    end)
end

function cameraService:KnitStart()

end

return cameraService


 


