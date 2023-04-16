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

function core.DataStore.Serialise(datastructure, cached)
    local data = {}
    for name, dataInfo in datastructure do
        if not cached[name] then
            continue
        end
        data[name] = core.Serialiser.Serialise(dataInfo[2], cached[name])
    end
    return data
end

function core.DataStore:GetPlayerData(playerInstance)
    local success, result = pcall(self.datastore.GetAsync, self.datastore, playerInstance.Name)
    local IsEmpty = false
    for name, _ in self.default do
        if not result or not result[name] then
            IsEmpty = true
            break
        end
    end
    if not success or IsEmpty then
        core._G.log:Warn(false, `{playerInstance.Name}'s data request unsuccessful. Resulting back to default values.\nError: {result}`)
        return self.default
    end
    return result
end

function core.DataStore:SetPlayerData(playerInstance, data)
    local success, result = pcall(self.datastore.SetAsync, self.datastore, playerInstance.Name, data)
    if not success then
        core._G.log:Warn(false, `{playerInstance.Name}'s data did not save successfully.\nError: {result}`)
        return false
    end
    core._G.log:Log(false, `{playerInstance.Name}'s data successfully saved.`)
    return true
end

function core.DataStore:GetDataStructure()
    return self.default
end

local function new(dataStructure)
    local self = {}
    self.datastoreName = dataStructure.name
    self.datastore = core._G.net.Services.DataStoreService:GetDataStore(self.datastoreName)
    self.default = dataStructure.datastructure
    return setmetatable(self, {
        __index = core.DataStore
    })
end

return function(main)
    core = main(core)
    core._G.net.ServerClasses.DataStoreClass = setmetatable({new = new}, {
        __index = core.DataStore
    })
    core.Serialiser = require(core._G.net.Paths.ServerConfiguration.DataStore.Serialiser)
    local dataStructure = require(core._G.net.Paths.ServerConfiguration.DataStore.DataStructure)
    core._G.net.VariableContainer.DataStorePlayer = new(dataStructure)
end