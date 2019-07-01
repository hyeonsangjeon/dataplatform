#!/bin/bash

service ssh start


##################################################
# dbtype : mysql [external metastore db]
# dbtype : derby [standalone internal metastore db]
##################################################
dbtype=$DB_TYPE

initdir=`echo /log_data/hive | perl -pe 's#file://##'`


if [ "`ls -A $initdir --ignore='lost+found'`" == "" ]; then
    echo "##################################################"
    echo "Making initial hive hdfs directory!!!"
    echo "##################################################"
    hdfs dfs -mkdir       /tmp
    hdfs dfs -mkdir -p    /user/hive/warehouse
    hdfs dfs -chmod g+w   /tmp
    hdfs dfs -chmod g+w   /user/hive/warehouse

    echo "##################################################"
    echo "Create initial schema to metastore db: $dbtype"
    echo "##################################################"
    schematool -initSchema -dbType $dbtype
fi


sleep 2

echo "##################################################"
echo " Starting metastore conection"
echo "##################################################"
hive --service metastore &

sleep 10

echo "##################################################"
echo " Starting hiveserver2 "
echo "##################################################"
hive --service hiveserver2 &


#foreground staying
/usr/local/bin/gotty  --permit-write --reconnect /bin/bash