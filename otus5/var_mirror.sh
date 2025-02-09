#!/bin/bash

pvremove /dev/sdb --force --force -y

pvcreate /dev/sdc /dev/sdd

vgcreate vg_var /dev/sdc /dev/sdd

lvcreate -l+100%FREE -m1 -n lv_var vg_var

mkfs.ext4 /dev/vg_var/lv_var

mount /dev/vg_var/lv_var /mnt

cp -aR /var/* /mnt/

umount /mnt

rm -rf /var/*

mount /dev/vg_var/lv_var /var

echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab

