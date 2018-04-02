#!/bin/bash

#Arrays

export WIFI_SSID_LIST=()
export WIFI_BSSID_LIST=()

#zigbee () {
#}

wifi () {
	#Setup the wifi devices
	rm -rf *wifidump*
	rm -rf acmac.txt
	rm -rf interfacedetect.txt
	rm -rf unavendor.txt
	iwconfig > /dev/null 2>&1

	#Make sure the device is plugged in
	airmon-ng start wlan0 > interfacedetect.txt
	if ! (grep "wlan0mon" interfacedetect.txt); then
		rm -rf interfacedetect.txt
		echo " "
		echo "Wireless Interface not detected"
	else
		rm -rf interfacedetect.txt
		#Note: Change to 3m for normal operation, 12s for testing
		timeout 3m airodump-ng wlan0mon -o pcap,csv -w wifidump > /dev/null 2>&1 & timeout 3m bash infinite.sh

		clear

		#Number of Unconnected Wifi Devices
		WIFI_NUM_CONNECTED=0
		export WIFI_NUM_UNCONNECTED=$(cat wifidump-01.csv | grep 'not associated' | cut -c1-17 | wc -l)

		#List of WAP's
		mapfile -t WIFI_SSID_LIST < <(python APCAP.py -f wifidump-01.cap | cut -c19-51 | tr -d '<|\>|\`|\!|\@|\#|\$|\%|\^|\&|\*|\(\|)|\_|\+|\?|\:|\;|\{|\}|\[|\]|\/|\.|\	|\ ' | tr -d / | tr -d -)
		mapfile -t WIFI_BSSID_LIST < <(python APCAP.py -f wifidump-01.cap | cut -c1-17 | tr '[:lower:]' '[:upper:]')
		export WIFI_SSID_LIST
		export WIFI_BSSID_LIST
		
		#List of MAC's per WAP
		
		for i in "${WIFI_BSSID_LIST[@]}"
		do
			n=$(cat wifidump-01.csv | egrep $i | grep -v 'OPN\|WEP\|WPA2\|WPA' | cut -c1-17| wc -l)
			export WIFI_NUM_CONNECTED=$(($WIFI_NUM_CONNECTED + $n))
		done
		wap_info () {
			iterations=0
			for i in "${WIFI_BSSID_LIST[@]}"
			do
				cat wifidump-01.csv | egrep $i | grep -v 'OPN\|WEP\|WPA2\|WPA' | cut -c1-17 | tr ':' '-' | dd status=none of=acmac.txt 
				while read maclist
				do
					echo "$(curl --silent 'https://api.macvendors.com/'+$maclist)" && sleep 5s
				done < acmac.txt > unavendor.txt
				rm -rf acmac.txt
				mapfile -t macvend < <(cat unavendor.txt)
				rm -rf unavendor.txt &&
				mapfile -t mac < <(cat wifidump-01.csv | egrep $i | grep -v 'OPN\|WEP\|WPA2\|WPA' | cut -c1-17)
				printf "%s\n" " "
				printf '%s\n' "WAP: ${WIFI_SSID_LIST[iterations]}"
				printf '%s\n' "BSSID: ${WIFI_BSSID_LIST[iterations]}"
				printf '%s\n' "Connected Devices:"
				paste -d' ' <(printf "%-18.18s\n" "${mac[@]}") <(printf "%s\n" "${macvend[@]}")
				iterations=$[iterations+1]
			done
		}
		rm -rf wifidump-01.cap
	fi
}

#zigbee
wifi

#Time to display output
echo " "
echo " "
echo "~~~~~~Summary~~~~~~"
echo " "
echo "Wifi:"
echo "* WAP SSID's and BSSID's"
echo " (SSID's are printed alphanumerically only)"
echo " "
paste <(printf '%s\n' "${WIFI_SSID_LIST[@]}") <(printf '%s\n' "${WIFI_BSSID_LIST[@]}")
echo " "
echo "* Total Connected Devices: " $WIFI_NUM_CONNECTED
echo "* Total Unconnected Devices: " $WIFI_NUM_UNCONNECTED
echo " "
echo " "
echo "Zigbee:"
echo "No Zigbee information available at this time."
echo " "
echo "~~~~~~Wifi Information~~~~~~"
echo " "
echo "* WAP's and Connected Devices"
echo " "
wap_info
echo " "
echo " "
echo "~~~~~~Zigbee Information~~~~~~"
echo " "
echo "No Zigbee information available at this time."
echo " "
echo "~~~~~~Wireless Audit Completed~~~~~~"
echo " "
rm -rf wifidump-01.csv
