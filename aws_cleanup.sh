#!/bin/bash
host=`hostname`
aws s3 ls s3://backupprd/$host/datafiles/ | while read -r line;
       do
        createDate=`echo $line|awk {'print $1" "$2'}`
        createDate=`date -d"$createDate" +%s`
        olderThan=`date --date "10 days ago" +%s`
        if [[ $createDate -lt $olderThan ]]
           then
            fileName=`echo $line|awk {'print $4'}`
            if [[ $fileName != "" ]]
            then
                    aws s3 rm s3://backupprd/$host/datafiles/$fileName
            fi
       fi
       done;

