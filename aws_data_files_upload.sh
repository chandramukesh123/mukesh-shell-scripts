#!/bin/bash
CMD_GPG=/usr/bin/gpg
GPG_PASSPHRASE_FILE_PRD=/backup/cron/passphrase

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

zip -r  /backup/$host/datafiles/$today.war.zip /var/lib/tomcat7/webapps/*.war >> /backup/log/backup.$host.txt
$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /backup/$host/datafiles/$today.war.zip >> /backup/log/backup.$host.txt
rm -f /backup/$host/datafiles/$today.war.zip
aws s3 cp /backup/$host/datafiles/$today.war.zip.gpg s3://backupprd/$host/datafiles/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9c4drw >> /backup/log/backup.$host.txt
rm -f /backup/$host/datafiles/$today.war.zip.gpg

zip -r  /backup/$host/datafiles/$today.ssl.zip /etc/apache2/ssl/* >> /backup/log/backup.$host.txt
$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /backup/$host/datafiles/$today.ssl.zip >> /backup/log/backup.$host.txt
rm -f /backup/$host/datafiles/$today.ssl.zip
aws s3 cp /backup/$host/datafiles/$today.ssl.zip.gpg s3://backupprd/$host/datafiles/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9c43de >> /backup/log/backup.$host.txt
rm -f /backup/$host/datafiles/$today.ssl.zip.gpg

