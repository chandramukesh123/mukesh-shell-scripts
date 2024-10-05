#!/bin/bash
CMD_GPG=/usr/bin/gpg
GPG_PASSPHRASE_FILE_PRD=/backup/cron/.passphrase

today=`date '+%Y-%m-%d'`
yesterday=`date -d "1 day ago" '+%Y-%m-%d'`
dyesterday=`date -d "2 day ago" '+%Y-%m-%d'`
today=`date '+%Y-%m-%d'`
host=`hostname`
if [ ! -d "/backup/$host" ]
then
mkdir /backup/$host
fi
if [ ! -d "/backup/$host/datafiles" ]
then
mkdir /backup/$host/datafiles
fi

if [ ! -d "/backup/log" ]
then
mkdir /backup/log
fi
cd /organization-name/micro-service/
zip -r  /backup/$host/datafiles/$today.jar.zip p2p* >> /backup/log/backup.$host.txt
$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /backup/$host/datafiles/$today.jar.zip >> /backup/log/backup.$host.txt
rm -f /backup/$host/datafiles/$today.jar.zip
aws s3 cp /backup/$host/datafiles/$today.jar.zip.gpg s3://backupprd/$host/datafiles/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9c3e432wed >> /backup/log/backup.$host.txt
rm -f /backup/$host/datafiles/$today.jar.zip.gpg

