rootpw "GoTeamAnt"

# packages
%packages
tar
gdisk
dosfstools
dracut-network
btrfs-progs
%end

# Rerun dracut for the installed kernel (not the running kernel):
%post
curl -L https://github.com/dgonyeo/bootengine/raw/ignition-rhel/30ignition.tar | tar xv -C /usr/lib/dracut/modules.d
sed -i '/linux16/s|$| ip=dhcp rd.neednet=1 coreos.first_boot|' /boot/grub2/grub.cfg

dnf install -y --nogpgcheck --repofrompath 'copr,https://copr-be.cloud.fedoraproject.org/results/dustymabe/ignition/fedora-$releasever-$basearch/' ignition

KERNEL_VERSION=$(rpm -q kernel --qf '%{V}-%{R}.%{arch}\n')
dracut -f /boot/initramfs-$KERNEL_VERSION.img $KERNEL_VERSION -L 5

rm /etc/machine-id
%end
