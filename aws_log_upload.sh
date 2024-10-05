#!/bin/bash
CMD_GPG=/usr/bin/gpg
GPG_PASSPHRASE_FILE_SANDBOX=/backup/cron/passphrase

today=`date '+%Y-%m-%d'`
yesterday=`date -d "1 day ago" '+%Y-%m-%d'`
dyesterday=`date -d "2 day ago" '+%Y-%m-%d'`
today=`date '+%Y-%m-%d'`
host=`hostname`
if [ ! -d "/backup/$host" ]
then
mkdir /backup/$host
fi
if [ ! -d "/backup/log" ]
then
mkdir /backup/log
fi
aws s3 ls s3://backupsndbx/$host/logs/logFiles/$dyesterday.log.zip.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
echo Backup log for $dyesterday >> /backup/log/backup.$host.txt
zip -jr  /backup/$host/$dyesterday.log.zip /mnt/logFiles/$dyesterday/* >> /backup/log/backup.$host.txt
$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /backup/$host/$dyesterday.log.zip >> /backup/log/backup.$host.txt
rm -f /backup/$host/$dyesterday.log.zip
aws s3 cp /backup/$host/$dyesterday.log.zip.gpg s3://backupsndbx/$host/logs/logFiles/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aa7a-00drf99b28ee758 >> /backup/log/backup.$host.txt
rm -f /backup/$host/$dyesterday.log.zip.gpg
fi
echo Backup log for $yesterday >> /backup/log/backup.$host.txt
zip -jr  /backup/$host/$yesterday.log.zip /mnt/logFiles/$yesterday/* >> /backup/log/backup.$host.txt
$CMD_GPG --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /backup/$host/$yesterday.log.zip >> /backup/log/backup.$host.txt
rm -f /backup/$host/$yesterday.log.zip
aws s3 cp /backup/$host/$yesterday.log.zip.gpg s3://backupsndbx/$host/logs/logFiles/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aasrf7a-0099b28ee758 >> /backup/log/backup.$host.txt
rm -f /backup/$host/$yesterday.log.zip.gpg

#apache backup
if [ -f "/var/log/apache2/access.log.$today.gz" ]
then
$CMD_GPG -o /backup/$host/access.log.$today.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /var/log/apache2/access.log.$today.gz >> /backup/log/backup.$host.txt
aws s3 cp /backup/$host/access.log.$today.gz.gpg s3://backupsndbx/$host/logs/apache/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aa7a-0099erfcdb28ee758 >> /backup/log/backup.$host.txt
rm -f /backup/$host/access.log.$today.gz.gpg
fi
if [ -f "/var/log/apache2/error.log.$today.gz" ]
then
$CMD_GPG -o /backup/$host/error.log.$today.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /var/log/apache2/error.log.$today.gz >> /backup/log/backup.$host.txt
aws s3 cp /backup/$host/error.log.$today.gz.gpg s3://backupsndbx/$host/logs/apache/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aa7a-009ed9b28ee758 >> /backup/log/backup.$host.txt
rm -f /backup/$host/error.log.$today.gz.gpg
fi
aws s3 ls s3://backupsndbx/$host/logs/apache/access.log.$yesterday.gz.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/var/log/apache2/access.log.$yesterday.gz" ]
        then
        $CMD_GPG -o /backup/$host/access.log.$yesterday.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /var/log/apache2/access.log.$yesterday.gz >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/access.log.$yesterday.gz.gpg s3://backupsndbx/$host/logs/apache/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aa7adrgfd-0099b28ee758 >> /backup/log/backup.$host.txt
        rm -f /backup/$host/access.log.$yesderday.gz.gpg
        fi
fi

aws s3 ls s3://backupsndbx/$host/logs/apache/error.log.$yesterday.gz.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/var/log/apache2/error.log.$yesterday.gz" ]
        then
        $CMD_GPG -o /backup/$host/error.log.$yesterday.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /var/log/apache2/error.log.$yesterday.gz >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/error.log.$yesterday.gz.gpg s3://backupsndbx/$host/logs/apache/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aa7a-0099dedb28ee758 >> /backup/log/backup.$host.txt
        rm -f /backup/$host/error.log.$yesderday.gz.gpg
fi

#tomcat backup
if [ -f "/var/log/tomcat7/catalina.out.$today.gz" ]
then
$CMD_GPG -o /backup/$host/catalina.out.$today.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /var/log/tomcat7/catalina.out.$today.gz >> /backup/log/backup.$host.txt
aws s3 cp /backup/$host/catalina.out.$today.gz.gpg s3://backupsndbx/$host/logs/tomcat/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aa7eygfa-0099b28ee758 >> /backup/log/backup.$host.txt
rm -f /backup/$host/catalina.out.$today.gz.gpg
fi

aws s3 ls s3://backupsndbx/$host/logs/tomcat/catalina.out.$yesterday.gz.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/var/log/tomcat7/catalina.out.$yesterday.gz" ]
        then
        $CMD_GPG -o /backup/$host/catalina.out.$yesterday.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX -c /var/log/tomcat7/catalina.out.$yesterday.gz >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/catalina.out.$yesterday.gz.gpg s3://backupsndbx/$host/logs/tomcat/  --sse aws:kms --sse-kms-key-id 0b8c9823-a9a1-4963-aa7a-009erf9b28ee758 >> /backup/log/backup.$host.txt
        rm -f /backup/$host/catalina.out.$yesterday.gz.gpg
        fi
fi

if [ $? = 0 ]
then
echo  "$yesterday Backup of $host logs has been completed\n" >> /backup/log/backup.$host.txt
else
echo  "ALERT: $yesterday Backup of $host logs has failed\n" >> /backup/log/backup.$host.txt
fi
#mail -s "Daily backup report $yesterday of $host" user@gmail.com < /backup/"$host".`date +%F`.txt
#Decrypt
#    gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_SANDBOX=/backup/cron/passphrase -d $yesterday.log.zip.gpg >  $yesterday.log.zip

