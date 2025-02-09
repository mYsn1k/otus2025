#!/bin/bash

#

lvremove /dev/ubuntu-vg/ubuntu-lv -y
lvcreate -n ubuntu-vg/ubuntu-lv -L 8G /dev/ubuntu-vg -y
mkfs.ext4 /dev/ubuntu-vg/ubuntu-lv
mount /dev/ubuntu-vg/ubuntu-lv /mnt
rsync -avxHAX / /mnt/
for i in /proc/ /sys/ /dev/ /run/ /boot/;  do mount --bind $i /mnt/$i; done
chroot /mnt/ /bin/bash << EOT
grub-mkconfig -o /boot/grub/grub.cfg
update-initramfs -u
exit
EOT

#pvremove /dev/sdb --force --force -y
