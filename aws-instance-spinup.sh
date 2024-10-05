#!/bin/bash

#Description: This is the script for spinup the aws ec2 instances

aws --version

if [ $? == 0 ]; then


    echo "awscli is already there"

  else

   sudo apt-get update
   sudo apt-get install awscli  -y
   aws --version

fi

#aws ec2 create-security-group --group-name script-sg --description "daily tasks"
#aws ec2 describe-security-groups --group-ids sg-03680432d6023364e
#aws ec2 authorize-security-group-ingress --group-id sg-03680432d6023364e --protocol tcp --port 22 --cidr 54.88.69.30/24
#aws ec2 describe-security-groups --group-ids sg-03680432d6023364e


# checking the instance state is running or not

check=aws ec2 describe-instances --filters "Name=tag:Name,Values=Nagios" | grep "stopped"
ec2info=aws ec2 describe-instances --filters "Name=tag:Name,Values=Nagios" | cat >> ec2info.txt
inst_id="awk '/"InstanceId":/{print$2}' ${ec2info} | sed 's/",//g' | sed 's/"//g'"
start_inst='aws ec2 start-instances --instance-ids ${inst_id}'


${inst_id}
${ec2info}
${check}

if [ $? == 0 ]; then


    ${start_inst}

   else

    echo Demo server is running

fi

