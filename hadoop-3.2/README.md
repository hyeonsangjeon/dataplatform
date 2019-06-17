# Hadoop3.2
This docker uses Hadoop version 3.2.0. 
* This docker hadoop includes a protocol buffer to support the binary format.
(In the serialization process, Hadoop transfers data in two ways: Text format / Binary format. When the data type between servers is wrong, data developed in different languages ​​is transmitted.)

* This Hadoop image based on ubuntu Linux ver.1604 
* A Hadoop cluster created with this image has the same rsa key in the root account.

* The entrypoint.sh of the Hadoop Docker image was referenced in [big-data-europe/docker-hadoop](https://github.com/big-data-europe/docker-hadoop). 

## Supported Hadoop Versions
* Hadoop 3.2.0 with Oracle jdk1.8 on Ubuntu 16.04


#### Order of linkage of the image layer to the docker
ubuntu-1604 > hadoop-base > hadoop