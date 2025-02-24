#!/bin/bash

#################################################################################################
#												#
# Вычисляем из lsblk девайсы размером 1 гб. делаем выборку по sd* , добавляеям в начало /dev/,	#
# вырезаем начало строк, чтобы собрать в 1 строку						#
#												#
#################################################################################################
sudo mdadm --create --verbose /dev/md555 -l 5 -n 5 $(lsblk | grep 1G | awk '/sd/ {print "/dev/" $1}' | tr '\n' ' ')

# Перезаписываем конфиг ,добавляем информацию о рейде с uuid,
# Обновляем initramfs,  чтобы после ребута имя девайса осталось старым

sudo echo "DEVICE partitions" > /etc/mdadm/mdadm.conf

sudo mdadm --detail --scan >> /etc/mdadm/mdadm.conf

update-initramfs -u -k all
