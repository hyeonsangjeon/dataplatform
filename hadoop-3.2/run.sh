#!/bin/bash

service ssh start

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`

##Namenode running control & init hdfs format
if [[ "$NODE_TYPE" = "namenode" ]]; then
    ##when first container up, hdfs format run
    if [ "`ls -A $namedir --ignore='lost+found'`" == "" ]; then
        echo "Formatting namenode name directory: $namedir"
        $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format -nonInteractive -force $CLUSTER_NAME
    else
         hdfs dfsadmin -safemode leave
    fi

    /usr/local/hadoop/sbin/start-dfs.sh
    sleep 30
    /usr/local/hadoop/sbin/start-yarn.sh
    sleep 5
    /usr/local/hadoop/sbin/mr-jobhistory-daemon.sh start historyserver

fi


if [[ -n "$GOTTY_ID" ]] && [[ -n $GOTTY_PW ]]; then
    echo "enable_basic_auth = true" >> /root/.gotty
    echo "credential = \"$GOTTY_ID:$GOTTY_PW\""  >> /root/.gotty
fi


#foreground staying
/usr/local/bin/gotty  --permit-write --reconnect /bin/bash
