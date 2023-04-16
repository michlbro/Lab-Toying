local core = {} :: any

return function(main)
    core = main(core)
    core._G.Start:Connect(function()
        core._G.net.Networking.Player.PlayerInit.DataStoreInvoke:InvokeServer()
    end)
end