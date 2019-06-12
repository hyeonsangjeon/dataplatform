#!/bin/bash

# Create a user in the start up if USER environment variable is given
# EX: docker run  -e USER=groot  USER_PW=iamuser


#CREATE USER
if [ ! -z $USER ] && [  $USER != root ]; then
    echo "COME 0000000"
    adduser --disabled-password --gecos ""  "$USER" > /dev/null
    usermod -aG sudo "$USER" > /dev/null
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
    if [[ ! -z $USER_PW ]]; then
        echo "COME 44444"
        sudo echo "$USER:$USER_PW" | chpasswd
    else
        echo "COME555"
        sudo echo "$USER:$USER" | chpasswd
    fi
fi


#MODIFY PASSWD


if [[ ! -z $ROOT_PW ]]; then
    sudo echo "root:$ROOT_PW" | chpasswd
    echo "COME 1111111"
else
    sudo echo "root:root" | chpasswd
    echo "COME 2222222"
fi

/usr/sbin/sshd -D

CMD=${1:-"exit 0"}

if [[ "$CMD" == "-d" ]];
then
    service sshd stop
    /usr/sbin/sshd -D
else
    /bin/bash -c "$*"
fi
