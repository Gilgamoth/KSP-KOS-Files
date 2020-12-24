// Ballistic Ascend Script
// Written by Gilgamoth (https://github.com/Gilgamoth) (c)2020
// Protected under GNU GPL 3.0 https://github.com/Gilgamoth/KSP-KOS-Files/blob/master/LICENSE
// Based on code by Mike Aben (https://www.youtube.com/c/MikeAben/ - https://github.com/MikeAben64/kOS-Scripts)

PARAMETER desiredInclination is 90.
PARAMETER desiredPitch is 87.

SET pitchStartingAlt to 2500.
SET oldThrust to 0.

//CLEARSCREEN.
SET LaunchTime to TIME.
PRINT "Running Ballistic Script at:".
PRINT "Year: " + TIME:YEAR +" Day: " + Time:day + " Time: " +TIME:HOUR+":"+TIME:MINUTE+":"+TIME:SECOND.
PRINT " ".
PRINT "Setting Heading to: " + desiredInclination.
PRINT "Setting Pitch to: " + desiredPitch.
SAS OFF.
countdown().
pitchManuever().
SET oldThrust to AVAILABLETHRUST.
autoStage().


PRINT "Launched at - Year: " + LaunchTime:YEAR +" Day: " + LaunchTime:day + " Time: " +LaunchTime:HOUR+":"+LaunchTime:MINUTE+":"+LaunchTime:SECOND.
PRINT "Dinished at - Year: " + TIME:YEAR +" Day: " + Time:day + " Time: " +TIME:HOUR+":"+TIME:MINUTE+":"+TIME:SECOND.
PRINT "Mission Time " + floor(missionTime) +" seconds".
PRINT " ".
UNLOCK THROTTLE.
UNLOCK STEERING.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
PRINT "Enabling SAS".
SAS ON.

FUNCTION countdown {
	PRINT " ".
	PRINT "Countdown initiated:".
	FROM {local x is 10.} UNTIL x = 2 STEP {set x to x-1.} DO {
  		PRINT "T -" + x.
		WAIT 1.
	}
	PRINT "T -2 Locking attutide control and throttle".
	LOCK STEERING to UP + R(0, 0, 180).
	LOCK THROTTLE to 1.
	WAIT 1.
	PRINT "T -1".
	WAIT 1.
	PRINT "LAUNCH!".
	STAGE.
}

FUNCTION pitchManuever {
	WAIT UNTIL (ALTITUDE > pitchStartingAlt).
	PRINT " ".
	PRINT "Starting pitching maneuver.".
	LOCK STEERING to HEADING(desiredInclination,desiredPitch).
}

FUNCTION autoStage {
	UNTIL (ALTITUDE < 1500) {
		IF (AVAILABLETHRUST < (oldThrust -10)) {
			PRINT " ".
			PRINT "Staging".
			STAGE.
			WAIT 1.
			SET oldThrust to AVAILABLETHRUST.
		}
	}
}

