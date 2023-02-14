#!/bin/bash

# Update the package list and install Apache2, PHP, PHP MySQLi, Git, and MariaDB
apt-get update -y
apt-get install apache2 php php-mysqli php-mysql git mariadb-server -y
clear 

# Start Apache2 service
service apache2 start

# Clone the web-dinamis-produktif repository to /var/www/

cd /var/www/ && mkdir tes
chmod 777 -R /var/www/tes/
cd /var/www/tes/ && git clone https://github.com/OmTegar/batiku.git
cd /var/www/batiku/admin/proses/image/* && mv -f /var/www/tes/batiku/admin/proses/image/* /var/www/batiku/admin/proses/image/
cd /var/www/batiku/admin/proses/* && mv -f /var/www/tes/batiku/admin/proses/* /var/www/batiku/admin/proses/
cd /var/www/batiku/admin/* && mv -f /var/www/tes/batiku/admin/* /var/www/batiku/admin/
cd /var/www/batiku/* && mv -f /var/www/tes/batiku/* /var/www/batiku/

# chmod 777 -R /var/www/tes/web-project3/
chmod 777 -R /var/www/batiku/

# Replace the default Apache2 configuration with the custom configuration
cd /etc/apache2/sites-available/
rm -r /etc/apache2/sites-available/000-default.conf
cp /var/www/batiku/admin/shell/000-default.conf .
rm ../sites-enabled/000-default.conf
cp 000-default.conf ../sites-enabled/


# Restart Apache2 service
systemctl restart apache2


# Replace the contents of the file
sed -i 's/localhost/database-1.cgu4ysargwic.us-east-1.rds.amazonaws.com/' /var/www/batiku/admin/config/db.php
sed -i 's/root/admin/' /var/www/batiku/admin/config/db.php
sed -i 's/\"\"/\"admin123\"/g' /var/www/batiku/admin/config/db.php

# Check if the modification was successful
if [ $? -eq 0 ]; then
  echo "File db.php has been successfully modified."
else
  echo "Failed to modify the file db.php."
fi

# Login to the RDS database
mysql -h database-1.cgu4ysargwic.us-east-1.rds.amazonaws.com -u admin -p << EOF

# Show existing databases
show databases;

# Use the datasiswa database
use batiku;

# Show tables in the datasiswa database
show tables;

# Select data from the users table
SELECT * FROM form_login;
SELECT * FROM jenis_produk;
SELECT * FROM pelanggan;
SELECT * FROM pembayaran;
SELECT * FROM penjual;
SELECT * FROM produk;
SELECT * FROM supplier;
SELECT * FROM tabel_admin;
SELECT * FROM tabel_kategori;
SELECT * FROM tabel_keranjang;
SELECT * FROM tabel_komentar;
SELECT * FROM tabel_produk;
SELECT * FROM tabel_transaksi;
SELECT * FROM tabel_trolly;
SELECT * FROM tabel_user;
SELECT * FROM transaksi;

# Exit the MySQL prompt
EOF

nano /var/www/batiku/admin/config/db.php
nano /etc/apache2/sites-available/000-default.conf
nano /etc/apache2/sites-enabled/000-default.conf