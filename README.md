# Backup & Restore of Red Hat OpenStack Platform 13

This isn't complete. "Works for me" quality.

# Execute the backup

All the tasks are defined in *run-backup.yml*. It can be used to create Relax and Recover (ReaR) images or only MySQL database backups. Executes tasks described in the [official documentation](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/13/html/undercloud_and_control_plane_back_up_and_restore/index). 

In order to use ReaR, use *configure_rear.yml* playbook to configure it.

Better instructios may or may not be added in the future.

# Recover from backup

This assumes you have a full database backup from your OpenStack control plane, as well as a backup of the grants table. The playbook "run-backup.yml" is capable of generating these backup files.

This procedure will only recover MySQL, so everything else should be working in the environment.

Adjust at least the following variables in restore-backup.yml according to your environment:

Variable | Value
---------|------
nfs_server | address for NFS server where to get the mysql backup files from
mysql_db_file | name of the file with the mysql database backup (don't include path)
mysql_grants_files | name of the file with mysql grants backup (don't include path)
internalapi_domain | the domain used in your cloud for internal API endpoints (check /etc/hosts)

Run the playbook from the undercloud (OpenStack director) as follows:

```
$ source stackrc
$ ansible-playbook -i /usr/bin/tripleo-ansible-inventory  restore-backup.yml
```

When the playbook pauses and asks to run *clustercheck*, connect to the corresponding nodes and execute the following commands:

```
$ sudo docker exec -ti $(docker container ls --all --format "{{ .Names }}" --filter=name=galera-bundle) /bin/bash
# clustercheck
```
The output should be like the following

```
HTTP/1.1 200 OK
Content-Type: text/plain
Connection: close
Content-Length: 32

Galera cluster node is synced.
```

When the playbook finishes, proceed as mentioned in the message shown. Eg.:

```
TASK [What to do next] ***********************************************************************************************************************************************************************************************************************
ok: [lab2con01] => {                             
    "msg": [                                                
        "Things to do next:",                                        
        "- Run \"pcs status\" and check the Galera resource bundle recovers correctly", 
        "  ** Eventually the 3 nodes should be identified as \"Master\" **", 
        "- Cleanup cluster resources",                                
        "- Test OpenStack APIs",                                                     
        "- Remove backup files from /var/lib/mysql on node lab2con01",    
        "  ** files openstack-backup-mysql.sql and openstack-backup-mysql-grants.sql"
    ]                                                                  
}                                                               
                                                           
PLAY RECAP ***********************************************************************************************************************************************************************************************************************************
lab2con01          : ok=22   changed=18   unreachable=0    failed=0
lab2con02          : ok=13   changed=12   unreachable=0    failed=0
lab2con03          : ok=13   changed=12   unreachable=0    failed=0
```

