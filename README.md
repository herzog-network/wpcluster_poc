# PROOF OF CONCEPT

Dockerized Wordpress swarm cluster with self signed certificate.

![wpc](https://user-images.githubusercontent.com/75946937/106370402-f6df4a80-6359-11eb-8e34-5af04dfeec79.png)

## Services
  * Docker Swarm
  * GlusterFS
  * MariaDB
  * Wordpress
  * UFW as firewall
  * Self signed cert
  * HAProxy as Loadbalancer
  * Optional: LetsEncrypt integration

## Hint
  * There will be a short interruption if the database serving node dies

## Improve:
  * Database multi master cluster
  * setup.sh

## Verified OS
  - Ubuntu Srv 20.10

## Verified Docker version
  - 20.10.2

## HAproxy stats
  - Login - https://tld/my-stats  
      - User: wpc  
      - Pass: wpcstats
  - configure user or passwd  
      - conf/haproxy.cfg

## Usage
  - setup 4 dedicated docker nodes
  - execute all commands within setup.sh
  - start wpcluster  
    - ```cd /home/swarm && wget https://github.com/herzog-network/wpcluster_poc/blob/master/startup.sh && chmod 777 startup.sh```
    - ```sudo -H -u swarm bash -c ./startup.sh```
  - LetsEncrypt (optional)
    - look into [create-cert.sh](create-cert.sh) and [renew-cert.sh](renew-cert.sh) for a short usage description

## Links / Credits:
  - https://docs.docker.com/engine/install/ubuntu/
  - https://docs.docker.com/engine/swarm/
  - https://docs.gluster.org/en/latest/Install-Guide/Configure/
  - https://docs.gluster.org/en/latest/Administrator-Guide/Split-brain-and-ways-to-deal-with-it/#1-replica-3-volume
  - https://www.haproxy.com/de/blog/haproxy-on-docker-swarm-load-balancing-and-dns-service-discovery/
  - https://omarghader.github.io/haproxy-letsencrypt-docker-certbot-certificates/
