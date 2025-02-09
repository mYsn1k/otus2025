#!/bin/bash

pvcreate /dev/sde

vgcreate vg_home /dev/sde

lvcreate -L 300MB -n lv_home vg_home

mkfs.ext4 /dev/vg_home/lv_home

mkdir /mnt/home

mount /dev/vg_home/lv_home /mnt/home

cp -aR /home/* /mnt/home

rm -rf /mnt/home/lost+found/

rm -rf /home/*

umount /mnt/home

mount /dev/vg_home/lv_home /home/

echo "`blkid | grep home | awk '{print $2}'` /home ext4 defaults 0 0" >> /etc/fstab
