FROM modenaf360/hadoop-base
LABEL maintainer="wingnut0310 <wingnut0310@gmail.com>"

ENV HIVE_VERSION 2.3.5
ENV MYSQL_CONN_VER 8.0.16
ENV HADOOP_HOME=/usr/local/hadoop
ENV HIVE_HOME /usr/local/hive

WORKDIR /usr/local

# HIVE 2.3.5 with mysql metastore JDBC
RUN apt-get update && apt-get install -y wget procps && \
    wget https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
    tar -xzvf apache-hive-$HIVE_VERSION-bin.tar.gz && \
    mv apache-hive-$HIVE_VERSION-bin hive && \
    wget http://repo.maven.apache.org/maven2/mysql/mysql-connector-java/$MYSQL_CONN_VER/mysql-connector-java-$MYSQL_CONN_VER.jar -o $HIVE_HOME/lib/mysql-connector-java-$MYSQL_CONN_VER.jar && \
    rm apache-hive-$HIVE_VERSION-bin.tar.gz && \
    apt-get --purge remove -y wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


RUN mkdir -p /log_data/hive && \
    mkdir -p /log_data/llap


#Custom configuration goes here
ADD conf/hive-site.xml $HIVE_HOME/conf
ADD conf/beeline-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-env.sh $HIVE_HOME/conf
ADD conf/hive-exec-log4j2.properties $HIVE_HOME/conf
ADD conf/hive-log4j2.properties $HIVE_HOME/conf
ADD conf/ivysettings.xml $HIVE_HOME/conf
ADD conf/llap-daemon-log4j2.properties $HIVE_HOME/conf

RUN ln -s $HIVE_HOME/etc/hadoop /etc/hive && \
    ln -s $HIVE_HOME /hive && \
    ln -s $HIVE_HOME/conf /hiveconfig



EXPOSE 10000

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/bin/bash","-c","/run.sh"]


