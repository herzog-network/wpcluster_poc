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

## Limitations
  * There will be a short interruption if the database serving node dies
  * Rootless mode is not supported for overlay networks (used in swarm mode)
    * [Known rootless limitations](https://docs.docker.com/engine/security/rootless/#known-limitations)

## Improve:
  * Database multi master cluster
  * SELinux configuration on CentOS
  * rootless mode via - [sysbox](https://github.com/nestybox/sysbox)?
    * See also [swarm with rootless docker](https://forums.docker.com/t/docker-swarm-with-rootless-docker/87138) & [blog.nestybox.com](https://blog.nestybox.com/2020/10/06/related-tech-comparison.html)
  * setup.sh

## Verified OS
  - Ubuntu Srv 20.10
  - CentOS 7

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
    - ```cd /home/swarm && wget https://raw.githubusercontent.com/herzog-network/wpcluster_poc/master/startup.sh && chmod 777 startup.sh```
    - ```sudo -H -u swarm bash -c ./startup.sh```
  - LetsEncrypt (optional)
    - look into [create-cert.sh](create-cert.sh) and [renew-cert.sh](renew-cert.sh) for a short usage description

## Links / Credits:
  - https://docs.docker.com/engine/install/ubuntu/
  - https://docs.docker.com/engine/install/centos/
  - https://docs.docker.com/engine/swarm/
  - https://docs.gluster.org/en/latest/Install-Guide/Configure/
  - https://docs.gluster.org/en/latest/Administrator-Guide/Split-brain-and-ways-to-deal-with-it/#1-replica-3-volume
  - https://www.haproxy.com/de/blog/haproxy-on-docker-swarm-load-balancing-and-dns-service-discovery/
  - https://omarghader.github.io/haproxy-letsencrypt-docker-certbot-certificates/
