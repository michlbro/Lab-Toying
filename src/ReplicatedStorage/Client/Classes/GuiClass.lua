local core = {
    Gui = {}
}

local function new()

end

return function(main)
    core = main(core)
    core._G.net.ClientClasses.GuiClass = setmetatable({new = new}, {__index = core.Gui})

    core._G.Start:Connect(function()
        core._G.net.GuiContainer.PlayerList = new()
    end)
end