#!/bin/bash

# Делаем копию текущего файла grub
cp /etc/default/grub /etc/default/grub.bak

# Изменение параметров grub
sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=100/' /etc/default/grub

# Обновление конфигурации grub
update-grub

