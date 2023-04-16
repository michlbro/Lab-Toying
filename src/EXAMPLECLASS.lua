local core = {} :: any

return function(main)
    core = main(core)
end