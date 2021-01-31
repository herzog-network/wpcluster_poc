#!/bin/bash

### Env
HOME=/home/swarm
PDIR=/home/swarm/wpcluster_poc
CLEAN=/home/swarm/wpcluster_poc/certs/.gitignore
CLEAN2=/home/swarm/wpcluster_poc/webroot/.gitignore
CERT=$(find /home/swarm/wpcluster_poc/certs -type f -name "*.pem")
### Env

if [ -d "$PDIR" ]; then
  echo "Project exists ..."
else
  echo "Create Project ..."
  cd $HOME
  git clone https://github.com/herzog-network/wpcluster_poc.git
fi

if test -f "$CLEAN"; then
  echo "Cleanup ..."
  rm -rf $CLEAN && rm -rf $CLEAN2
else
  echo "Skip cleanup ..."
fi

if [ -f "$CERT" ]; then
        echo "Cert exists ..."
else
        echo "Create cert ..."
        cd $PDIR && openssl req -nodes -x509 -newkey rsa:2048 -keyout wpc.key -out wpc.crt -days 30 && cat wpc.key wpc.crt > ./certs/wpc.pem
fi

cd $PDIR && docker stack deploy --compose-file compose.yml wpcluster
