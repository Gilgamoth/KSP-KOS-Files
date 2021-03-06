// XMAN - eXecute Maneuver
// Written by Gilgamoth (https://github.com/Gilgamoth) (c)2020
// Protected under GNU GPL 3.0 https://github.com/Gilgamoth/KSP-KOS-Files/blob/master/LICENSE
// Based on code by Mike Aben (https://www.youtube.com/c/MikeAben/ - https://github.com/MikeAben64/kOS-Scripts)

GLOBAL mNode to 1.

PRINT " ".
PRINT "Running XMAN - eXecute MANeuver Script".
xMan().

FUNCTION xMan {
	IF HASNODE {
		SAS OFF.
		SET MinBurnTime TO 5.
		SET startReduceTime TO 2.
		SET mNode to NEXTNODE.
		PRINT "Node in: " + round(mNode:eta) + " seconds, DeltaV: " + round(mNode:deltav:mag).
		If (burnTime(mNode)<MinBurnTime) {
			PRINT "WARNING: Burn Time too short!".
			LIST ENGINES IN EngineList.
			UNTIL (burnTime(mNode) > MinBurnTime) {
				FOR CurrEngine IN EngineList {
					IF (CurrEngine:STAGE = STAGE:NUMBER) {
						SET CurrEngine:ThrustLimit TO CurrEngine:ThrustLimit -1.
						SET TLimit to CurrEngine:ThrustLimit.
					}
				}
			}
			PRINT "Thrust Limit lowered to "+TLimit+"%".
		}
		SET startTime to calculateStartTime(mNode, startReduceTime).
		SET startVector to mNode:BURNVECTOR.
		lockSteering(mNode).
		startBurn(startTime).
		reduceThrottle(mNode, startReduceTime).
		endBurn(mNode, startVector).
		//SET MainEngine:Thrustlimit TO 100.
		SAS ON.
	} ELSE {
		PRINT " ".
		PRINT "No node in flight path.".
		PRINT " ".
	}
}

FUNCTION calculateStartTime {
	PARAMETER mNode.
	PARAMETER startReduceTime.
	RETURN TIME:SECONDS + mNode:ETA - burnTime(mNode)/2 - startReduceTime/2.
}

FUNCTION lockSteering {
	PARAMETER mNode.
	LOCK STEERING to mNode:BURNVECTOR.
	PRINT " ".
	PRINT "Locking attitude to burn vector.".
}

FUNCTION maneuverComplete {
	PARAMETER mNode.
	PARAMETER startVector.
	RETURN VANG(startVector, mNode:BURNVECTOR) > 5.
}

FUNCTION burnTime {
	PARAMETER mNode.
	SET delV to mNode:BURNVECTOR:MAG.
	
	IF (vISP() < 0) {
		PRINT " ".
		PRINT "NO ACTIVE ENGINES!".
		WAIT UNTIL (vISP() > 0).
	}
	SET finalMass to MASS / (CONSTANT:E^(delV/(vISP()*CONSTANT:g0))).
	SET startAcc to AVAILABLETHRUST / MASS.
	SET finalAcc to AVAILABLETHRUST / finalMass.
	RETURN 2*delV / (startAcc+finalAcc).
}

FUNCTION vISP {
	LIST ENGINES in engineList.
	SET sumOne to 0.
	SET sumTwo to 0.
	FOR eng in engineList {
		IF eng:IGNITION {
			SET sumOne to sumOne + eng:AVAILABLETHRUST.
			SET sumTwo to sumTwo + eng:AVAILABLETHRUST/eng:ISP.
		}
	}
	IF (sumTwo > 0) {
		RETURN sumOne / sumTwo.
	} ELSE {
		RETURN -1.
	}
}

FUNCTION reduceThrottle {
	PARAMETER mNode.
	PARAMETER startReduceTime.
	WAIT UNTIL burnTime(mNode) < startReduceTime.
	PRINT " ".
	PRINT "Reducing throttle".
	SET reduceTime to startReduceTime*2/0.9.
	SET startTime to TIME:SECONDS.
	SET stopTime to TIME:SECONDS + reduceTime.
	SET scale to 0.1^(1/reduceTime).
	LOCK THROTTLE to scale^(TIME:SECONDS - startTime).
	WAIT UNTIL TIME:SECONDS > stopTime.
	LOCK THROTTLE to 0.1.
}

FUNCTION startBurn {
	PARAMETER startTime.
	WAIT UNTIL TIME:SECONDS > (startTime-90).
	IF kuniverse:timewarp:warp > 0 {
		PRINT "Cancelling Time Warp with 90s to go".
		kuniverse:timewarp:cancelwarp().
	}
	WAIT UNTIL TIME:SECONDS > (startTime-10).
	PRINT "Starting burn in".
		FROM {local x is 10.} UNTIL x = 0 STEP {set x to x-1.} DO {
  		PRINT "T -" + x.
		WAIT 1.
	}
	PRINT "IGNITION!".
	LOCK THROTTLE to 1.
}

FUNCTION endBurn {
	PARAMETER mNode.
	PARAMETER startVector.
	WAIT UNTIL maneuverComplete(mNode, startVector).
	PRINT " ".
	PRINT "Burn Complete.".
	PRINT " ".
	LOCK THROTTLE to 0.
	UNLOCK STEERING.
	REMOVE mNode.
}
