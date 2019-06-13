#!/bin/bash

service ssh start

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`

if [ "`ls -A $namedir --ignore='lost+found'`" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  $HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -format -nonInteractive -force $CLUSTER_NAME
fi

$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode