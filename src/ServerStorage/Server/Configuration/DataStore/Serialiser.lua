local serialiseInstructions = {
    serialise = {
        number = function(value)
            return value
        end,
        string = function(value)
            return value
        end, 
    },
    deserialise = {
        number = function(value)
            return value
        end,
        string = function(value)
            return value
        end, 
    }
}

return {
    serialise = function(objType, value)
        return serialiseInstructions.serialise[objType](value)
    end,
    deserialise = function(objType, value)
        return serialiseInstructions.deserialise[objType](value)
    end
}