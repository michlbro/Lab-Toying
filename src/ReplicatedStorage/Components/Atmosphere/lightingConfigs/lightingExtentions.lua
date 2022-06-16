local lightingExtention = {}

-- Check if the instance is suitable to create a component class.
-- Checks if the lighting region is linked to a lighting(NUM)Config module.
function lightingExtention.ShouldConstruct(component)
    local lightingConfig = component.Instance:FindFirstChild("lightingConfig")
    if not lightingConfig then
        return false
    end

    if not lightingConfig:IsA("ModuleScript") then
        return false
    else
        return true
    end
end

return lightingExtention