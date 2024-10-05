#!/bin/sh
CMD_GPG=/usr/bin/gpg
GPG_PASSPHRASE_FILE_PRD=/backup/.passphrase
host=`hostname`
DIR=`date +%m%d%y%h`
today=`date '+%Y-%m-%d'`
ctime=`date +%T`
DEST=/backup/db_backup/$DIR
mkdir $DEST
mongodump --ssl --host hostname:19051 --sslCAFile /home/username/ssl-certs/ca_cert.pem --db lending_saas_prod -o $DEST
mongodump --ssl --host hostname:19051 --sslCAFile /home/username/ssl-certs/ca_cert.pem --db notification_setting -o $DEST

cd /backup/db_backup/$DIR
zip -r  /backup/db_backup/mongo.$today.$ctime.zip *
cd /backup/
rm -rf /backup/db_backup/$DIR
$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /backup/db_backup/mongo.$today.$ctime.zip
rm -f /backup/db_backup/mongo.$today.$ctime.zip

aws s3 cp /backup/db_backup/mongo.$today.$ctime.zip.gpg s3://backupprd/$host/data/mongo/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8reda8-6309d3601d9c
rm -f /backup/db_backup/mongo.$today.$ctime.zip.gpg

