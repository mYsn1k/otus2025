#!/bin/bash

#

pvcreate /dev/sdb
vgcreate vg_root /dev/sdb
lvcreate -n lv_root -l +100%FREE /dev/vg_root
mkfs.ext4 /dev/vg_root/lv_root
mkdir /mnt/root
mount /dev/vg_root/lv_root /mnt/root
rsync -avxHAX  / /mnt/root/
for i in /proc/ /sys/ /dev/ /run/ /boot/;  do mount --bind $i /mnt/root/$i; done
chroot /mnt/root/ /bin/bash << EOT
grub-mkconfig -o /boot/grub/grub.cfg
update-initramfs -u
exit
EOT

