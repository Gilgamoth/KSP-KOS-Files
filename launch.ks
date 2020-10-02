// Launch Script
// Based on code by Mike Aben (https://www.youtube.com/c/MikeAben/)

PARAMETER desiredInclination.
PARAMETER desiredApoapsis.

SET pitchStartingAlt to 250. // Start Pitching at - Altitude m
SET pitchStartingSpeed to 50. // Start Pitching at - Speed m/s
SET OptimalTWR to 1.7. // Optimal TWR Default Value
SET OptimalTWRL to 1.33. // Optimal TWR - Lower Atmosphere
SET OptimalTWRU to 0.9. // Optimal TWR - Upper Atmosphere
SET TWRUpperAlt to 25. // Optimal TWR - Upper Atmosphere Altitude km
SET deployAtAlt to 60. // Deployable Altitude km
SET oldThrust to 0.

//CLEARSCREEN.
SET LaunchTime to TIME.
PRINT "Running Launch Script at:".
PRINT "Year: " + TIME:YEAR +" Day: " + Time:day + " Time: " +TIME:HOUR+":"+TIME:MINUTE+":"+TIME:SECOND.
PRINT " ".
PRINT "Setting Heading to: " + (90-desiredInclination).
PRINT "Setting Apoapsis to: " + desiredApoapsis +",000m".

PRINT " ".
PRINT "Copying kOS Files to Probe".
copyPath("0:xman.ks","").
copyPath("0:circat.ks","").

IF (SAS) SAS OFF.
countdown().
pitchManuever().
SET oldThrust to AVAILABLETHRUST.
autoStage().
meco().
lockToPrograde().
autoDeploy().
WAIT UNTIL (SHIP:ALTITUDE > (desiredApoapsis-10)*1000).
RUNPATH("circat","apo").
RUNPATH("xMan").

PRINT "Launched at - Year: " + LaunchTime:YEAR +" Day: " + LaunchTime:day + " Time: " +LaunchTime:HOUR+":"+LaunchTime:MINUTE+":"+LaunchTime:SECOND.
PRINT "Dinished at - Year: " + TIME:YEAR +" Day: " + Time:day + " Time: " +TIME:HOUR+":"+TIME:MINUTE+":"+TIME:SECOND.
PRINT "Mission Time " + missionTime +"seconds".
PRINT " ".
UNLOCK THROTTLE.
UNLOCK STEERING.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
PRINT "Enabling SAS".
IF (NOT SAS) SAS ON.

FUNCTION myPitch {
	RETURN 900000 / (ALTITUDE + 10000).
	// RETURN (54021666.2 - ALTITUDE)/sqrt(2918700708000000-(ALTITUDE - 54021666.2)^2).
}

FUNCTION myRoll {
	RETURN 360 - myHeading.
}

FUNCTION myHeading {
	SET roughHeading to 90 - desiredInclination.
	IF (roughHeading < 0) {
		SET roughHeading to 360 + roughHeading.
	}
	SET triAng to abs(90 - roughHeading).
	SET dV to sqrt(6688800 - 928800*cos(triAng)).
	SET correction to arcsin(180*sin(triAng) /dV).
	IF (desiredInclination > 0) {
		SET correction to -1*correction.
	}
	RETURN roughHeading + correction.
}

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
	WAIT UNTIL ((SHIP:ALTITUDE > pitchStartingAlt) AND (SHIP:AIRSPEED > pitchStartingSpeed)).
	PRINT " ".
	PRINT "Starting pitching maneuver.".
	LOCK STEERING to HEADING(myHeading(), myPitch())+ R(0, 0, myRoll()).
}

FUNCTION lockToPrograde {
	PRINT "Locking to prograde.".
	LOCK STEERING to SRFPROGRADE + R(0, 0, myRoll()).
}

// Main Engine Cut-Off
FUNCTION meco { 
	LOCK THROTTLE to 0.
	PRINT " ".
	PRINT "Main Engine Cut-Off.".
}

FUNCTION autoStage {
	UNTIL (APOAPSIS > desiredApoapsis*1000) {
		IF (AVAILABLETHRUST < (oldThrust -10)) {
			PRINT " ".
			PRINT "Staging".
			STAGE.
			WAIT 1.
			SET oldThrust to AVAILABLETHRUST.
		}
		IF (SHIP:ALTITUDE < (TWRUpperAlt*1000)) {
			//PRINT "L: " + OptimalTWR + " " + OptimalTWRL.
			IF OptimalTWR > OptimalTWRL {
				SET OptimalTWR to OptimalTWRL.
				setTWR(OptimalTWR).
			}
		} ELSE {
			//PRINT "U: " + OptimalTWR + " " + OptimalTWRU.
			IF OptimalTWR > OptimalTWRU {
				SET OptimalTWR to OptimalTWRU.
				setTWR(OptimalTWR).
			}
		}
		//WAIT 2.
	}
}

FUNCTION autoDeploy {
	WAIT UNTIL (ALTITUDE > deployAtAlt*1000).
	SET fairing to false.
	LIST PARTS in partList.
	FOR part in partList {
		IF (part:NAME = "fairingSize1" OR part:NAME = "fairingSize2" OR part:NAME = "fairingSize3" OR part:NAME = "restock-fairing-base-0625" OR part:NAME = "restock-fairing-base-1875" OR part:NAME = "fairingSize1p5" OR part:NAME = "fairingSize4") {
			SET fairing to true.
			BREAK.
		}
	}
	IF fairing {
		PRINT " ".
		PRINT "Staging Faring (AG8)".
		WAIT 1.
		AG8 ON.
		WAIT 3.
	}
	PRINT " ".
	PRINT "Opening Outer Doors (AG9)".
	WAIT 1.
	AG9 ON.
	WAIT 3.
	PRINT " ".
	PRINT "Extending Deployable Equipment (AG10)".
	WAIT 1.
	AG10 ON.
	WAIT 3.
}

FUNCTION setTWR {
	PARAMETER twrTarget.

	PRINT " ".
	PRINT "Attempting to lock TWR to " + twrTarget.
	LOCK effectiveThrust TO SHIP:AVAILABLETHRUST * COS(FACING:PITCH).
	LOCK TWR TO effectiveThrust / (SHIP:MASS * CONSTANT:g0).
	LOCK THROTTLE TO CHOOSE 1 IF TWR = 0 ELSE twrTarget / TWR.
}