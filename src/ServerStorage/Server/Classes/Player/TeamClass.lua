local core = {}


function core.Init(core)
    core = core
    core.net.ServerClasses["A"] = "Test"
    core.Start:Connect(function()
        core.net.Events.printG:Connect(function()
            core.log:Log(false, core.net.Players)
        end)
    end)
end

return core