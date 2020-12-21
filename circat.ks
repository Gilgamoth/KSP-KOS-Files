// Create Circular Orbit at
// Written by Gilgamoth (https://github.com/Gilgamoth) (c)2020
// Protected under GNU GPL 3.0 https://github.com/Gilgamoth/KSP-KOS-Files/blob/master/LICENSE
// Based on code by Mike Aben (https://www.youtube.com/c/MikeAben/ - https://github.com/MikeAben64/kOS-Scripts)

PARAMETER circat.

IF circat = "per" {
    PRINT "Creating Circlization Burn at Periapsis".
    SET futureVelocity to SQRT(VELOCITY:ORBIT:MAG^2-2*BODY:MU*(1/(BODY:RADIUS+ALTITUDE) - 1/(BODY:RADIUS+ORBIT:PERIAPSIS))).
    SET circVelocity to SQRT(BODY:MU/(ORBIT:PERIAPSIS+BODY:RADIUS)).
    SET newNode to NODE(TIME:SECONDS+ETA:PERIAPSIS, 0, 0, circVelocity-futureVelocity).
    ADD newNode.
} ELSE IF circat = "apo" {
    PRINT "Creating Circlization Burn at Apoapsis".
    SET futureVelocity to SQRT(VELOCITY:ORBIT:MAG^2-2*BODY:MU*(1/(BODY:RADIUS+ALTITUDE) - 1/(BODY:RADIUS+ORBIT:APOAPSIS))).
    SET circVelocity to SQRT(BODY:MU/(ORBIT:APOAPSIS+BODY:RADIUS)).
    SET newNode to NODE(TIME:SECONDS+ETA:APOAPSIS, 0, 0, circVelocity-futureVelocity).
    ADD newNode.
} ELSE {
    PRINT "Usage: circat [per/apo]".
    PRINT "per: Periapsys".
    PRINT "apo: Apoapsis".
    PRINT " ".
}
