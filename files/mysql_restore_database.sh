#!/bin/bash
docker exec -i $(docker container ls --all --format "{{ .Names }}" --filter=name=galera-bundle) /bin/bash <<-EOF
mysqld_safe --skip-networking --wsrep-on=OFF &
sleep 5
mysql -u root < $1 
mysql -u root < $2 
/usr/bin/mysqladmin -u root shutdown
EOF



