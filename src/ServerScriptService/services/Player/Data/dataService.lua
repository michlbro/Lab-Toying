-- @ dataStore Service.
-- @ Created by XxprofessgamerxX

-- @ Name of game/datastore to load:
local dataStoreName = "Lab-Toying"

-- @ Services
local replicatedStorage = game:GetService("ReplicatedStorage")

-- @ Packages
local knit = require(replicatedStorage.Packages.knit)
local dataStore2 = require(replicatedStorage.Packages.datastore2)

-- @ Datastore structure
local dataConfig = require(script.Parent.dataConfig)

-- @ knit create service
local dataService = knit.CreateService {
    Name = "dataService"
}

-- @ get data store.
function dataService:getData(player: Player, key: string, original)
    return dataStore2(key, player)
end

function dataService:KnitInit()
    -- @ Combine data structure
    dataStore2.Combine(dataStoreName, table.unpack(dataConfig))
end

return dataService