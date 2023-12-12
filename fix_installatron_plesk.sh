#!/bin/bash

#e.g.: owner=domain70 becomes owner=domain11

echo "Fixing Installatron Domain Owner IDs"
for app_config_file in $(ls /var/www/vhosts/*/.appdata/current/*); do
	domain=$(awk -F "=" '/url-domain/ {print $2}' $app_config_file)
	ID=$(plesk db -Ne"SELECT id FROM domains WHERE name LIKE '$domain'")
	echo "Updating domain $domain to new ID $ID in Installatron config file"
	sed -i "s/owner=domain[0-9]\+/owner=domain$ID/" $app_config_file
done

echo "Running Installatron Cache Update"
DATE=$(date -I)
mv -f /var/installatron/data.db /var/installatron/data.db.bak$DATE
rm -f /var/installatron/data.db-*
/usr/local/installatron/installatron --repair --recache
/usr/local/installatron/installatron --send-update-report