local log = {}

function log:Log(pathName, toLog)
    print(pathName and (`{debug.traceback()}`..`\n{toLog}\n`) or `{toLog}\n`)
end

function log:Warn(pathName, toWarn)
    warn(pathName and (`{debug.traceback()}`..`\n{toWarn}\n`) or `{toWarn}\n`)
end

function log:Error(pathName, toError)
    error(pathName and (`{debug.traceback()}`..`\n{toError}\n`) or `{toError}\n`)
end

local function new()
    local self = {}
    return setmetatable(self, {
        __index = log
    })
end

return setmetatable({new = new}, {})