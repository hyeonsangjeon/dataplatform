# ubuntu-1604
This ubuntu has the same rsa information about root account. 
* between cluster containers using this Ubuntu image, when to move ssh between root accounts password is not asked. 
Used for handling authorized_keys rsa such as hadoop cluster.
* You can create an Ubuntu account when you start the container.
* In the docker, the entrypoint foreground process is ssh.


## How to use
###1.Starting two Ubuntu containers.
- USER, USER_PW :Optional variables when you create ubuntu account, The start character  '!' '$' '&' is does not apply.

docker run
```shell
docker network create ubuntu-1604_default
docker run -d -h ubuntu1 --name ubuntu1 --net ubuntu-1604_default modenaf360/ubuntu-1604
docker run -d -h ubuntu2 --name ubuntu2 --net ubuntu-1604_default modenaf360/ubuntu-1604  
```

or, docker-compose  
```yml
docker-compose  up -d
```

example docker-compose
```yml
version: '2'
services:
  ubuntu1:
    image: modenaf360/ubuntu-1604:latest    
    hostname: ubuntu1
    container_name: ubuntu1
    environment:
      USER: 'groot'
      USER_PW: 'iamgroot'   
   ubuntu2:
      image: modenaf360/ubuntu-1604:latest
      hostname: ubuntu2
      container_name: ubuntu2      
      environment:
        USER: 'groot'
        USER_PW: 'iamgroot'       
```

###2. Check ssh move between two containers using root account without password
```yml
docker exec -it ubuntu1 /bin/bash
->
ssh root@ubuntu2 
```

###3. Confirm account creation
```shell
su groot
```



