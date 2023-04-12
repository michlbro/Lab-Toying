local sound = {}

function sound:BindSoundEvent(eventName, soundId, soundFunction)
    if self.soundEvents[eventName] then
        self.soundEvents[eventName]:Destroy()
    end
    local instance = Instance.new("Sound")
    instance.Loaded = true
    instance.SoundId = soundId
    if soundFunction then
        soundFunction(instance)
    end
    instance:Play()
end

function sound:UnBindSoundEvent(eventName, soundFunction)
    if not self.soundEvent[eventName] then
        return
    end
    soundFunction(self.soundEvent[eventName])
    self.soundEvent[eventName]:Destroy()
end

local function new()
    local self = {}
    self.soundEvents = {}

    return setmetatable(self, {__index = sound})
end

return setmetatable({new = new}, {})