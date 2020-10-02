// Calculate Burn Longitude for Keostationary Orbit.
// Usage: Start the script with the location of where you want to end up in Longitude eg, keostationary(0,57,21,e)
// 

parameter KSODegree.
parameter KSOMinute.
parameter KSOSecond.
parameter KSODirection.

set BurnTime to 83.

set KSOLongtitude to KSODegree + (KSOMinute/60) + (KSOSecond/3600).
if KSODirection="W" set KSOLongtitude to KSOLongtitude*-1.
print " ".
print "Keostationary Orbit (KSO) set for "+KSODegree+"° "+KSOMinute+"' "+KSOSecond+CHAR(34)+" "+KSODirection.
print "("+ROUND(KSOLongtitude,8)+" decimal)".
set KSOOpposite to KSOLongtitude+180.
set KSOLaunch to KSOOpposite+BurnTime.
if (KSOLaunch > 180) {
    set KSOLaunch to (180 - (KSOLaunch - 180)).
    set KSOLDirection to "W".
} else {
    SET KSOLDirection to "E".
}
set KSOLDegree to FLOOR(KSOLaunch,0).
set KSOLMinute to FLOOR((KSOLaunch-KSOLDegree)*60,0).
set KSOLSecond to ROUND((((KSOLaunch-KSOLDegree)*60)-KSOLMinute)*60,2).
IF (KSOLDirection = "W") set KSOLaunch to KSOLaunch*-1.
print " ".
print "KSO burn point set for "+KSOLDegree+"° "+KSOLMinute+"' "+KSOLSecond+CHAR(34)+" "+KSOLDirection.
print "("+ROUND(KSOLaunch,8)+" decimal)".
print " ".
