#!/bin/bash
#
# dieses Skript kann man beliebig oft ausführen

# Anzahl der Sicherungen die aufgehoben werden sollen
KEEP=10
DATE=$(date +%Y%m%d_%H%M)
BACKUPPATH=/var/lib/mysql/backups
BACKUPS=`find $BACKUPPATH -name "mysqldump-*.gz" | wc -l | sed 's/\ //g'`

while [ $BACKUPS -ge $KEEP ]
do
  ls -tr1 $BACKUPPATH/mysqldump-*.gz | head -n 1 | xargs rm -f 
  BACKUPS=`expr $BACKUPS - 1` 
done

rm -f $BACKUPPATH/.mysqldump-${DATE}.gz_INPROGRESS

/usr/bin/mysqldump -u root -pf52c90f4 --all-databases | gzip -c -9 > $BACKUPPATH/.mysqldump-${DATE}.gz_INPROGRESS

mv -f $BACKUPPATH/.mysqldump-${DATE}.gz_INPROGRESS $BACKUPPATH/mysqldump-${DATE}.gz

exit 0
