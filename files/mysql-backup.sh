#!/bin/bash
PASSWORD=$(/bin/hiera -c /etc/puppet/hiera.yaml mysql::server::root_password)

mysql -uroot -p$PASSWORD -s -N -e "select distinct table_schema from information_schema.tables where engine='innodb' and table_schema != 'mysql';" | xargs mysqldump -uroot -p$PASSWORD --single-transaction --databases > /ctl_plane_backups/openstack-backup-mysql.sql

mysql -uroot -p$PASSWORD -s -N -e "SELECT CONCAT('\"SHOW GRANTS FOR ''',user,'''@''',host,''';\"') FROM mysql.user where (length(user) > 0 and user NOT LIKE 'root')" | xargs -n1 mysql -uroot -p$PASSWORD -s -N -e | sed 's/$/;/' > /ctl_plane_backups/openstack-backup-mysql-grants.sql

