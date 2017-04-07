#!/bin/sh
#
TZ=JST-9
export TZ
#
AWS_ACCESS_KEY_ID='AKIAIG7YQK3QOMRNKSOQ'
AWS_SECRET_ACCESS_KEY='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'
AWS_CALLING_FORMAT='SUBDOMAIN'  
export AWS_SECRET_ACCESS_KEY AWS_ACCESS_KEY_ID AWS_CALLING_FORMAT
#
filebase="dbbackup_$HOSTNAME-`date +%Y%m%d%H%M`"


echo '=== Begin BACKUP ==='

echo '-- Export Database --'
mysqldump eccube -ueccube -peccubepasswd -heccube.cvoc7quqhseh.ap-northeast-1.rds.amazonaws.com >/tmp/dbbackup.dmp

echo '-- Exec Backup --'
(cd /tmp; tar cjpf /var/backup/db/${filebase}.tar.bz2 dbbackup.*)

echo '-- Sync --'
/usr/local/bin/s3sync.rb --progress --delete -r /var/backup/db data.aiit-cdp-01.xyz:

echo '-- Purge --'
find /var/backup/db -mtime +8 -print | xargs rm -f

echo '=== End BACKUP ==='


