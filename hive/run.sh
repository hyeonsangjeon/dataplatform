#!/bin/bash

hadoop fs -mkdir       /tmp
hadoop fs -mkdir -p    /user/hive/warehouse
hadoop fs -chmod g+w   /tmp
hadoop fs -chmod g+w   /user/hive/warehouse

hive --service metastore &

sleep 10
hive --service hiveserver2 &


#foreground staying
/usr/local/bin/gotty  --permit-write --reconnect /bin/bash