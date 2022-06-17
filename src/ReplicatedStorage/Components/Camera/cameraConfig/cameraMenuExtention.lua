local extention = {}

function extention.ShouldConstruct(component)
    local attachment1: Attachment = component.Instance:FindFirstChild("Attachment1")
    local attachment2: Attachment = component.Instance:FindFirstChild("Attachment2")

    if not attachment1 and not attachment2 then
        return false
    elseif not attachment1:IsA("Attachment") and not attachment2:IsA("Attachment") then
        return false
    end

    return true
end

return extention