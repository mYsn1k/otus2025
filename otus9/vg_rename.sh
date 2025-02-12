#!/bin/bash

# делаем резервную компию grub.cfg
cp /boot/grub/grub.cfg /boot/grub/grub.cfg.bak

# переименовываем ubuntu--vg на ubuntu--otus в grub.cfg
sed -i "s/ubuntu--vg/ubuntu--otus/g" /boot/grub/grub.cfg

