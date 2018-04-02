# WirelessSecurityAuditor

Description: Uses the network hardware and tools mentioned below to output the SSID (name) and BSSID (hardware address) of every local wireless access point, the MAC (hardware address) and network card vendor for every local wireless device, and show which devices are connected to which wireless access points.

# Tools and Credit:
- This tool integrates Jeff Bryner's script: https://github.com/jeffbryner/kinectasploitv2/blob/master/blenderhelper/scripts/APNameFromPcap.py
 - This tool integrates the MACvendors.com API: https://macvendors.com/api
 - This tool integrates the Aircrack-ng Suite:https://macvendors.com/api

# Prerequisites:
- An atheros network card, peferably AR9271 based
- An OS with AR9271 drivers and the Aircrack-ng suite (Kali or ParrotSec should work)
- A wired or virtual wired network connection on the machine this tool is running on, as wlan0 must be populated by the Atheros network card

# Installation
1. Install git ("sudo apt-get install git" for debian based systems)
2. Git 

# Use
1. Connect
