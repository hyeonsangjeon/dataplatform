ARG BASE_CONTAINER=jupyter/all-spark-notebook
FROM $BASE_CONTAINER

USER root
RUN echo "jovyan ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

RUN apt-get -y update && \
    apt-get install -y curl openssh-server openssh-client rsync gnupg vim &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists*

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PATH $PATH:$JAVA_HOME/bin
ENV PATH $PATH:$SPARK_HOME/bin


# Download hadoop
ENV HADOOP_VERSION 3.2.1
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN curl -fSL https://dist.apache.org/repos/dist/release/hadoop/common/KEYS -o /tmp/hadoop_keys && \
    gpg --import /tmp/hadoop_keys

RUN set -x && \
    curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz && \
    curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc && \
    gpg --verify /tmp/hadoop.tar.gz.asc && \
    tar -xvf /tmp/hadoop.tar.gz -C /usr/local/ && \
    rm /tmp/hadoop.tar.gz* && \
    ln -s /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop && \
    ln -s /usr/local/hadoop-$HADOOP_VERSION /hadoop && \
    ln -s /usr/local/hadoop-$HADOOP_VERSION/etc/hadoop /hadoopconfig

# Hadoop env
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_LOG_DIR=${HADOOP_HOME}/logs
ENV PATH $HADOOP_HOME/bin/:$PATH

RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_PID_DIR=${HADOOP_HOME}/pids" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_LOG_DIR=${HADOOP_HOME}/logs" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh

# hadoop folder
RUN mkdir -p /usr/local/hadoop-$HADOOP_VERSION/logs
RUN mkdir -pv $HADOOP_HOME/dfs
RUN mkdir -pv $HADOOP_HOME/dfs/name
RUN mkdir -pv $HADOOP_HOME/dfs/data

#ADD entrypoint.sh /entrypoint.sh
COPY start-notebook.sh /usr/local/bin/
RUN chmod 777 /tmp
RUN chmod a+x /usr/local/bin/start-notebook.sh && \
    ln -s $HADOOP_HOME/etc/hadoop /etc/hadoop

COPY calculator.py /calculator.py
COPY requirements.txt /requirements.txt

RUN pip install -r /requirements.txt





