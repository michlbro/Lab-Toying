-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Shared
local shared = ReplicatedStorage.Shared
local classes = shared.Classes

-- Classes
local SignalClass = require(classes.SignalClass)
local Log = require(script.log)

local ModuleInitialiser = {}

function ModuleInitialiser:Start()
    self.StartEvent:Fire()
end

function ModuleInitialiser:Require(module, config)
    local required = require(module)
    required.Init {
        log = Log.new(module),
        net = self._globalenvironment,
        Start = self.StartEvent
    }
end

local function new(globalEnvironment)
    local self = {}

    -- // Module Event
    -- To be waited on until all modules have been required and initialised.
    -- When fired, it is safe to access global environment.
    self.StartEvent = SignalClass.new()

    self._globalenvironment = globalEnvironment

    return setmetatable(self, {
        __index = ModuleInitialiser
    })
end

return setmetatable({new = new}, {})