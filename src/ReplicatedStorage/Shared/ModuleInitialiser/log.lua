local log = {}

function log:Log(pathName, toLog)
    if not self._shouldLog then
        return
    end
    print(pathName and (`{debug.traceback()}`..`\n{toLog}\n`) or `{toLog}\n`)
end

function log:Warn(pathName, toWarn)
    if not self._shouldLog then
        return
    end
    warn(pathName and (`{debug.traceback()}`..`\n{toWarn}\n`) or `{toWarn}\n`)
end

function log:Error(pathName, toError)
    if not self._shouldLog then
        return
    end
    error(pathName and (`{debug.traceback()}`..`\n{toError}\n`) or `{toError}\n`)
end

function log:Enabled(bool)
    self._shouldLog = bool
end

local function new(shouldLog)
    local self = {}
    self._shouldLog = shouldLog or true
    return setmetatable(self, {
        __index = log
    })
end

return setmetatable({new = new}, {})