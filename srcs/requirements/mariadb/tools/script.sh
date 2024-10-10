#!/bin/bash

service mysql start

# wait for MySQL to fully start
until mysqladmin ping &>/dev/null; do
    echo "Waiting for MariaDB to start..."
    sleep 2
done 

# Execute SQL commands with appropriate checks
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Gracefully shut down the MySQL service
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

# Start MariaDB in safe mode in the foreground
exec mysqld_safe