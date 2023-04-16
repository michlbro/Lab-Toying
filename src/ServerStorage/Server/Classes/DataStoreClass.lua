local core = {
    Data = {},
    DataStore = {}
} :: any

function core.DataStore.Deserialise(data)
    local cached = {}
    for name, value in data do
        cached[name] = core.Serialiser.Deserialise(value[2], value[1])
    end
    return cached
end

function core.DataStore.Serialise(cached)
    local data = {}
    for name, value in cached do
        data[name] = core.Serialiser.Serialise(value, typeof(value))
    end
    return data
end

function core.DataStore:GetPlayerData(playerInstance)
    local success, result = pcall(self.datastore.GetAsync, self.datastore, playerInstance.Name)
    local IsEmpty = false
    for name, _ in core.Data.Default do
        if not result or not result[name] then
            IsEmpty = true
            break
        end
    end
    if not success or IsEmpty then
        core._G.log:Warn(false, `{playerInstance.Name}'s data request unsuccessful. Resulting back to default values.\nError: {result}`)
        return core.Data.Default
    end
    return result
end

local function new(dataStructure)
    local self = {}
    self.datastoreName = dataStructure.name
    self.datastore = core._G.net.Services.DataStoreService:GetDataStore(self.datastoreName)
    return setmetatable(self, {
        __index = core.DataStore
    })
end

return function(main)
    core = main(core)
    core._G.net.ServerClasses.DataStore = setmetatable({new = new}, {
        __index = core.DataStore
    })
    core.Serialiser = require(core._G.net.Paths.ServerConfiguration.DataStore.Serialiser)
    local dataStructure = require(core._G.net.Paths.ServerConfiguration.DataStore.DataStructure)
    core._G.net.VariableContainer.DataStorePlayer = new(dataStructure)
    core.Data.Default = dataStructure.datastructure
    
end