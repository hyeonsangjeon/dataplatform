# Jupyter Notebook

Jupyter notebook with Python, Scala, R, Spark, Mesos Stack, Hadoop Yarn

- This Jupyter notebook made by based on https://github.com/jupyter/docker-stacks
- Now 'jovyan' linux accounts can use sudo / sudo -i with no passwd
- Python, Scala, R, Spark, Mesos Stack, Hadoop Yarn 
- User passwords are automatically created with sha1 at container creation time using Linux environment variables when using 'USER_PASSWD'
- Hadoop environment variables are automatically created when using 'hadoop.env'


## How to use

### docker run 
```shell
docker run -p 8888:8888 -e USER_PW=iamgroot modenaf360/jupyter-notebook:latest
```

### docker-compose 

There are many Linux environment variables to use as a Hadoop environment file in docker-compose. env_file:
```shell
cd ./example
docker-compose up
```