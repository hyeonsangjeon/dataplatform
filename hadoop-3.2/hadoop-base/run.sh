#!/bin/bash


service ssh start

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`


##when first container up, hdfs format run
if [ "`ls -A $namedir --ignore='lost+found'`" == "" ]; then
  echo "Formatting namenode name directory: $namedir"
  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format -nonInteractive -force $CLUSTER_NAME
fi


/usr/local/hadoop/sbin/start-all.sh

/usr/local/bin/gotty  --permit-write --reconnect /bin/bash
