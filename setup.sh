# ToDo:
# + FIREWALL!!
# + write as setup bash script with options for ip addresses, node names, etc.

## Network
## lb, web1, web2, web3
vi /etc/hosts
10.211.55.28 lb
10.211.55.29 web1
10.211.55.30 web2
10.211.55.31 web3

## Docker
## lb, web1, web2, web3
#!/bin/bash
apt-get remove docker docker-engine docker.io containerd runc
apt-get update && apt-get upgrade -y
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
#    apt-key fingerprint 0EBFCD88
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update && apt-get install docker-ce docker-ce-cli containerd.io -y

## Docker Swarm
#    lb   = Master
#    Web1 = Worker
#    Web2 = Worker
#    Web3 = Worker
docker swarm init --advertise-addr 10.211.55.28                       # lb
docker swarm join --token xyx 10.211.55.28:2377                       # web1, web2, web3
printf wpcluster_poc | docker secret create wp_db_password -          # lb

## GlusterFS
## lb, web1, web2, web3
#    fdisk (add volume or partition)
#    mkfs.ext4 /dev/sdb1
mkdir /wordpress/1 -p (wordpress/2 for web2, etc)
echo '/dev/sdb1 /wordpress/1 ext4 defaults 0 0' >> /etc/fstab (wordpress/2 for web2, etc)
mount -a
mkdir /wordpress/1/brick (wordpress/2 for web2, etc)
add-apt-repository ppa:gluster/glusterfs-9 && apt update && apt install glusterfs-server -y
systemctl start glusterd.service && systemctl enable glusterd.service
#   _PAUSE
gluster peer probe web1 && gluster peer probe web2 && gluster peer probe web3                                 # lb
gluster volume create gfs replica 4 web1:/wordpress/1/brick web2:/wordpress/2/brick web3:/wordpress/3/brick lb:/wordpress/4/brick # lb
gluster volume start gfs                                                                                      # lb
#    sec: gluster volume set gfs auth.allow 10.211.55.28,10.211.55.29,10.211.55.30,10.211.55.31               # lb
echo 'localhost:/gfs /mnt glusterfs defaults,_netdev,backupvolfile-server=localhost 0 0' >> /etc/fstab
mount.glusterfs localhost:/gfs /mnt
mkdir /mnt/db && mkdir /mnt/wp

## Gluster service
vi /etc/systemd/system/glusterfsmounts.service

[Unit]
Description=Glustermounting
Requires=glusterfs-server.service

[Service]
Type=simple
RemainAfterExit=true
ExecStartPre=/usr/sbin/gluster volume list
ExecStart=/bin/mount -a -t glusterfs
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target

run: systemctl daemon-reload
run: systemctl enable glusterfsmounts
## End gluster service

## Swarm user
useradd -m -s /bin/bash swarm
passwd swarm
usermod -aG docker swarm

## Firewall
Manager
ufw default deny incoming
ufw default allow outgoing
ufw allow from 10.0.0.0/8
ufw allow ssh
ufw allow http
ufw allow https
ufw enable

Worker
ufw default deny incoming
ufw default allow outgoing
ufw allow from 10.0.0.0/8
ufw allow ssh
ufw enable
