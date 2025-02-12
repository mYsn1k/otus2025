#!/bin/bash

# делаем резервную компию grub.cfg
cp "$GRUB_CFG" "${GRUB_CFG}.bak"

# переименовываем ubuntu--vg на ubuntu--otus в grub.cfg
sed -i "s/ubuntu--vg/ubuntu--otus/g" /boot/grub/grub.cfg

