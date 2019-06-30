#!/bin/bash

hdfs dfs -mkdir       /tmp
hdfs dfs -mkdir -p    /user/hive/warehouse
hdfs dfs -chmod g+w   /tmp
hdfs dfs -chmod g+w   /user/hive/warehouse

hive --service metastore &

sleep 10
hive --service hiveserver2 &


#foreground staying
/usr/local/bin/gotty  --permit-write --reconnect /bin/bash