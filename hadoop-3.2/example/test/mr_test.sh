#!/bin/bash

# create dfs dir
hdfs dfs -mkdir -p input

sleep 2
# put into data
hdfs dfs -put ./simple-word.txt input

# check data
echo -e "\simple-word.txt"
hdfs dfs -cat input/simple-word.txt

sleep 2

hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/sources/hadoop-mapreduce-examples-3.2.0-sources.jar  org.apache.hadoop.examples.WordCount input output

sleep 2

# check output of wordcount
echo -e "\nresult:"
hdfs dfs -cat output/part-r-00000