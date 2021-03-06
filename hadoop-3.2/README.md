# Hadoop3.2
This docker uses Hadoop version 3.2.0. 
* This docker hadoop includes a protocol buffer to support the binary format.
(In the serialization process, Hadoop transfers data in two ways: Text format / Binary format. When the data type between servers is wrong, data developed in different languages ​​is transmitted.)
https://cloud.docker.com/repository/docker/modenaf360/hadoop-3.2

* This Hadoop image based on ubuntu Linux ver.1604 
* A Hadoop cluster created with this image has the same rsa key in the root account. ssh port 22 
* In cluster mode, it is possible to add a tasknode that is activated only by nodemanager.
* All Hadoop cluster nodes have a gotty browser terminal for work.
* All Hadoop applications run in the background(except for the tasknode) You can stop, restart, and start the Hadoop application again in the container after the launch of the docker.

* The entrypoint.sh of the Hadoop Docker image was referenced in [big-data-europe/docker-hadoop](https://github.com/big-data-europe/docker-hadoop). 

## Supported Hadoop Versions
* Hadoop 3.2.0 with Oracle jdk1.8 on Ubuntu 16.04

#### Order of linkage of the image layer to the docker
ubuntu-1604 > hadoop-base > hadoop-3.2

## How to use
There are many Linux environment variables to use as a Hadoop environment file in docker-compose. env_file:
 

### docker options are as follows,

|Variables      |Description                                                   |
|---------------|--------------------------------------------------------------|
|-e CLUSTER_NAME   | Used to determine Hadoop cluster name, initial dfs format.                            |  
|-v ~:/hadoop/dfs/name | hadoop namenode data volume mount       |
|-v ~:/hadoop/dfs/data | hadoop datanode data volume mount       |
|-e NODE_TYPE        |Trigger that determines the name node and invokes Hadoop applications. There is only one in the cluster. |
|-e WORKER_NODE           |In clustermode, apply to namenode and determine datanode. ex> slave1slave2  |
|-e GOTTY_ID          |gotty login id, linux environment variables, do not use start character   '!' '$' '&'                                |
|-e GOTTY_PW           |gotty login password, linux environment variables ,  do not use start character   '!' '$' '&'                                  |
|-e TZ           |take it to user country, linux environment variables                                   |

### 0. Making bridge overlay network
For example, create a network named 'hadoop_cluster_default'.
```shell
docker network create -d bridge hadoop_cluster_default
docker network ls
```

### 1. Hadoop Single Mode
```shell
docker-compose -f example/hadoop_singlemode/docker-compose.yml up -d 
```
### 2. Hadoop Cluster Mode
master (namenode) is installed with all master related applications except datanode and node manager, and only node manager and datanode are allocated to datanode. 
If you are using a single PC, such as a synology, set each data node to a different disk volume.Reduces shuffling disk IO for MR operations.
```shell
docker-compose -f example/hadoop_cluster/docker-compose.yml up -d 
```

### 2-1 In docker orchestration tool 
- Some docker orchestration tools that directly handle the docker overlay network(like Rancher with IPSec) sometimes fail to find the ip for the hostname in the dfs communication.
In this error case, add hdfs-site option
"dfs.namenode.datanode.registration.ip-hostname-check => false"

* error case : "Datanode denied communication with namenode because hostname cannot be resolved"
https://community.cloudera.com/t5/Cloudera-Manager-Installation/Datanode-denied-communication-with-namenode/td-p/69051  
```text
HDFS_CONF_dfs_namenode_datanode_registration_ip___hostname___check=false
```

### 3. Dynamic TaskNode ScaleOut
You can add a TaskNode using hadoop.env, which is the same as the endpoint setting of a resource manager in an existing Hadoop cluster.
Tasknode has only nodemanager enabled and is automatically joined to the yarn as the resourcemanager endpoint in the same Hadoop environment file. 
After check active node of the TaskNode UI and Use it. 

!! If the orchestration does not have a different hostname and you scale out the same container, additional testing is required.
![screenshot1](https://github.com/hyeonsangjeon/dataplatform/blob/master/hadoop-3.2/example/pic/tasknode_scaleout.png?raw=true)
```shell
docker-compose -f ./example/tasknode/docker-compose.yml up -d
``` 

### All node has Gotty Web Terminal 
The gotty browser terminal can be used for account configuration and can be used without validation check if the GOTTY_ID and GOTTY_PW environment variables are not set.
* gotty is using port internal : 7777
![screenshot1](https://github.com/hyeonsangjeon/dataplatform/blob/master/hadoop-3.2/example/pic/gotty_terminal_include.png?raw=true)



### Configure Environment Variables
* The dynamically configurable Hadoop environment file is shown below.
- core-site.xml
- hdfs-site.xml
- yarn-site.xml
- httpfs-site.xml
- kms-site.xml
- mapred-site.xml

#### Special characters in environment variables are converted as follows.
* ___  :  -
* __   :  @
* _    :  .
* @    :  _

example,
```text
YARN_CONF_yarn_scheduler_maximum___allocation___vcores=3
--> 

YARN_CONF_ : yarn-site.xml 

<property><name>yarn.scheduler.maximum-allocation-vcores</name><value>3</value></property>
```

In hadoop.env, the information to change depends on the user setting.
The memory settings of map reduce are set as follows, 

```shell
mapreduce.map.memory.mb + mapreduce.reduce.memory.mb + yarn.app.mapreduce.am.resource.mb < yarn.scheduler.maximum-allocation-mb < yarn.nodemanager.resource.memory-mb
```
![screenshot1](https://github.com/hyeonsangjeon/dataplatform/blob/master/hadoop-3.2/example/pic/hadoop_memory_setting.png?raw=true)


* modify it.
* You can also refer to EMR resource information for settings.
https://docs.aws.amazon.com/emr/latest/ReleaseGuide/emr-hadoop-task-config.html
```text
CORE_CONF_fs_defaultFS=hdfs://master:9000
YARN_CONF_yarn_nodemanager_resource_cpu___vcores=2
YARN_CONF_yarn_scheduler_maximum___allocation___vcores=3
YARN_CONF_yarn_nodemanager_resource_memory___mb=6000
YARN_CONF_yarn_scheduler_maximum___allocation___mb=5000
MAPRED_CONF_mapreduce_map_memory_mb=2048
MAPRED_CONF_mapreduce_reduce_memory_mb=1024
MAPRED_CONF_yarn_app_mapreduce_am_resource_mb=1024
MAPRED_CONF_mapreduce_map_java_opts=-Xmx1024m
MAPRED_CONF_mapreduce_reduce_java_opts=-Xmx1638m
HDFS_CONF_fs_s3a_access_key=accecckey
HDFS_CONF_fs_s3a.endpoint=endpoint
HDFS_CONF_fs_s3a_secret_key=secretkey
```