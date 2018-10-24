#!/usr/bin/env bash

# Variables
APPENV=local
DBHOST=localhost
DBNAME=typo
DBUSER=dbuser
DBPASSWD=dbpass
DBROOT=toor
TYPOURL=get.typo3.org/9
EXTENSION=sv_shopware_typo3

echo -e "\n--- Updating packages list ---\n"
apt-get -qq update

echo -e "\n--- Install base packages ---\n"
apt-get -y install vim curl build-essential python-software-properties git subversion 

echo -e "\n--- Install MySQL specific packages and settings ---\n"
echo "mysql-server mysql-server/root_password password $DBROOT" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBROOT" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBROOT" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBROOT" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBROOT" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
apt-get -y install mysql-server-5.7 phpmyadmin

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBROOT -e "CREATE DATABASE $DBNAME CHARACTER SET utf8 COLLATE utf8_unicode_ci"
mysql -uroot -p$DBROOT -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"
mysql -uroot -p$DBROOT typo < /vagrant/db_dump/typo95.sql

echo -e "\n--- Installing PHP-specific packages ---\n"
add-apt-repository ppa:ondrej/php
apt -qq update
apt-get -y --allow-unauthenticated install php7.2 apache2 libapache2-mod-php7.2 php7.2-curl php7.2-gd php-mcrypt php7.2-mysql php7.2-soap php7.2-xml php7.2-zip php7.2-mbstring php7.2-intl php-apcu php-xdebug

echo -e "\n--- Enabling mod-rewrite ---\n"
a2enmod rewrite 

echo -e "\n--- Allowing Apache override to all ---\n"
sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf

echo -e "\n--- We definitly need to see the PHP errors, turning them on ---\n"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/apache2/php.ini
sed -i "s/; max_input_vars = .*/max_input_vars = 1500/" /etc/php/7.2/apache2/php.ini

echo -e "\n--- Turn off disabled pcntl functions so we can use Boris ---\n"
sed -i "s/disable_functions = .*//" /etc/php/7.2/cli/php.ini

echo -e "\n--- Configure Apache to use php7.2 ---\n"
rm /etc/apache2/mods-enabled/php7.0.conf
rm /etc/apache2/mods-enabled/php7.0.load
ln -s /etc/apache2/mods-available/php7.2.conf /etc/apache2/mods-enabled/php7.2.conf
ln -s /etc/apache2/mods-available/php7.2.load /etc/apache2/mods-enabled/php7.2.load

echo -e "\n--- Configure Apache to use phpmyadmin ---\n"
echo -e "\n\nListen 81\n" >> /etc/apache2/ports.conf
cat > /etc/apache2/conf-available/phpmyadmin.conf << "EOF"
<VirtualHost *:81>
    ServerAdmin webmaster@localhost
    DocumentRoot /usr/share/phpmyadmin
    DirectoryIndex index.php
    ErrorLog ${APACHE_LOG_DIR}/phpmyadmin-error.log
    CustomLog ${APACHE_LOG_DIR}/phpmyadmin-access.log combined
</VirtualHost>
EOF
a2enconf phpmyadmin q

echo -e "\n--- Add environment variables to Apache ---\n"
cat > /etc/apache2/sites-enabled/000-default.conf <<EOF
<VirtualHost *:80>
    DocumentRoot /var/www
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
    SetEnv APP_ENV $APPENV
    SetEnv DB_HOST $DBHOST
    SetEnv DB_NAME $DBNAME
    SetEnv DB_USER $DBUSER
    SetEnv DB_PASS $DBPASSWD
</VirtualHost>
EOF

echo -e "\n--- Configure Xdebug ---\n"
cat <<EOT >> /etc/php/7.2/apache2/php.ini

# Added for xdebug
zend_extension="/usr/lib/php/20180731/xdebug.so"
xdebug.remote_enable = on
xdebug.remote_connect_back = on
xdebug.idekey = "PHPSTORM"
xdebug.remote_host = "192.168.33.1"
xdebug.remote_port=9000
xdebug.max_nesting_level=400
xdebug.remote_log = /tmp/xdebug.log

EOT

echo -e "\n--- Install TYPO3 ---\n"
mkdir /usr/local/typo3
cd /usr/local/typo3
#wget "$TYPOURL"
wget --content-disposition $TYPOURL
tar -xzvpf typo3*
rm typo3*

cd /var/www
ln -s /usr/local/typo3/typo3_src-9.5.*/ typo3_src
ln -s typo3_src/index.php .
ln -s typo3_src/typo3/ .
ln -s /vagrant/fileadmin fileadmin
ln -s /vagrant/typo3conf typo3conf
cp typo3_src/_.htaccess .htaccess
touch FIRST_INSTALL

sed -i "s/upload_max_filesize = .*/upload_max_filesize = 32M/" /etc/php/7.2/apache2/php.ini
sed -i "s/max_execution_time = .*/max_execution_time = 240/" /etc/php/7.2/apache2/php.ini
sed -i "s/post_max_size = .*/post_max_size = 32M/" /etc/php/7.2/apache2/php.ini

sed -i "s/export APACHE_RUN_USER=www-data/export APACHE_RUN_USER=vagrant/g" /etc/apache2/envvars
sed -i "s/export APACHE_RUN_GROUP=www-data/export APACHE_RUN_GROUP=vagrant/g" /etc/apache2/envvars

mkdir -p /var/www/typo3conf/ext/
touch /var/www/typo3conf/ENABLE_INSTALL_TOOL
#ln -s /vagrant /var/www/typo3conf/ext/$EXTENSION

chown -R vagrant .

echo -e "\n--- Restarting Apache ---\n"
service apache2 restart 

echo -e "\n--- Add environment variables locally ---\n"
cat >> /home/vagrant/.bashrc <<EOF

alias la='ls -la'

# Set envvars
export APP_ENV=$APPENV
export DB_HOST=$DBHOST
export DB_NAME=$DBNAME
export DB_USER=$DBUSER
export DB_PASS=$DBPASSWD
EOF
