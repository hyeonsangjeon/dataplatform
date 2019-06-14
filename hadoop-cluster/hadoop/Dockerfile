FROM modenaf360/hadoop-base
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

# Namenode & datanode datapath fix
#Namenode
ENV HDFS_CONF_dfs_namenode_name_dir=$HADOOP_HOME/dfs/name
#Datanode
ENV HDFS_CONF_dfs_datanode_data_dir=$HADOOP_HOME/dfs/data
RUN ln -s $HADOOP_HOME/dfs /dfs

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/bin/bash","-c","/run.sh"]

