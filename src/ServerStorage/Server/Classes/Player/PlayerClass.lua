local core = {}


function core.Init(core)
    core = core
    core.net.ServerClasses["A"] = "Test"
    core.Start:Connect(function()
        core.net.Players["B"] = false
        core.net.Events.printG:Fire()
        task.wait()
        core.net.Players["B"] = true
        core.net.Events.printG:Fire()
        core.log:Log(true, "Horray")
    end)
end

return core