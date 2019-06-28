#!/bin/bash

service ssh start

namedir=`echo $HDFS_CONF_dfs_namenode_name_dir | perl -pe 's#file://##'`

##Namenode running control & init hdfs format
if [[ "$NODE_TYPE" = "namenode" ]]; then
    ##when first container up, hdfs format run and timeline dir in namenode
    if [ "`ls -A $namedir --ignore='lost+found'`" == "" ]; then

        mkdir -p /hadoop/yarn/timeline

        echo "Formatting namenode name directory: $namedir"
        $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format -nonInteractive -force $CLUSTER_NAME
    else
         hdfs dfsadmin -safemode leave
    fi

    /usr/local/hadoop/sbin/start-dfs.sh
    sleep 25
    /usr/local/hadoop/sbin/start-yarn.sh
    sleep 5
    mapred --daemon start historyserver
    sleep 5
    yarn --daemon start timelineserver
fi


if [[ -n "$GOTTY_ID" ]] && [[ -n $GOTTY_PW ]]; then
    echo "enable_basic_auth = true" >> /root/.gotty
    echo "credential = \"$GOTTY_ID:$GOTTY_PW\""  >> /root/.gotty
fi


#foreground staying
/usr/local/bin/gotty  --permit-write --reconnect /bin/bash
