#!/bin/bash

apt-get update && apt-get upgrade -y
apt-get install python-pip -y

# Esto es para usar make ftp_upload
apt-get install lftp -y

# Instalando pelican y sus cosas
pip install -r requirements.txt