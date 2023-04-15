-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Shared
local shared = ReplicatedStorage.Shared
local classes = shared.Classes

-- Classes
local SignalClass = require(classes.SignalClass)
local Log = require(script.log)

-- ModuleInitialiser Logger
local log = Log.new()

local ModuleInitialiser = {}

function ModuleInitialiser:Start()
    self.StartEvent:Fire()
end

function ModuleInitialiser:Require(module, _config)
    local startTime = os.clock()
    log:Log(false, `[Server]: Initialising {module.Name}`)
    local required = require(module)
    required(setmetatable({}, {
        __index = {
            log = Log.new(),
            net = self._globalenvironment,
            Start = self.StartEvent
        }
    }))
    log:Log(false, `[Server]: Done! {math.floor(1000*(os.clock() - startTime) + 0.5)}ms`)
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