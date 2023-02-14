#!/bin/bash

# Update the package list and install Apache2, PHP, PHP MySQLi, Git, and MariaDB
apt-get update -y
apt-get install apache2 php php-mysqli php-mysql mariadb-server -y
clear 

# Start Apache2 service
service apache2 start

# Give permission to access asset directory and index.php file
chmod 777 -R /var/www/batiku/

# Replace the default Apache2 configuration with the custom configuration
cd /etc/apache2/sites-available/
rm -r /etc/apache2/sites-available/000-default.conf
cp /var/www/batiku/shell/000-default.conf .
rm ../sites-enabled/000-default.conf
cp 000-default.conf ../sites-enabled/


# Restart Apache2 service
systemctl restart apache2

# Replace the contents of the file
sed -i 's/localhost/database-1.cgu4ysargwic.us-east-1.rds.amazonaws.com/' /var/www/batiku/config/db.php
sed -i 's/root/admin/' /var/www/batiku/config/db.php
sed -i 's/\"\"/\"admin123\"/g' /var/www/batiku/config/db.php

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

# Create the datasiswa database
create database batiku;

# Use the datasiswa database
use batiku;

# Import the SQL script to create tables and populate data
source /var/www/batiku/batiku.sql

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

nano /var/www/batiku/config/db.php
nano /etc/apache2/sites-available/000-default.conf
nano /etc/apache2/sites-enabled/000-default.conf