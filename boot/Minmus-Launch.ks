IF (TIME:HOUR < 3) {
    SET LaunchHour TO 3.
    SET LaunchIncl TO -6.
} else {
    SET LaunchHour TO 0.
    SET LaunchIncl TO 6.
}

SET LaunchMin TO 10.
SET OrbitAlt TO 80.

runPath("0:launch-at",LaunchIncl,OrbitAlt,LaunchHour,LaunchMin).
