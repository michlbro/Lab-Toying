local tramlineExtention = {}

function tramlineExtention.ShouldConstruct(component)
    local tramlineIdentifier = component.Instance:GetAttribute("TramlineIdentity")

    if not tramlineIdentifier then
        return false
    end

    return true
end

function tramlineExtention.ShouldStart(component)
    return true
end

return tramlineExtention