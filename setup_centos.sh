# Verified on CentOS 7

#    Dirty workaround: disable SELinux (needs to be improved / tested)

## Network example (use your own address range)
## lb, web1, web2, web3
vi /etc/hosts
10.0.0.2 lb
10.0.0.5 web1
10.0.0.3 web2
10.0.0.4 web3

## Docker
## lb, web1, web2, web3
yum update -y && yum install -y yum-utils && yum-config-manager --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
yum update -y && yum install docker-ce docker-ce-cli containerd.io -y
systemctl start docker && systemctl enable docker

## Docker Swarm
#    lb   = Master
#    Web1 = Worker
#    Web2 = Worker
#    Web3 = Worker
docker swarm init --advertise-addr 10.0.0.2                      # lb
docker swarm join --token xyx 10.0.0.2:2377                      # web1, web2, web3
printf wpcluster_poc | docker secret create wp_db_password -     # lb

## Firewall
yum install firewalld -y && systemctl start firewalld && systemctl enable firewalld

Rules Manager
firewall-cmd --permanent --add-service=ssh
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
#   firewall-cmd  --permanent --zone=public --change-interface=eth0 !SET TO YOUR PUBLIC INTERFACE
firewall-cmd --permanent --zone=trusted --add-source=10.0.0.0/8
firewall-cmd --reload
#   Check your config with e.g.: firewall-cmd --zone=public --list-all
#                                firewall-cmd --get-default-zone
#                                firewall-cmd --get-active-zones
Rules Worker
firewall-cmd --permanent --add-service=ssh
#   firewall-cmd  --permanent --zone=public --change-interface=eth0 !SET TO YOUR PUBLIC INTERFACE
firewall-cmd --permanent --zone=trusted --add-source=10.0.0.0/8
firewall-cmd --reload
#   Check your config with e.g.: firewall-cmd --zone=public --list-all
#                                firewall-cmd --get-default-zone
#                                firewall-cmd --get-active-zones

## GlusterFS
## lb, web1, web2, web3
#    fdisk (add volume or partition)
#    mkfs.ext4 /dev/sdb1
mkdir /wordpress/1/brick -p (wordpress/2 for web2, etc)
echo '/dev/sdb1 /wordpress/1 ext4 defaults 0 0' >> /etc/fstab (wordpress/2 for web2, etc)
mount -a
mkdir /wordpress/1/brick (wordpress/2 for web2, etc)
yum install centos-release-gluster -y && yum install glusterfs-server -y
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
Requires=glusterd.service

[Service]
Type=simple
RemainAfterExit=true
ExecStartPre=/usr/sbin/gluster volume list
ExecStart=/bin/mount -a -t glusterfs
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target

run: systemctl daemon-reload && systemctl enable glusterfsmounts
## End gluster service

## Swarm user
useradd -m -s /bin/bash swarm
usermod -aG docker swarm

yum install git openssl -y
