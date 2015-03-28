#!/bin/bash
echo "Provisioning virtual machine..."
# Git
echo "Please, wait..."
apt-get install git -y > /dev/null
apt-get install npm -y > /dev/null
apt-get install nodejs -y > /dev/null
apt-get install python-pip -y > /dev/null
apt-get install lftp -y > /dev/null
# Install globally dependencies
npm install -g express
npm install -g bower
echo "Finished provisioning."