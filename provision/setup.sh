#!/bin/bash
echo "Provisioning virtual machine..."
echo "Please, wait..."
echo 'LANGUAGE="en_US.UTF-8"' >> /etc/default/locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale > /dev/null 2>&1
echo "LANG=en_US.UTF-8" >> /etc/default/locale > /dev/null 2>&1
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale > /dev/null 2>&1
locale-gen en_US.UTF-8 > /dev/null 2>&1
dpkg-reconfigure locales > /dev/null 2>&1
PASSWORD='root'
apt-get update > /dev/null 2>&1
apt-get upgrade -y > /dev/null 2>&1
echo "Installing few things for the server:..."
apt-get install apache2 git subversion lftp php5 libapache2-mod-php5 php5-mcrypt php5-cli php5-curl python-pip -y > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD" > /dev/null 2>&1
apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql -y > /dev/null 2>&1
debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true" > /dev/null 2>&1
debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD" > /dev/null 2>&1
debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" > /dev/null 2>&1
apt-get install phpmyadmin -y > /dev/null 2>&1
echo "Configuring VHOST"
cp /var/www/000-default.conf /etc/apache2/sites-available/000-default.conf
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
curl -sL https://deb.nodesource.com/setup_0.12 | -E bash - > /dev/null 2>&1
aptitude install nodejs -y > /dev/null 2>&1
npm update -g > /dev/null 2>&1
npm install nodemon -g > /dev/null 2>&1
npm install bower -g > /dev/null 2>&1
#echo "Installing rethinkdb:..."
#aptitude install rethinkdb -y > /dev/null 2>&1
#source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | tee /etc/apt/sources.list.d/rethinkdb.list > /dev/null 2>&1
#echo "Adding public key to Rethinkdb:..."
#wget -qO- http://download.rethinkdb.com/apt/pubkey.gpg | apt-key add - > /dev/null 2>&1
#apt-get update > /dev/null 2>&1
#apt-get upgrade -y > /dev/null 2>&1
#cp /etc/rethinkdb/default.conf.sample /etc/rethinkdb/instances.d/instance1.conf > /dev/null 2>&1
#RETHINK=$(cat <<EOF
#runuser=rethinkdb
#rungroup=rethinkdb
#pid-file=/var/run/rethinkdb/rethinkdb.pid
#directory=/var/lib/rethinkdb/default
#bind=all
#server-name=Robbie
#EOF
#)
#echo "${RETHINK}" >> /etc/rethinkdb/instances.d/instance1.conf > /dev/null 2>&1
#/etc/init.d/rethinkdb start > /dev/null 2>&1
echo "Installing MongoDB..."
echo "Import the MongoDB public GPG Key"
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 > /dev/null 2>&1
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list
apt-get update -y > /dev/null 2>&1
apt-get install mongodb-org -y > /dev/null 2>&1
gem install sass -y > /dev/null 2>&1
apt-get autoremove -y > /dev/null 2>&1
echo -e "\e[00;1;92mFinished provisioning... Please reboot\e[00m"
exit 0
