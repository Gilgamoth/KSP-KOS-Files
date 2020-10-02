// Launch At script : Waits for specific time before launching.

PARAMETER LaunchIncl.
PARAMETER OrbitAlt.
PARAMETER LaunchHour.
PARAMETER LaunchMin.

IF (LaunchIncl) {
    IF (LaunchHour > 0 AND LaunchMin > 0) {
        CLEARSCREEN.
        PRINT "Waiting to Launch at " + LaunchHour + ":" + LaunchMin.
        WAIT UNTIL ((TIME:HOUR = LaunchHour) AND (TIME:MINUTE = (LaunchMin-1)) AND (TIME:SECOND = 45)).
        PRINT "Launching to Orbit at " + OrbitAlt + "km".
        PRINT " ".
        runPath("0:launch",LaunchIncl,OrbitAlt).
    } else {
        PRINT "Please Specify Launch Time".
    }
} ELSE {
    PRINT "Usage: Launch-At [Inclination], [Orbital Altitude], [Launch Hour], [Launch Minute]".
}
