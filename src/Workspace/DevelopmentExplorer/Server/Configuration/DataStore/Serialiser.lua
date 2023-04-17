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
    Serialise = function(objType, value)
        return {serialiseInstructions.serialise[objType](value), objType}
    end,
    Deserialise = function(objType, value)
        return serialiseInstructions.deserialise[objType](value)
    end
}