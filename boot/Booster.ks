IF (ALTITUDE < 1000) {
    CLEARSCREEN.
    PRINT "Copying Files to Booster".
    PRINT " ".
    copyPath("0:destage.ks","").
} else {
    PRINT "kOS Restarted".
}