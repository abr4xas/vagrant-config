#!/bin/bash
echo "Provisioning virtual machine..."
echo "Please, wait..."
PASSWORD='root'
# update 
sudo apt-get update -y > /dev/null 2>&1
sudo apt-get install apache2 mod_rewrite mod_deflate mod_expires mod_headers git python-pip lftp php5 libapache2-mod-php5 php5-mcrypt php5-cli php5-curl -y > /dev/null 2>&1
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql -y > /dev/null 2>&1
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORD"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
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
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf
sudo a2enmod rewrite deflate expires headers > /dev/null 2>&1
sudo php5enmod mcrypt  > /dev/null 2>&1
sudo service apache2 restart  > /dev/null 2>&1
curl -s https://getcomposer.org/installer | php > /dev/null 2>&1
sudo mv composer.phar /usr/local/bin/composer > /dev/null 2>&1
curl https://npmjs.org/install.sh | sh > /dev/null 2>&1
sudo npm install -g bower > /dev/null 2>&1
echo "Finished provisioning."
