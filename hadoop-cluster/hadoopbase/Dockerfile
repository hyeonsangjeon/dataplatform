FROM modenaf360/ubuntu-1604
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

# Install program
RUN apt-get install -y curl openssh-server openssh-client rsync wget


# download jdk1.8
RUN mkdir -p /usr/java/default
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
RUN tar -xzvf jdk-8u131-linux-x64.tar.gz -C /usr/java/default --strip-components=1
RUN rm jdk-8u131-linux-x64.tar.gz

# setting java env
ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin
RUN rm -rf /usr/bin/java
RUN ln -s $JAVA_HOME/bin/java /usr/bin/java



#Protobuf install
ENV PROTOBUF_VERSION 2.5.0
ENV PROTOBUF_URL https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-$PROTOBUF_VERSION.tar.gz

RUN set -x \
    && curl -fSL $PROTOBUF_URL -o /tmp/protobuf.tar.gz \
    && tar xvfz /tmp/protobuf.tar.gz -C /usr/local/ \
    && rm /tmp/protobuf.tar.gz*


RUN cd /usr/local/protobuf-2.5.0 && ./configure &&  make && make install

RUN ldconfig


# download hadoop
ENV HADOOP_VERSION 3.2.0
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

RUN curl -fSL https://dist.apache.org/repos/dist/release/hadoop/common/KEYS -o /tmp/hadoop_keys && \
    gpg --import /tmp/hadoop_keys

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /usr/local/ \
    && rm /tmp/hadoop.tar.gz* \
    && ln -s /usr/local/hadoop-$HADOOP_VERSION /usr/local/hadoop \
    && ln -s /usr/local/hadoop-$HADOOP_VERSION /hadoop \
    && ln -s /usr/local/hadoop-$HADOOP_VERSION/etc/hadoop /hadoopconfig


# hadoop env
ENV HADOOP_HOME=/usr/local/hadoop
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_YARN_HOME=$HADOOP_HOME
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
ENV HADOOP_PREFIX=$HADOOP_HOME



RUN echo "export JAVA_HOME=$JAVA_HOME" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_DATANODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_NAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HDFS_SECONDARYNAMENODE_USER=root" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export HADOOP_PID_DIR=${HADOOP_HOME}/pids" >> $HADOOP_HOME/etc/hadoop/hadoop-env.sh && \
    echo "export YARN_RESOURCEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh && \
    echo "export YARN_NODEMANAGER_USER=root" >> $HADOOP_HOME/etc/hadoop/yarn-env.sh



# hadoop log folder
RUN mkdir -p /usr/local/hadoop-$HADOOP_VERSION/logs

RUN mkdir -pv $HADOOP_HOME/dfs
RUN mkdir -pv $HADOOP_HOME/dfs/name
RUN mkdir -pv $HADOOP_HOME/dfs/data

ENV PATH $HADOOP_PREFIX/bin/:$PATH

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh && \
    ln -s $HADOOP_HOME/etc/hadoop /etc/hadoop


ADD run.sh /run.sh
RUN chmod a+x /run.sh


ENTRYPOINT ["/entrypoint.sh"]
CMD ["/bin/bash","-c","/run.sh"]

