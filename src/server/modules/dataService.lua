-- @ dataService
-- @ Created by XxprofessgamerxX

-- @ Found this script by some weird reason??, that's fine. Use it if you want.

-- @ Create dataService class.
local dataService = {}
dataService.__index = dataService

local dataStoreService = game:GetService("DataStoreService")

-- @ Create dataService
-- @ get dataStore from data store name or ERROR.
-- @ setup dataStore structure.

-- @ How I think I should minimise data loss/weirdness:
-- o for data that has a checkData bool set to TRUE: check if data has been modified in current
--   game based on joining value. If no data changed then dont save that value.
function dataService.new(dataStoreToLoad: string, dataStructure: table)
    local self = setmetatable({}, dataService)

    self.dataStore = dataStoreService:GetDataStore(dataStoreToLoad)
    self.dataStructure = self.__dataStructureSetup(dataStructure)

    self.playerData = {}
    
    return self
end

-- @ Setup data structure
function dataService.__dataStructureSetup(dataStructure: table): table
    local dataStructureSetup = {}

    dataStructureSetup.saveData = true

    for name, value: table? in pairs(dataStructure) do
        local stringName = tostring(name)
        dataStructureSetup[stringName] = {}
        dataStructureSetup[stringName].checkData = value.checkData
        if value.typeOfData == "number" then
            dataStructureSetup[stringName].type = "number"
            dataStructureSetup[stringName].value = 0
        elseif value.typeOfData == "table" then
            dataStructureSetup[stringName].type = "table"
            dataStructureSetup[stringName].value = {}
        else
            dataStructureSetup[stringName].type = "unknown"
            dataStructureSetup[stringName].value = {}
        end
    end

    return dataStructureSetup
end

-- @ Get player data or create new one
function dataService:getPlayerData(player: Player)
    self.playerData[player] = self.dataStructure

    local playerData
    local success, error = pcall(function()
        playerData = self.dataStore:GetAsync(player.UserId)
    end)

    if success and playerData then
        for name, value: table in pairs(playerData) do
            if not self.dataStructure[name] then
                continue
            end

            if not (name == "saveData") and self.dataStructure[name].checkData then
                self.playerData[player][name].changeCount = 0
                self.playerData[player][name].startData = value
            end

            self.playerData[player][name].value = value
        end
    else
        print(error)

        for name, value in pairs(self.playerData[player]) do
            if not (name == "saveData") and value.checkData == true then
                print("TEST")
                self.playerData[player][name].changeCount = 0
                self.playerData[player][name].startData = self.playerData[player][name].value
            end
        end
    end

    return self.playerData[player]
end

function dataService:changePlayerData(player: Player, typeOfData: string, value)
    if not self.dataStructure[typeOfData] or self.playerData[player] then
        return
    end

    if self.dataStructure[typeOfData].checkData then
        self.playerData[player][typeOfData].changeCount += 1
    end

    self.playerData[player][typeOfData].value = value
end

function dataService:savePlayerData(player: Player)
    local playerDataToSave = {}
    
    for name, value in pairs(self.dataStructure) do
        if not self.playerData[player] or not self.playerData[player][name] then
            return
        end
        if not (name == "saveData") and value.checkData then
            if self.playerData[player][name].changeCount > 0 then
                playerDataToSave[name] = self.playerData[player][name].value
            else
                playerDataToSave[name] = self.playerData[player][name].startData
            end
        elseif not (name == "saveData") then
            playerDataToSave[name] = self.playerData[player][name].value
        end

    end

    for name, value in pairs(playerDataToSave) do
        print(name, value)
    end

    local success, err = pcall(function()
        self.dataStore:SetAsync(player.UserId, playerDataToSave)
    end)

    if success then
        print("Data saved!")
    else
        print("Problem", err)
    end
end

return dataService