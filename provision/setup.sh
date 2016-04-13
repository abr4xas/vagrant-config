#!/usr/bin/env bash
set -eu
LC_ALL=C
echo "Provisioning virtual machine..."
echo "Please, wait..."
PASSWORD='root'
echo "Installing few things for the server:..."
export DEBIAN_FRONTEND=noninteractive
apt-get update --fix-missing > /dev/null 2>&1
apt-get install php5-fpm php5-mcrypt php5-cli php5-curl php5-gd -y > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD" > /dev/null 2>&1
apt-get install mysql-server php5-mysql -y > /dev/null 2>&1
echo "Install nginx"
echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C
apt-get update -y
apt-get install nginx -y
echo "Applying modifications to php5-fpm"
sed -i '/cgi.fix_pathinfo=1/c cgi.fix_pathinfo=0' /etc/php5/fpm/php.ini
sed -i '/max_execution_time = 30/c max_execution_time = 300' /etc/php5/fpm/php.ini
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini > /dev/null 2>&1
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini > /dev/null 2>&1
sed -i "s/short_open_tags = .*/short_open_tags = On/" /etc/php5/fpm/php.ini > /dev/null 2>&1
php5enmod mcrypt > /dev/null 2>&1
echo "Configuring NGINX conf"
rm /etc/nginx/nginx.conf
cp /var/www/html/nginx.conf /etc/nginx/
echo "Configuring VHOST"
rm /etc/nginx/sites-available/default
cp /var/www/html/default /etc/nginx/sites-available/
# Restart
service nginx restart
service php5-fpm restart
echo "Downloading the Composer executable:..."
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
echo "Downloading and install node & npm:..."
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - > /dev/null 2>&1
apt-get install nodejs -y > /dev/null 2>&1
npm update -g > /dev/null 2>&1
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
echo "always" > /sys/kernel/mm/transparent_hugepage/enabled
echo "20000" > /sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan
echo "1" > /sys/kernel/mm/ksm/run
echo "20000" > /sys/kernel/mm/ksm/pages_to_scan
echo "200" > /sys/kernel/mm/ksm/sleep_millisecs
#
# calc-mem
# author @sinfallas
# url: https://github.com/sinfallas/calc-mem
#
memor=$(grep MemTotal /proc/meminfo | awk '{print $2}')
page_size=$(getconf PAGE_SIZE)
phys_pages=$(getconf _PHYS_PAGES)
shmall=$(( $phys_pages / 2 ))
shmmax=$(( $shmall * $page_size ))
mkdir -p /etc/sysctl.d
echo "kernel.shmmax = $shmmax" > /etc/sysctl.d/calc-mem.conf
echo "kernel.shmall = $shmall" >> /etc/sysctl.d/calc-mem.conf
if (( $memor < 1024000 )); then
echo "vm.dirty_ratio = 25" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_background_ratio = 15" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_expire_centisecs = 750" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_writeback_centisecs = 125" >> /etc/sysctl.d/calc-mem.conf
else
if (( $memor > 4096000 )); then
echo "vm.swappiness = 10" >> /etc/sysctl.d/calc-mem.conf
echo "vm.vfs_cache_pressure = 50" >> /etc/sysctl.d/calc-mem.conf
fi
if (( $memor < 8192000 )); then
echo "vm.dirty_ratio = 12" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_background_ratio = 10" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_expire_centisecs = 1500" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_writeback_centisecs = 250" >> /etc/sysctl.d/calc-mem.conf
else
echo "vm.dirty_ratio = 3" >> /etc/sysctl.conf
echo "vm.dirty_background_ratio = 5" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_expire_centisecs = 3000" >> /etc/sysctl.d/calc-mem.conf
echo "vm.dirty_writeback_centisecs = 500" >> /etc/sysctl.d/calc-mem.conf
fi
fi
sysctl -p
echo -e "\e[00;1;92mFinished provisioning... Please reboot\e[00m"
exit 0
