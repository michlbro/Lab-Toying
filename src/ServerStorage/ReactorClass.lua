local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local common = ReplicatedStorage.Common
local ModuleLoader = require(common.ModuleLoader)

local commonClasses = ModuleLoader.new(common.Classes)

local reactor = {}

function reactor:Step()
    self.temperature += self.rate
    self.temperatureChanged:Fire(math.floor((self.temperature+0.5)*10)/10)

    if self.temperature >= self.meltdownTemperature then
        self.meltdown:Fire()
    elseif self.temperature >= self.criticalTemperature then
        self.critical:Fire()
    elseif self.temperature >= self.warningTemperature then
        self.warning:Fire()
    else
        self.optimal:Fire()
    end
end

function reactor:Reset()
    self.temperature = 0
    self.rate = self.reactorConfig.rate
    self.cooling = 0
end

function reactor:Activated(bool)
    self.enabled = bool
end

local function new(reactorConfig)
    local self = {}
    self.enabled = false

    self.reactorConfig = reactorConfig
    self.temperature = 0
    self.rate = reactorConfig.rate
    self.cooling = 0

    self.warningTemperature = reactorConfig.warningTemperature
    self.criticalTemperature = reactorConfig.criticalTemperature
    self.meltdownTemperature = reactorConfig.meltdownTemperature

    self.warning = commonClasses.SignalClass.new()
    self.critical = commonClasses.SignalClass.new()
    self.meltdown = commonClasses.SignalClass.new()
    self.optimal = commonClasses.SignalClass.new()

    self.temperatureChanged = commonClasses.SignalClass.new()

    local newReactor = setmetatable(self, {
        __index = reactor
    })
    local currentTime = os.clock()
    newReactor.heartbeatConnection = RunService.Heartbeat:Connect(function()
        if (os.clock() - currentTime < 1) or not self.enabled then
            return
        end
        currentTime = os.clock()
        newReactor:Step()
    end)

    return newReactor
end

return setmetatable({new = new}, {})

-- Critical alert 159445410
-- Meltodwn alert 1046365390