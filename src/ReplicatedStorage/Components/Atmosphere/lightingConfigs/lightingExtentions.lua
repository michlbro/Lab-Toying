local lightingConfigs = script.Parent

local lightingExtention = {}

-- Check if the instance is suitable to create a component class.
-- Checks if the lighting region is linked to a lighting(NUM)Config module.
function lightingExtention.ShouldConstruct(component)
    local instanceAttribute = component.Instance:GetAttribute("lightingConfig")
    print(instanceAttribute)
    if not instanceAttribute then
        return false
    end

    if not lightingConfigs:FindFirstChild(instanceAttribute) or not string.match(lightingConfigs[instanceAttribute].Name, "Config$") then
        return false
    else
        return true
    end
end

return lightingExtention