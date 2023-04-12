return {
    -- 9.3 reaches meltdown temperature (2800) in 10 minutes.
    rate = 9.3; -- Rate at which the temperature increases with no cooling solution.
    coolingSolution = {

    };
    warningTemperature = 1000; -- You have about 193 seconds till meltdown with no cooling solution
    criticalTemperature = 2400; -- You have about 43 seconds till meltdown with no cooling solution
    meltdownTemperature = 2800;
}