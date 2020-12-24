// Black Box Flight Recorder
// Written by Gilgamoth (https://github.com/Gilgamoth) (c)2020
// Protected under GNU GPL 3.0 https://github.com/Gilgamoth/KSP-KOS-Files/blob/master/LICENSE

CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
SET TERMINAL:WIDTH TO 80.
SET TERMINAL:HEIGHT TO 60.
SET TERMINAL:CHARHEIGHT TO 10.

SET startingAlt TO SHIP:ALTITUDE. //This is the height of the Vessel
SET LogFile TO "0:/logs/FlightLog-"+SHIP:NAME+"-Y"+TIME:YEAR+"-D"+TIME:DAY+"-"+TIME:HOUR+"-"+TIME:MINUTE+".csv".

PRINT "Logging Data to "+LogFile.
LOG "MISSIONTIME,ALTITUDE,APOAPSIS,ETA:APOAPSIS" TO LogFile.
PRINT "Waiting For Launch".

WAIT UNTIL (SHIP:ALTITUDE > startingAlt+1). // Wait until Altitude increases (i.e. Launch!)

UNTIL FALSE {
    PRINT "T: "+MISSIONTIME+" A:"+ALTITUDE+" AP:"+APOAPSIS+" EA:"+ETA:APOAPSIS.
    LOG round(MISSIONTIME,2)+","+round(ALTITUDE,2)+","+round(APOAPSIS,2)+","+round(ETA:APOAPSIS,2) TO LogFile.
    WAIT 5.
}

PRINT "Program Complete".
