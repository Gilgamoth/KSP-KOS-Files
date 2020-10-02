PARAMETER LaunchIncl is 90.
PARAMETER OrbitAlt is 80.

IF (ALTITUDE < 1000) {
    CLEARSCREEN.
    PRINT "Launching an Polar Orbit at " + OrbitAlt + "km".
    runPath("0:launch",LaunchIncl,OrbitAlt).
} else {
    PRINT "kOS Restarted".
}