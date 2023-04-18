return {
    rate = 1, -- cooldown per step in seconds
    rateOfTemp = 2.556, -- rate of temp that increases per step.

    warningTemp = 1000,
    criticalTemp = 1600,
    meltdownTemp = 2300,

    powerTemp = 130, -- Temperature of primary water
    --[[
        Primary Sodium Coolers (PUMP)
        // Cools down the reactors and carries the heat to the water that turns the turbines.

        Physics:
        If primary water cooler (PUMP) is off:
            Primary Sodium Coolers gets heat saturated rapidly.
        If primary water cooler (PUMP) is semi on:
            Primary Sodium Coolers gets heat saturated slowly.
        if primary water cooler(PUMP) is on:
            Primary Sodium Coolers maintains a stable temperature gradient at powerTemp.
        if primary water cooler (PUMP) is turbo:
            Primary Sodium Coolers decreases in temperature.
            powerTemp decreases.
    ]]--
    primaryCoolers = {
        coolers = {
            {
                state = false, -- Default state on reactor start up.
    
            }
        }
    }
    --[[
        Primary Sodium Coolers (PUMP)
        // Cools down the reactors and carries the heat to the water that turns the turbines.

        Physics:
        If primary water cooler (PUMP) is off:
            Primary Sodium Coolers gets heat saturated rapidly.
        If primary water cooler (PUMP) is semi on:
            Primary Sodium Coolers gets heat saturated slowly.
        if primary water cooler(PUMP) is on:
            Primary Sodium Coolers maintains a stable temperature gradient at powerTemp.
        if primary water cooler (PUMP) is turbo:
            Primary Sodium Coolers decreases in temperature.
            powerTemp decreases.
    ]]--
}