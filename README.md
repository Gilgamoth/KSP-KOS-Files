# KSP-KOS-Files
These files are for Kerbal Operating System (KOS) mod for Kerbal Space Program. KOS is available at https://github.com/KSP-KOS/KOS/releases

Some files marked (*MA*) are based on the work of Mike Aben in his YouTube Channel - https://www.youtube.com/c/MikeAben/

Scripts:
* boot
  * BlackBox.ks - Automatically runs the Flight Recorder script
  * Booster.ks - Copies the destage script to the local storage (designed for reusable boosters).
  * EO-Launch.ks - Equatorial Orbit Launch, calls Launch.ks at 0 degrees inclination and 80Km Orbit
  * Minmus-Launch.ks - Minmus Orbit Launch, calls Launch-At.ks at +/-6 degrees inclination and 80Km Orbit based on time of launch
  * PO-Launch.ks - Polar Orbit Launch, calls Launch.ks at 90 degrees inclination and 80Km Orbit
  * Terminal.KS - Just opens the KOS terminal

* Ballistic.ks - Simple Ballistic launch script, Launches as a specified heading and inclination.
* CircAt.ks - Create Circular Orbit at either Apoapsis or Periapsis (*MA*)
* Destage.ks - Destaging script for reusable boosters (needs a kOS computer in both stage and probe)
* FlightRecorder.ks - Simple Flight Recorder script that logs muliple variables to a file for later analysis
* KeoCalc.ks - Calculates the burn Longitude to get into Equatorial Keostationary Orbit above a specific Longitude.
* Launch.ks - Launches a ship at a specified heading to a specified orbit (*MA*)
* Launch-At.ks - Designed to launch at a specified time by calling Launch.ks
* xman.ks - eXecute Maneuver Node (*MA*)
