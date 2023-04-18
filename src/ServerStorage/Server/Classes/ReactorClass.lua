local core = {
    Reactor = {}
} :: any

function core.Reactor:GetTemperature()
    return self.temperature
end

function core.Reactor:GetPowerTemperature()
    return self.config.powerTemp
end

function core.Reactor:GetWarningTemperature()
    return self.config.warningTemp
end

function core.Reactor:GetCriticalTemperature()
    return self.config.criticalTemp
end

function core.Reactor:Step()
    self.temperature += self.config.rateOfTemp
end

function core.Reactor:Run()
    if self.heartbeatConnection then
        self.heartbeatConnection:Disconnect()
        self.heartbeatConnection = nil
    end
    local currentClock = os.clock()
    self.heartbeatConnection = core._G.net.Services.RunService.Heartbeat:Connect(function()
        if os.clock() - currentClock >= self.config.rate then
            currentClock = os.clock()
            self:Step()
            self.events.Step:Fire()
        end
    end)
end

local function new(reactorConfig, events)
    local self = {}
    self.config = reactorConfig

    self.events = events

    self.temperature = 0

    return setmetatable(self, {
        __index = core.Reactor
    })
end

return function(main)
    core = main(core)
    core._G.net.ServerClasses.ReactorClass = setmetatable({new = new}, {
        __index = core.Reactor
    })
    local reactor = new(require(core._G.net.Paths.ServerConfiguration.Reactor.Reactor), core._G.net.Events.Reactor)
    core._G.net.VariableContainer.Reactor = reactor
    local availableTemps = {
        Current = function() return reactor:GetTemperature() end,
        Power = function() return reactor:GetPowerTemperature() end,
        Warning = function() return reactor:GetWarningTemperature() end,
        Critical = function() return reactor:GetCriticalTemperature() end,
        Meltdown = function() return reactor:GetMeltdownTemperature() end
    }

    core._G.Start:Connect(function()
        reactor:Run()

        core._G.net.Networking.Reactor.Reactor.GetTemperature.OnServerInvoke = function(_player, typeOfTemperature)
            if not typeOfTemperature or not availableTemps[typeOfTemperature] then
                return
            end
            return availableTemps[typeOfTemperature]()
        end
    end)
end