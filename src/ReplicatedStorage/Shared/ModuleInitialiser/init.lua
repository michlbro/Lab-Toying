-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local isClient = RunService:IsClient()

-- Shared
local shared = ReplicatedStorage.Shared
local classes = shared.Classes

-- Classes
local SignalClass = require(classes.SignalClass)
local Log = require(script.log)

-- ModuleInitialiser Logger
local log = Log.new()

local ModuleInitialiser = {}

function ModuleInitialiser:GetLoadedModules()
    return self._loadedModules
end

function ModuleInitialiser:GetLoadedModulesCount()
    return self._loadedModulesCount
end

function ModuleInitialiser:GetErroredModulesCount()
    return self._erroredModulesCount
end

function ModuleInitialiser:Start()
    log:Log(false, `\n[{isClient and "Client" or "Server"}]: Starting...`)
    self.StartEvent:Fire()
end

function ModuleInitialiser:Require(module, _config)
    local startTime = os.clock()
    log:Log(false, `[{isClient and "Client" or "Server"}]: Initialising {module.Name}`)
    local success, err = pcall(function()
        local required = require(module)
        required(function(core)
            return setmetatable(core, {
                __index = {
                    _G = {
                        log = Log.new(),
                        net = self._globalenvironment,
                        Start = self.StartEvent
                    }
                }
            })
        end)
    end)
    if not success then
        log:Warn(false, `\n[{isClient and "Client" or "Server"}]:\nError Initialising: {module.Name}\nIssue: {err}`)
        table.insert(self._erroredModules, module.Name)
        self._erroredModulesCount += 1
        return
    end
    log:Log(false, `[{isClient and "Client" or "Server"}]: Done! {math.floor(1000*(os.clock() - startTime) + 0.5)}ms`)
    self._loadedModules ..= `{module.Name}\n`
    self._loadedModulesCount += 1
end

local function new(globalEnvironment, shouldLog)
    local self = {}
    log:Enabled(shouldLog)
    -- // Module Event
    -- To be waited on until all modules have been required and initialised.
    -- When fired, it is safe to access global environment.
    self.StartEvent = SignalClass.new()
    self._loadedModules = ""
    self._loadedModulesCount = 0
    self._erroredModulesCount = 0
    self._erroredModules = {}
    self._globalenvironment = globalEnvironment

    return setmetatable(self, {
        __index = ModuleInitialiser
    })
end

return setmetatable({new = new}, {})