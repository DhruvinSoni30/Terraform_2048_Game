#!/bin/bash
# Installing dependencies
touch /tmp/log.txt
sudo apt-get update 
sudo apt-get install jq -y
sudo apt-get install awscli -y
sudo apt install apache2 -y
sudo apt-get update
git clone https://github.com/gabrielecirulli/2048.git
cp -R 2048/* /var/www/html
sudo systemctl start apache2 
sudo systemctl enable apache2

# Getting Instance details
identity_doc=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document/)
availability_zone=$(echo "$identity_doc" | jq -r '.availabilityZone')
instance_id=$(echo "$identity_doc" | jq -r '.instanceId')
private_ip=$(echo "$identity_doc" | jq -r '.privateIp')
public_ip=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
account_id=$(echo "$identity_doc" | jq -r '.accountId')
region=$(echo "$identity_doc" | jq -r '.region')

# Variable
ebs_device="/dev/xvdf"

# Retrieving the volume ids whose state is available
volume_ids=$(aws ec2 describe-volumes --region "$region" --filters Name=tag:"Name",Values="Jenkins Volume" Name=availability-zone,Values="$availability_zone" Name=status,Values=available | jq -r '.Volumes[].VolumeId')	

# Attaching the volume to the Instance (The volume will remain the same after instance gets reprovision)
for volume_id in $volume_ids; do
    aws ec2 attach-volume --region "$region" --volume-id "$volume_id" --instance-id "$instance_id" --device "$ebs_device"
done