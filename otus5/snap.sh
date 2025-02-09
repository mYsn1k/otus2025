#!/bin/bash

touch /home/file{1..20}


lvcreate -L 300MB -s -n home_snap  /dev/vg_home/lv_home


rm -f /home/file{1..20}

umount /home

lvconvert --merge /dev/vg_home/home_snap

mount /dev/vg_home/lv_home /home/
