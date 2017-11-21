#!/bin/bash
# Copy this script (and *.zip files in same directory) to an ubuntu machine and run it as root

# Variables
db_name=ssm
username=root
echo -n 'MySql Root Password: '
read -s mysql_password

# Update webserver
apt update -y
apt install unzip lamp-server^ -y

cat << EOF > test.php
<?php phpinfo() ?>
EOF

mv test.php /var/www/html/test.php

# MySQL setup
mysqladmin -uroot create $db_name -p
mysql_secure_installation
cd /var/www/html

# Configure Wordpress
wget http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz
cd wordpress/
mv wp-config-sample.php wp-config.php
sed -i "s/database_name_here/$db_name/" wp-config.php
sed -i "s/username_here/$username/" wp-config.php
sed -i "s/password_here/$mysql_password/" wp-config.php
sed -i 's/upload_max_filesize.*/upload_max_filesize = 10M/' /etc/php/7.0/apache2/php.ini
service apache2 reload
unzip ~/edd-dropbox-file-store-2.0.2-1.zip -d /var/www/html/wordpress/wp-content/plugins/
unzip ~/easy-digital-downloads.2.8.11.zip -d /var/www/html/wordpress/wp-content/plugins/
chown -R www-data /var/www/html/wordpress/
chgrp -R www-data /var/www/html/wordpress/
