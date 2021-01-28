# ToDo:
# + FIREWALL!!
# + write as setup bash script with options for ip addresses, node names, etc.

## Network
vi /etc/hosts
10.211.55.28 lb
10.211.55.29 web1
10.211.55.30 web2
10.211.55.31 web3

## Docker
#!/bin/bash
apt-get remove docker docker-engine docker.io containerd runc
apt-get update && apt-get upgrade -y
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#    apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install docker-ce docker-ce-cli containerd.io -y

## Docker Swarm
#    Web1 = Manager (Leader)
#    Web2 = Manager
#    Web3 = Manager
docker swarm init --advertise-addr 10.211.55.29
docker swarm join --token xyx 10.211.55.29:2377
docker node promote web2 && docker node promote web3
printf wpcluster_poc | docker secret create wp_db_password -
printf wpcluster_poc | docker secret create mysql_root_password -
docker network create -d overlay --attachable private

#    docker service scale [name]=3

## GlusterFS
#    fdisk (add volume or partition)
#    mkfs.ext4 /dev/sdb1
mkdir /wordpress/1 -p (wordpress/2 for web2, etc)
echo '/dev/sdb1 /wordpress/1 ext4 defaults 0 0' >> /etc/fstab (wordpress/2 for web2, etc)
mount -a
mkdir /wordpress/1/brick (wordpress/2 for web2, etc)
add-apt-repository ppa:gluster/glusterfs-9
apt update && apt install glusterfs-server -y
systemctl start glusterd.service && systemctl enable glusterd.service
gluster peer probe web2 && gluster peer probe web3
gluster volume create gfs replica 3 web1:/wordpress/1/brick web2:/wordpress/2/brick web3:/wordpress/3/brick
gluster volume start gfs
#    sec: gluster volume set gfs auth.allow 10.211.55.29,10.211.55.30,10.211.55.31
echo 'localhost:/gfs /mnt glusterfs defaults,_netdev,backupvolfile-server=localhost 0 0' >> /etc/fstab
mount.glusterfs localhost:/gfs /mnt
mkdir /mnt/db && mkdir /mnt/wp
#    default rollover time -> 60s
