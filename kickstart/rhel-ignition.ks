# Turn on network
services --enabled="NetworkManager,sshd"

rootpw "GoTeamAnt"

# System timezone

timezone Etc/UTC --isUtc

# packages
repo --name=base --baseurl="http://192.168.122.1/rhel7/rhel-7-server-rpms"

repo --name=updates --baseurl="http://192.168.122.1/rhel7/rhel-7-server-rpms"

url --url="http://192.168.122.1/rhel7/rhel-7-server-rpms"

%packages
gdisk
dosfstools
dracut-network
%end

# Rerun dracut for the installed kernel (not the running kernel):
%post
curl -L https://github.com/dgonyeo/bootengine/raw/ignition-rhel/30ignition.tar | tar xv -C /usr/lib/dracut/modules.d
sed -i '/linux16/s|$| ip=dhcp rd.neednet=1 coreos.first_boot|' /boot/grub2/grub.cfg

curl -L https://copr.fedorainfracloud.org/coprs/dustymabe/ignition/repo/epel-7/dustymabe-ignition-epel-7.repo > /etc/yum.repos.d/copr.repo
yum install -y ignition
rm /etc/yum.repos.d/copr.repo

KERNEL_VERSION=$(rpm -q kernel --qf '%{V}-%{R}.%{arch}\n')
dracut -f /boot/initramfs-$KERNEL_VERSION.img $KERNEL_VERSION -L 5

rm /etc/machine-id
%end
