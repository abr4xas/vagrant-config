#!/usr/bin/env bash
set -eu
LC_ALL=C
echo "Provisioning virtual machine..."
echo "Please, wait..."
PASSWORD='root'
# https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04
echo "Adding Swap"
fallocate -l 4G /swapfile > /dev/null 2>&1
chmod 600 /swapfile > /dev/null 2>&1
mkswap /swapfile > /dev/null 2>&1
swapon /swapfile > /dev/null 2>&1
echo "/swapfile   none    swap    sw    0   0" >> /etc/fstab > /dev/null 2>&1
echo "Tweak Swap Settings"
sysctl vm.swappiness=10 > /dev/null 2>&1
vm.vfs_cache_pressure = 50 > /dev/null 2>&1
echo "Installing few things for the server:..."
export DEBIAN_FRONTEND=noninteractive
apt-get update --fix-missing > /dev/null 2>&1
apt-get install php5-fpm php5-mcrypt php5-cli php5-curl php5-gd -y > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD" > /dev/null 2>&1
apt-get install mysql-server php5-mysql -y > /dev/null 2>&1
echo "Install nginx"
echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/nginx-stable.list > /dev/null 2>&1
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C300EE8C > /dev/null 2>&1
apt-get update -y > /dev/null 2>&1
apt-get install nginx -y > /dev/null 2>&1
echo "Applying modifications to php5-fpm"
sed -i '/cgi.fix_pathinfo=1/c cgi.fix_pathinfo=0' /etc/php5/fpm/php.ini > /dev/null 2>&1
sed -i '/max_execution_time = 30/c max_execution_time = 300' /etc/php5/fpm/php.ini > /dev/null 2>&1
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/fpm/php.ini > /dev/null 2>&1
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/fpm/php.ini > /dev/null 2>&1
sed -i "s/short_open_tags = .*/short_open_tags = On/" /etc/php5/fpm/php.ini > /dev/null 2>&1
php5enmod mcrypt > /dev/null 2>&1
echo "Configuring NGINX conf"
rm /etc/nginx/nginx.conf > /dev/null 2>&1
cp /var/www/html/nginx.conf /etc/nginx/ > /dev/null 2>&1
echo "Configuring VHOST"
rm /etc/nginx/sites-available/default > /dev/null 2>&1
cp /var/www/html/default /etc/nginx/sites-available/ > /dev/null 2>&1
# Restart
service nginx restart > /dev/null 2>&1
service php5-fpm restart > /dev/null 2>&1
echo "Downloading the Composer executable:..."
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
echo "Downloading and install node & npm:..."
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - > /dev/null 2>&1
apt-get install nodejs -y > /dev/null 2>&1
npm set progress=false -g > /dev/null 2>&1
npm update -g > /dev/null 2>&1
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
