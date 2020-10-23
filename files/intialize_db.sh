#!/bin/bash

mv /var/lib/mysql /var/lib/mysql-save
mkdir -p /var/lib/mysql
chown 42434:42434 /var/lib/mysql
chmod 0755 /var/lib/mysql
mysql_install_db --datadir=/var/lib/mysql --user=mysql
chown -R 42434:42434 /var/lib/mysql/
restorecon -R /var/lib/mysql
