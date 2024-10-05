#!/bin/bash

#Description: This is the script for spinup the aws ec2 instances

#checking that awscli is there in system or not
aws --version

if [ $? == 0 ]; then


    echo "awscli is already there"

  else

   sudo apt-get update
   sudo apt-get install awscli  -y
   aws --version

fi

#script for spinup the instance which is not running

check=aws ec2 describe-instances --filters "Name=tag:Name,Values=Nagios" | grep "stopped" >> ec2info
status=${ec2info}
echo $status
cut -d'"' -f4 ec2info > ec2_test
inst_status=${cat ec2_test}
echo $inst_status

aws --region us-east-1 ec2 describe-instances --filters "Name=tag:Name,Values=nagios-client" | grep "InstanceId" >> ec2

inst_id=${cat ec2}

echo $id

echo "Getting the instance id"

cut -d'"' -f4 ec2 > ec2inform

ec2_id=${cat ec2inform}

echo $ec2_id

if [ $inst_status != running ]; then

   echo  "$ec2_id not running"

  echo "i am on the way to start the instance"

 aws ec2 start-instances --instance-ids "$ec2_id"

 else

  demo instance is running

fi

