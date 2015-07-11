#!/bin/bash
echo "Provisioning virtual machine..."
echo "Please, wait..."
sudo echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale > /dev/null 2>&1
sudo echo "LANG=en_US.UTF-8" >> /etc/default/locale > /dev/null 2>&1
sudo echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale > /dev/null 2>&1
sudo locale-gen en_US.UTF-8 > /dev/null 2>&1
sudo dpkg-reconfigure locales > /dev/null 2>&1
PASSWORD='root'
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1
echo "Installing few things for the server:..."
sudo apt-get install apache2 git lftp php5 libapache2-mod-php5 php5-mcrypt php5-cli php5-curl python-pip -y > /dev/null 2>&1
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD" > /dev/null 2>&1
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD" > /dev/null 2>&1
sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql -y > /dev/null 2>&1
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true" > /dev/null 2>&1
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD" > /dev/null 2>&1
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD" > /dev/null 2>&1
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD" > /dev/null 2>&1
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" > /dev/null 2>&1
sudo apt-get install phpmyadmin -y > /dev/null 2>&1
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html/"
    <Directory "/var/www/html/">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf > /dev/null 2>&1
sudo a2enmod rewrite deflate expires headers > /dev/null 2>&1
sudo php5enmod mcrypt > /dev/null 2>&1
sudo service apache2 restart > /dev/null 2>&1
echo "Downloading the Composer executable:..."
curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
sudo mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
echo "Downloading node & npm:..."
curl -sL https://deb.nodesource.com/setup_0.12 | sudo -E bash - > /dev/null 2>&1
sudo aptitude install nodejs -y > /dev/null 2>&1
source /etc/lsb-release && echo "deb http://download.rethinkdb.com/apt $DISTRIB_CODENAME main" | sudo tee /etc/apt/sources.list.d/rethinkdb.list > /dev/null 2>&1
echo "Adding public key to Rethinkdb:..."
wget -qO- http://download.rethinkdb.com/apt/pubkey.gpg | sudo apt-key add - > /dev/null 2>&1
sudo apt-get update > /dev/null 2>&1
sudo apt-get upgrade -y > /dev/null 2>&1
echo "Installing node & rethinkdb:..."
sudo aptitude install rethinkdb -y > /dev/null 2>&1
sudo npm update -g > /dev/null 2>&1
sudo npm install nodemon -g > /dev/null 2>&1
sudo npm install bower -g > /dev/null 2>&1
sudo cp /etc/rethinkdb/default.conf.sample /etc/rethinkdb/instances.d/instance1.conf > /dev/null 2>&1
RETHINK=$(cat <<EOF
runuser=rethinkdb
rungroup=rethinkdb
pid-file=/var/run/rethinkdb/rethinkdb.pid
directory=/var/lib/rethinkdb/default
bind=all
server-name=Robbie
EOF
)
sudo echo "${RETHINK}" >> /etc/rethinkdb/instances.d/instance1.conf > /dev/null 2>&1
sudo /etc/init.d/rethinkdb start > /dev/null 2>&1
sudo gem install sass -y > /dev/null 2>&1
sudo apt-get autoremove -y > /dev/null 2>&1
echo "Finished provisioning... Please reboot"
