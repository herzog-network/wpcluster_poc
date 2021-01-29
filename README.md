# WORK IN PROGRESS

## Done
  * Docker Swarm
  * GlusterFS
  * MariaDB
  * Wordpress
  * Loadbalancer

## ToDo
  * Fix gluster if 2 nodes are down
  * Firewall
  * Cert via Let's Encrypt
  * Test implementation
  * Improve setup.sh

## Possible improvements for a production environment:
  * run wp & db as non root container
  * docker && glusterd hardening
  * setup automation as bootstrap
  * Improve mysql root pw handling (random pw)
  * improve password handling for database (printf in setup.sh)
    * e.g. Specify MYSQL_RANDOM_ROOT_PASSWORD in environment variable
  * prevent Split-Brain in GlusterFS (Arbiter Volume)
  * external backup
  * monitoring

## Verified OS
  - Ubuntu Srv 20.10

## HAproxy stats
  - Login
      User: wpc
      Pass: wpcstats
  - can be changed in conf/haproxy.cfg

## Usage
  - setup 4 dedicated docker nodes
  - execute all commands within setup.sh
  - deploy project to docker manager
  - cd into project
  - run: ```docker stack deploy --compose-file compose.yml wpcluster```

## Links / Credits:
  - https://docs.docker.com/engine/install/ubuntu/
  - https://docs.docker.com/engine/swarm/
  - https://docs.gluster.org/en/latest/Install-Guide/Configure/
  - https://www.haproxy.com/de/blog/haproxy-on-docker-swarm-load-balancing-and-dns-service-discovery/
