#!/bin/bash
CMD_GPG=/usr/bin/gpg
GPG_PASSPHRASE_FILE_PRD=/backup/.passphrase
host=`hostname`

# Set the backup date
BACKUP_DATE=`date +%Y-%m-%d`
Current_Date_time=`date +%Y-%m-%d-%H.%M.%S`
BACKUP_DIR=/backup/mysql_backups
BACKUP_HISTORY=5

# Dump the database
mysqldump -u mbackup -pLx4Dshr7BnyRo3K lending_saas_prod --routines --triggers --events | gzip > $BACKUP_DIR/lending_saas_prod.$Current_Date_time.sql.gz
mysqldump -u mbackup -pLx4Dshr7BnyRo3K  notification_setting --routines --triggers --events | gzip > $BACKUP_DIR/notification_setting.$Current_Date_time.sql.gz

$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c $BACKUP_DIR/lending_saas_prod.$Current_Date_time.sql.gz

$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c $BACKUP_DIR/notification_setting.$Current_Date_time.sql.gz

/usr/local/bin/aws s3 cp $BACKUP_DIR/lending_saas_prod.$Current_Date_time.sql.gz.gpg s3://backupprd/$host/data/mysql/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309dredd3601d9c

/usr/local/bin/aws s3 cp $BACKUP_DIR/notification_setting.$Current_Date_time.sql.gz.gpg s3://backupprd/$host/data/mysql/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309dergf453601d9c

rm -f $BACKUP_DIR/lending_saas_prod.$Current_Date_time.sql.gz.gpg
rm -f $BACKUP_DIR/notification_setting.$Current_Date_time.sql.gz.gpg

# Remove all but the latest backups
cd $BACKUP_DIR
ls -t | tail -n +$BACKUP_HISTORY | xargs rm --

