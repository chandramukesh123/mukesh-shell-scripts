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
if [ ! -d "/backup/log" ]
then
mkdir /backup/log
fi

#apache backup
if [ -f "/perfios/logs/apache2/access.log.$today.gz" ]
then
$CMD_GPG -o /backup/$host/access.log.$today.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/apache2/access.log.$today.gz >> /backup/log/backup.$host.txt
aws s3 cp /backup/$host/access.log.$today.gz.gpg s3://backupprd/$host/logs/apache/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9c3e3wsr >> /backup/log/backup.$host.txt
rm -f /backup/$host/access.log.$today.gz.gpg
fi
if [ -f "/perfios/logs/apache2/error.log.$today.gz" ]
then
$CMD_GPG -o /backup/$host/error.log.$today.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/apache2/error.log.$today.gz >> /backup/log/backup.$host.txt
aws s3 cp /backup/$host/error.log.$today.gz.gpg s3://backupprd/$host/logs/apache/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cwr4ed >> /backup/log/backup.$host.txt
rm -f /backup/$host/error.log.$today.gz.gpg
fi
aws s3 ls s3://backupprd/$host/logs/apache/access.log.$yesterday.gz.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/apache2/access.log.$yesterday.gz" ]
        then
        $CMD_GPG -o /backup/$host/access.log.$yesterday.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/apache2/access.log.$yesterday.gz >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/access.log.$yesterday.gz.gpg s3://backupprd/$host/logs/apache/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cedre >> /backup/log/backup.$host.txt
        rm -f /backup/$host/access.log.$yesderday.gz.gpg
        fi
fi

aws s3 ls s3://backupprd/$host/logs/apache/error.log.$yesterday.gz.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/apache2/error.log.$yesterday.gz" ]
        then
        $CMD_GPG -o /backup/$host/error.log.$yesterday.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/apache2/error.log.$yesterday.gz >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/error.log.$yesterday.gz.gpg s3://backupprd/$host/logs/apache/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9c >> /backup/log/backup.$host.txt
        rm -f /backup/$host/error.log.$yesderday.gz.gpg
        fi
fi

#P2plogs
if [ -f "/perfios/logs/p2p-micro-service/p2p-notification.log.$today.0.gz" ]
then
$CMD_GPG -o /backup/$host/p2p-notification.log.$today.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-notification.log.$today.0.gz >> /backup/log/backup.$host.txt
aws s3 /backup/$host/p2p-notification.log.$today.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cwsdrf >> /backup/log/backup.$host.txt
rm -f /backup/$host/p2p-notification.log.$today.0.gz.gpg
fi

aws s3 ls s3://backupprd/$host/logs/p2p-logs/p2p-notification.log.$yesterday.0.gz.gpg.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/p2p-micro-service/p2p-notification.log.$yesterday.0.gz" ]
        then
        $CMD_GPG -o /backup/$host/p2p-notification.log.$yesterday.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-notification.log.$yesterday.0.gz  >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/p2p-notification.log.$yesterday.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cerfcx >> /backup/log/backup.$host.txt
        rm -f /backup/$host/p2p-notification.log.$yesterday.0.gz.gpg
        fi
fi

if [ -f "/perfios/logs/p2p-micro-service/p2p-gateway.log.$today.0.gz" ]
then
$CMD_GPG -o /backup/$host/p2p-gateway.log.$today.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-gateway.log.$today.0.gz >> /backup/log/backup.$host.txt
aws s3 /backup/$host/p2p-gateway.log.$today.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cedrf >> /backup/log/backup.$host.txt
rm -f /backup/$host/p2p-gateway.log.$today.0.gz.gpg
fi

aws s3 ls s3://backupprd/$host/logs/p2p-logs/p2p-gateway.log.$yesterday.0.gz.gpg.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/p2p-micro-service/p2p-gateway.log.$yesterday.0.gz" ]
        then
        $CMD_GPG -o /backup/$host/p2p-gateway.log.$yesterday.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-gateway.log.$yesterday.0.gz  >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/p2p-gateway.log.$yesterday.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cedftr >> /backup/log/backup.$host.txt
        rm -f /backup/$host/p2p-gateway.log.$yesterday.0.gz.gpg
        fi
fi

if [ -f "/perfios/logs/p2p-micro-service/p2p-registry.log.$today.0.gz" ]
then
$CMD_GPG -o /backup/$host/p2p-registry.log.$today.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-registry.log.$today.0.gz >> /backup/log/backup.$host.txt
aws s3 /backup/$host/p2p-registry.log.$today.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9ce4rf >> /backup/log/backup.$host.txt
rm -f /backup/$host/p2p-registry.log.$today.0.gz.gpg
fi

aws s3 ls s3://backupprd/$host/logs/p2p-logs/p2p-registry.log.$yesterday.0.gz.gpg.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/p2p-micro-service/p2p-registry.log.$yesterday.0.gz" ]
        then
        $CMD_GPG -o /backup/$host/p2p-registry.log.$yesterday.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-registry.log.$yesterday.0.gz  >> /backup/log/backup.$host.txt
aws s3 cp /backup/$host/p2p-registry.log.$yesterday.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cedsz >> /backup/log/backup.$host.txt
        rm -f /backup/$host/p2p-registry.log.$yesterday.0.gz.gpg
        fi
fi

if [ -f "/perfios/logs/p2p-micro-service/p2p-crif-api.log.$today.0.gz" ]
then
$CMD_GPG -o /backup/$host/p2p-crif-api.log.$today.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-crif-api.log.$today.0.gz >> /backup/log/backup.$host.txt
aws s3 /backup/$host/p2p-crif-api.log.$today.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9csedes >> /backup/log/backup.$host.txt
rm -f /backup/$host/p2p-crif-api.log.$today.0.gz.gpg
fi

aws s3 ls s3://backupprd/$host/logs/p2p-logs/p2p-crif-api.log.$yesterday.0.gz.gpg.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/p2p-micro-service/p2p-crif-api.log.$yesterday.0.gz" ]
        then
        $CMD_GPG -o /backup/$host/p2p-crif-api.log.$yesterday.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-crif-api.log.$yesterday.0.gz  >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/p2p-crif-api.log.$yesterday.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cwrf4e >> /backup/log/backup.$host.txt
        rm -f /backup/$host/p2p-crif-api.log.$yesterday.0.gz.gpg
        fi
fi

if [ -f "/perfios/logs/p2p-micro-service/p2p-report.log.$today.0.gz" ]
then
$CMD_GPG -o /backup/$host/p2p-report.log.$today.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-report.log.$today.0.gz >> /backup/log/backup.$host.txt
aws s3 /backup/$host/p2p-report.log.$today.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309d3601d9cerfd >> /backup/log/backup.$host.txt
rm -f /backup/$host/p2p-report.log.$today.0.gz.gpg
fi

aws s3 ls s3://backupprd/$host/logs/p2p-logs/p2p-report.log.$yesterday.0.gz.gpg.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/p2p-micro-service/p2p-report.log.$yesterday.0.gz" ]
then
        $CMD_GPG -o /backup/$host/p2p-report.log.$yesterday.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-report.log.$yesterday.0.gz  >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/p2p-report.log.$yesterday.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8edsza8-6309d3601d9c >> /backup/log/backup.$host.txt
        rm -f /backup/$host/p2p-report.log.$yesterday.0.gz.gpg
        fi
fi

if [ -f "/perfios/logs/p2p-micro-service/p2p-config.log.$today.0.gz" ]
then
$CMD_GPG -o /backup/$host/p2p-config.log.$today.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-config.log.$today.0.gz >> /backup/log/backup.$host.txt
aws s3 /backup/$host/p2p-config.log.$today.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6erfd309d3601d9c >> /backup/log/backup.$host.txt
rm -f /backup/$host/p2p-config.log.$today.0.gz.gpg
fi

aws s3 ls s3://backupprd/$host/logs/p2p-logs/p2p-config.log.$yesterday.0.gz.gpg.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/p2p-micro-service/p2p-config.log.$yesterday.0.gz" ]
        then
        $CMD_GPG -o /backup/$host/p2p-config.log.$yesterday.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-config.log.$yesterday.0.gz  >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/p2p-config.log.$yesterday.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6efc309d3601d9c >> /backup/log/backup.$host.txt
        rm -f /backup/$host/p2p-config.log.$yesterday.0.gz.gpg
        fi
fi

if [ -f "/perfios/logs/p2p-micro-service/p2p-auth-server.log.$today.0.gz" ]
then
$CMD_GPG -o /backup/$host/p2p-auth-server.log.$today.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-auth-server.log.$today.0.gz >> /backup/log/backup.$host.txt
aws s3 /backup/$host/p2p-auth-server.log.$today.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309sdfcd3601d9c >> /backup/log/backup.$host.txt
rm -f /backup/$host/p2p-auth-server.log.$today.0.gz.gpg
fi

aws s3 ls s3://backupprd/$host/logs/p2p-logs/p2p-auth-server.log.$yesterday.0.gz.gpg.gpg >> /backup/log/backup.$host.txt > /dev/null 2>&1
if [ $? -ne 0 ]
then
        if [ -f "/perfios/logs/p2p-micro-service/p2p-auth-server.log.$yesterday.0.gz" ]
        then
        $CMD_GPG -o /backup/$host/p2p-auth-server.log.$yesterday.0.gz.gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD -c /perfios/logs/p2p-micro-service/p2p-auth-server.log.$yesterday.0.gz  >> /backup/log/backup.$host.txt
        aws s3 cp /backup/$host/p2p-auth-server.log.$yesterday.0.gz.gpg s3://backupprd/$host/logs/p2p-logs/  --sse aws:kms --sse-kms-key-id f7405160-dc7d-48aa-a8a8-6309frdd3601d9c >> /backup/log/backup.$host.txt
        rm -f /backup/$host/p2p-auth-server.log.$yesterday.0.gz.gpg
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
#    gpg --batch --yes --cipher-algo AES256 --passphrase-file $GPG_PASSPHRASE_FILE_PRD=/backup/cron/passphrase -d $yesterday.log.zip.gpg >  $yesterday.log.zip

