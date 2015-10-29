#!/bin/bash
LC_ALL=C
echo "Provisioning virtual machine..."
echo "Please, wait..."
PASSWORD='root'
echo "Installing few things for the server:..."
apt-get install apache2 git subversion lftp php5 libapache2-mod-php5 php5-mcrypt php5-cli php5-curl php5-gd python-pip -y > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD" > /dev/null 2>&1
apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql -y > /dev/null 2>&1
echo "Configuring VHOST"
cp /var/www/000-default.conf /etc/apache2/sites-available/000-default.conf > /dev/null 2>&1
a2enmod rewrite deflate expires headers > /dev/null 2>&1
php5enmod mcrypt > /dev/null 2>&1
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini > /dev/null 2>&1
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini > /dev/null 2>&1
sed -i "s/short_open_tags = .*/short_open_tags = On/" /etc/php5/apache2/php.ini > /dev/null 2>&1
service apache2 restart > /dev/null 2>&1
echo "Downloading the Composer executable:..."
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
echo "Downloading and install node & npm:..."
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - > /dev/null 2>&1
apt-get install nodejs -y > /dev/null 2>&1
npm update -g > /dev/null 2>&1
npm install nodemon bower -g > /dev/null 2>&1
#echo "Installing rethinkdb:..."
#aptitude install rethinkdb -y
#source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | tee /etc/apt/sources.list.d/rethinkdb.list
#echo "Adding public key to Rethinkdb:..."
#wget -qO- http://download.rethinkdb.com/apt/pubkey.gpg | apt-key add -
#apt-get update
#apt-get upgrade -y
#cp /etc/rethinkdb/default.conf.sample /etc/rethinkdb/instances.d/instance1.conf
#RETHINK=$(cat <<EOF
#runuser=rethinkdb
#rungroup=rethinkdb
#pid-file=/var/run/rethinkdb/rethinkdb.pid
#directory=/var/lib/rethinkdb/default
#bind=all
#server-name=Robbie
#EOF
#)
#echo "${RETHINK}" >> /etc/rethinkdb/instances.d/instance1.conf
#/etc/init.d/rethinkdb start
#echo "Installing MongoDB..."
#echo "Import the MongoDB public GPG Key"
#apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
#echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
#apt-get update -y
#apt-get install mongodb-org -y
#
# Optimize
# author @sinfallas
# url: https://github.com/sinfallas/optimize
#
modprobe zram > /dev/null 2>&1
echo "104857600" > /sys/block/zram0/disksize > /dev/null 2>&1
mkswap /dev/zram0 > /dev/null 2>&1
swapon /dev/zram0 > /dev/null 2>&1
echo "always" > /sys/kernel/mm/transparent_hugepage/enabled > /dev/null 2>&1
echo "20000" > /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan > /dev/null 2>&1
echo "1" > /sys/kernel/mm/ksm/run > /dev/null 2>&1
echo "20000" > /sys/kernel/mm/ksm/pages_to_scan > /dev/null 2>&1
echo "200" > /sys/kernel/mm/ksm/sleep_millisecs > /dev/null 2>&1
echo -e "\e[00;1;92mFinished provisioning... Please reboot\e[00m"
exit 0
