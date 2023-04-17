local core = {
    Reactor = {}
}

local function new(reactorConfig)

end

return function(main)
    core = main(core)
    core._G.net.ServerClasses.ReactorClass = setmetatable({new = new}, {
        __index = core.Reactor
    })
end