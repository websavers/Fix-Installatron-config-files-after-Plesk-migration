#!/bin/bash

# This can be run after you've moved backup files to a new server location.
# If you had to create a new location in Installatron (ex: location type), running
# this will tell Installatron where to find the backup files
# After running, you won't visually see the change in the backups list
# but downloading backups will work.

# IMPORTANT: You must manually find and set the location IDs below
# The easiest way to find these is to go to:
# Settings > Backup > Locations > click on the 'X apps' link
# The heading will be - Search: bkloc:XXXXXX
# The value after bkloc: is your location ID.

OLD_BACKUP_LOCATION=
NEW_BACKUP_LOCATION=

BACKUP_CFG_FILES=$(grep -l -m 1 $OLD_BACKUP_LOCATION /var/www/vhosts/*/.appdata/backups/*)
APP_CFG_FILES=$(grep -l -m 1 $OLD_BACKUP_LOCATION /var/www/vhosts/*/.appdata/current/*)
CFG_FILES="$BACKUP_CFG_FILES"$'\n'"$APP_CFG_FILES"

echo "Replacing backup locations for all backups and apps"
for cfg_file in $CFG_FILES
do
    sed -i "s/$OLD_BACKUP_LOCATION/$NEW_BACKUP_LOCATION/g" $cfg_file
done

echo "Running Installatron Cache Update"
DATE=$(date -I)
mv -f /var/installatron/data.db /var/installatron/data.db.bak$DATE
rm -f /var/installatron/data.db-*
/usr/local/installatron/installatron --repair --recache
/usr/local/installatron/installatron --send-update-report