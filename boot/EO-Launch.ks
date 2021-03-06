CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
SET TERMINAL:WIDTH TO 60.
SET TERMINAL:HEIGHT TO 45.
SET TERMINAL:CHARHEIGHT TO 10.

PARAMETER LaunchIncl is 90.
PARAMETER OrbitAlt is 80.

IF (SHIP:STATUS = "PRELAUNCH") {
    CLEARSCREEN.
    PRINT "Launching an Equatorial Orbit at " + OrbitAlt + "km".
    runPath("0:launch",LaunchIncl,OrbitAlt).
} else {
    PRINT "kOS Restarted".
}