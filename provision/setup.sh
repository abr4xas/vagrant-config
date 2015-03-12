#!/bin/bash
echo "Provisioning virtual machine..."
# Git
echo "Installing Git"
apt-get install git -y > /dev/null
apt-get install npm -y > /dev/null
apt-get install nodejs -y > /dev/null
# Install globally dependencies
npm install -g express
npm install -g bower
apt-get install python-pip -y > /dev/null
# Esto es para usar make ftp_upload
apt-get install lftp -y > /dev/null
# Instalando pelican y sus cosas
pip install -r requirements.txt
echo "Finished provisioning."