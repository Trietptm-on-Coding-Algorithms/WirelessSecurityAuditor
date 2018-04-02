# WirelessSecurityAuditor

Uses the network hardware and tools mentioned below to output the SSID (name) and BSSID (hardware address) of every local wireless access point, the MAC (hardware address) and network card vendor for every local wireless device, and show which devices are connected to which wireless access points.

# Tools and Credit:
- This tool integrates Jeff Bryner's script (name shortened to "APCAP.py"): https://github.com/jeffbryner/kinectasploitv2/blob/master/blenderhelper/scripts/APNameFromPcap.py
 - This tool integrates the MACvendors.com API: https://macvendors.com/api
 - This tool integrates the Aircrack-ng Suite:https://macvendors.com/api

# Prerequisites:
- An atheros network card, peferably AR9271 based
- An OS with AR9271 drivers and the Aircrack-ng suite (Kali or ParrotSec should work)
- A wired or virtual wired network connection on the machine this tool is running on, as wlan0 must be populated by the Atheros network card

# Installation
1. Install git ("sudo apt-get install git" for debian based systems)
2. Download the repository by running "git clone https://github.com/BadAtScripting/WirelessSecurityAuditor.git'
3. Navigate to the folder with "cd WirelessSecurityAuditor"

# Use
1. Connect the Atheros network card to your machine. Make sure it's properly connected using wlan0 by running "iwconfig"
2. Run the auditor using "bash WirelessAuditor.sh". The output will be directed to the terminal unless it is piped to a file with "> [output file name]"
