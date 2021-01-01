// Black Box Flight Recorder
// Written by Gilgamoth (https://github.com/Gilgamoth) (c)2020
// Protected under GNU GPL 3.0 https://github.com/Gilgamoth/KSP-KOS-Files/blob/master/LICENSE

CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
SET TERMINAL:WIDTH TO 120.
SET TERMINAL:HEIGHT TO 60.
SET TERMINAL:CHARHEIGHT TO 10.

SET startingAlt TO SHIP:ALTITUDE. //This is the height of the Vessel
SET LogFile TO "0:/logs/FlightLog-"+SHIP:NAME+"-Y"+TIME:YEAR+"-D"+TIME:DAY+"-"+TIME:HOUR+"-"+TIME:MINUTE+".csv".

PRINT "Logging Data to "+LogFile.
LOG "MISSIONTIME,ALTITUDE,APOAPSIS,ETA:APOAPSIS,PERIAPSIS,ETA:PERIAPSIS,VERTICALSPEED,GROUNDSPEED,AIRSPEED,ORBITSPEED,SURFACESPEED" TO LogFile.
PRINT "Waiting For Launch".

WAIT UNTIL (SHIP:ALTITUDE > startingAlt+1). // Wait until Altitude increases (i.e. Launch!)

UNTIL FALSE {
    PRINT "T: "+floor(MISSIONTIME,2)+" A:"+floor(ALTITUDE,2)+" AP:"+floor(APOAPSIS,2)+" EA:"+floor(ETA:APOAPSIS,2)+" PE:"+floor(PERIAPSIS,2)+" EP:"+floor(ETA:PERIAPSIS,2)+" VS:"+floor(SHIP:VERTICALSPEED,2)+" GS:"+floor(SHIP:GROUNDSPEED,2)+" AS:"+floor(SHIP:AIRSPEED,2)+" OS:"+floor(SHIP:VELOCITY:ORBIT:MAG,2)+" SS:"+floor(SHIP:VELOCITY:SURFACE:MAG,2).
    LOG floor(MISSIONTIME,2)+","+floor(ALTITUDE,2)+","+floor(APOAPSIS,2)+","+floor(ETA:APOAPSIS,2)+","+floor(PERIAPSIS,2)+","+floor(ETA:PERIAPSIS,2)+","+floor(SHIP:VERTICALSPEED,2)+","+floor(SHIP:GROUNDSPEED,2)+","+floor(SHIP:AIRSPEED,2)+","+floor(SHIP:VELOCITY:ORBIT:MAG,2)+","+floor(SHIP:VELOCITY:SURFACE:MAG,2) TO LogFile.
    WAIT 5.
}

PRINT "Program Complete".
