#!/bin/bash
docker exec -i $(docker container ls --all --format "{{ .Names }}" --filter=name=galera-bundle) /bin/bash <<-EOF
mysqld_safe --skip-grant-tables --skip-networking --wsrep-on=OFF &
sleep 10
mysql -uroot -e "use mysql;update user set password=PASSWORD('$1')" 
/usr/bin/mysqladmin -u root shutdown
EOF
