// Destaging Script

CLEARSCREEN.
PRINT "Running Destaging Script".
PRINT " ".

PRINT "Disabling SAS".
PRINT " ".
SAS OFF.

PRINT "Locking to Retrograde and waiting for alignment.".
PRINT "T -45".
LOCK STEERING to SRFRETROGRADE + R(0, 0, 0).
//wait until vang(SRFRETROGRADE + R(0, 0, 0), ship:facing:vector) < 0.25.
WAIT 15.
PRINT "T -30".
WAIT 15.
PRINT "T -15".
WAIT 5.
    FROM {local x is 10.} UNTIL x = 0 STEP {set x to x-1.} DO {
    PRINT "T -" + x.
    WAIT 1.
}
PRINT "IGNITION!".

UNTIL (PERIAPSIS < (body:atm:height/2)) {
    LOCK THROTTLE to 0.5.
}
PRINT "Booster Stopped".
PRINT " ".
LOCK THROTTLE to 0.

PRINT " ".
PRINT "Retracting Deployable Equipment (AG10)".
WAIT 1.
AG10 OFF.
WAIT 5.

PRINT " ".
PRINT "Closing Outer Doors (AG9)".
WAIT 1.
AG9 OFF.
WAIT 5.

PRINT "Staging Parachutes".
STAGE.

WAIT UNTIL (ALTITUDE < 50000).
LOCK THROTTLE to 1.

WAIT UNTIL (ALTITUDE < 10000).
LOCK THROTTLE to 0.
