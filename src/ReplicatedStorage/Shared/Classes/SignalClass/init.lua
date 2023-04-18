local core = {} :: any

return function(main)
    core = main(core)
    core._G.net.ServerClass.SignalClass = require(script.Signal)
end