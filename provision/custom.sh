# Custom provisioning commmands for the repo!


# Add the juju command
sudo add-apt-repository ppa:juju/devel
sudo apt-get update
sudo apt-get -y install juju charm charm-tools lxd zfsutils-linux

# configure the zfs pool from a 10GB file in the root directory
dd if=/dev/zero of=/lxdpool.file bs=1k count=1 seek=20M
zpool create lxdpool /lxdpool.file
exit 0
