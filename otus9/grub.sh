#!/bin/bash

# Проверка, запущен ли скрипт с правами root
if [ "$EUID" -ne 0 ]; then
  echo "Пожалуйста, запустите скрипт с правами root (sudo)."
  exit 1
fi

# Путь к конфигурационному файлу Grub
GRUB_CFG="/etc/default/grub"
#!/bin/bash


# Делаем копию текущего файла grub
cp /etc/default/grub /etc/default/grub.bak

# Изменение параметров grub
sed -i 's/^GRUB_TIMEOUT_STYLE=.*/GRUB_TIMEOUT_STYLE=menu/' /etc/default/grub
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=100/' /etc/default/grub

# Обновление конфигурации grub
update-grub

