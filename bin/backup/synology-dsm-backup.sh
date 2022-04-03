#!/bin/sh
# create DSM backup
# https://www.bachmann-lan.de/synology-dsm-6-konfiguration-automatisch-per-cli-sichern/

/usr/syno/bin/synoconfbkp export --filepath=/volume1/backup/dsm/`hostname`_`date +%Y%m%d_%H%M%S`.dss

# delete backups older than 14 days
find /volume1/backup/dsm/ -name "`hostname`_*.dss" -mtime +14 -exec rm {} \;
