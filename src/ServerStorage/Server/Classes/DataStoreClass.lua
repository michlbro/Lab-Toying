local core = {
    datastore = {}
}

local function new(dataStructure)

end

return function(main)
    core = main
    core.serialiser = require(core._G.net.Paths.ServerConfiguration.DataStore.Serialiser)
    core._G.net.Vars.DataStore = new(require(core._G.net.Paths.ServerConfiguration.DataStore.DataStructure))

    
end