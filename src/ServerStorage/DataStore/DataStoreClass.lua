local DataStore = game:GetService("DataStoreService")

local datastore = {}

function datastore:GetPlayerData(player)
    local success, result = pcall(self.datastore.GetAsync, self.datastore, player.Name)
    if success then
        return result
    else
        warn(`{player.Name} data was not successfully requested. error: {result}`)
        return self.datastructure
    end
end

function datastore:SavePlayerData(player, data)
    local success, result = pcall(self.datastore.SetAsync, self.datastore, player.Name, data)
    if success then
        return true
    else
        warn(`{player.Name} data was not successfully saved. error: {result}`)
        return false
    end
end

local function new(datastoreConfig)
    local self = {}
    self.name = datastoreConfig.name
    self.datastructure = datastore.datastructure
    self.datastore = DataStore:GetDataStore(DataStore)

    return setmetatable(self, {__index = DataStore})
end

return setmetatable({new = new}, {})