# WORK IN PROGRESS

## Done
  * Docker Swarm
  * GlusterFS
  * MariaDB
  * Wordpress

## ToDo
  * Add loadbalancer
  * Fix mariadb if 2 nodes are down
  * Test implementation
  * Improve setup.sh

## Possible improvements for a production environment:
  * run wp & db as non root container
  * docker && glusterd hardening
  * setup automation as bootstraps
  * use fixed docker image versions for wp & db
  * dedicated docker swarm manager as Leader without served docker images (Loadbalancer??)
  * better docker network handling <- tests needed
  * improved password handling for database (printf in setup.sh)
    * e.g. Specify MYSQL_RANDOM_ROOT_PASSWORD in environment variable
  * prevent Split-Brain in GlusterFS (Arbiter Volume)
  * use dedicated volume for GlusterFS
  * external backup
  * monitoring

## Verified OS
  - Ubuntu Srv 20.10

## Usage
  - execute all commands within setup.sh
  - deploy compose.yml to docker leader node
  - docker stack deploy --compose-file compose.yml wpcluster

## Links:
  - https://docs.docker.com/engine/install/ubuntu/
  - https://docs.docker.com/engine/swarm/
  - https://docs.gluster.org/en/latest/Install-Guide/Configure/
