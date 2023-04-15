local log = {}

function log:Log(pathName, toLog)
    print(`{pathName and self._stringPath or ""} \n{toLog} \n `)
end

function log:Warn(pathName, toWarn)
    warn(`{pathName and self._stringPath or ""} \n{toWarn} \n `)
end

function log:Error(pathName, toError)
    error(`{pathName and self._stringPath or ""} \n{toError} \n `)
end

local function GetScriptPath(path, child)
    if child.Parent == game then
        table.insert(path, "game")
        local str = ""
        for i = #path, 1, -1 do
            local instance = path[i]
            str..=`{instance.Name or "game"}/`
        end
        return str
    end
    table.insert(path, child)
    return GetScriptPath(path, child.Parent)
end

local function new(module)
    local self = {}
    self._stringPath = GetScriptPath({}, module)
    return setmetatable(self, {
        __index = log
    })
end

return setmetatable({new = new}, {})