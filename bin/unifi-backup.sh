#!/bin/bash

# source: https://dl.ubnt.com/unifi/5.12.66/unifi_sh_api

username=ubnt
password=ubnt
baseurl=https://URL:8443
site=default
cookie=$(mktemp)

KEEP=14
DATE=$(date +%Y%m%d_%H%M%S)
BACKUPPATH=~/unifiBackup
BACKUPS=`find $BACKUPPATH -name "*.unf" | wc -l | sed 's/\ //g'`

# -------------------------------------------

curl_cmd="curl --tlsv1 --silent --cookie ${cookie} --cookie-jar ${cookie} --insecure "

unifi_requires() {
    if [ -z "$username" -o -z "$password" -o -z "$baseurl" -o -z "$site" ] ; then
        echo "Error! please define required env vars before including unifi_sh. E.g. "
        echo ""
        echo "export username=ubnt"
        echo "export password=ubnt"
        echo "export baseurl=https://localhost:8443"
        echo "export site=default"
        echo ""
        return
    fi
}

unifi_login() {
    # authenticate against unifi controller
    ${curl_cmd} --data "{\"username\":\"$username\", \"password\":\"$password\"}" $baseurl/api/login
}

unifi_logout() {
    # logout
    ${curl_cmd} $baseurl/logout
}

unifi_backup() {
    if [ "$1" = "" ]; then
        #output=`date +%Y%m%d_%H%M%S`.unf
        output=$BACKUPPATH/$DATE.unf
    else
        output=$1
    fi

    # ask controller to do a backup, response contains the path to the backup file
    path=`$curl_cmd --data "{\"cmd\":\"backup\"}" $baseurl/api/s/$site/cmd/backup | sed -n 's/.*\(\/dl.*unf\).*/\1/p'`

    # download the backup to the destinated output file
    $curl_cmd $baseurl$path -o $output
}

unifi_requires

unifi_login

unifi_backup

# delete outdated backups
while [ $BACKUPS -ge $KEEP ]
do
  ls -tr1 $BACKUPPATH/*.unf | head -n 1 | xargs rm -f 
  BACKUPS=`expr $BACKUPS - 1` 
done

unifi_logout

# EOF
