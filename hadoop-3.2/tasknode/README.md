# Hadoop3.2
This docker uses Hadoop version 3.2.0. 
* This hadoop tasknode image can not be used independently.
* This can be applied to any pre-generated Hadoop cluster. ( https://cloud.docker.com/u/modenaf360/repository/docker/modenaf360/hadoop-3.2)

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