type enum = {
    value: number
}

local enum = {}

local function equal(self, value)
    return ((self.name == value.name) and (self.value == value.value)) or (self.name == value)
end

local function new(name: string, value: number): enum
    local newEnum = setmetatable({
        value = value,
        name = name
    }, {
        __index = enum,
        __eq = equal
    })
    return newEnum
end

local function setup(enums)
    local newEnumList = {}
    for value, name in enums do
        newEnumList[name] = new(name, value)
    end
    return newEnumList
end

return setmetatable({new = new, setup = setup}, {__index = enum})