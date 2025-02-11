#!/bin/bash

# Проверяем, что файл доступен на клиенте
if [ -f /mnt/nfs/upload/test.txt ]; then
  echo "Файл доступен"
  echo "Содержимое файла:"
  cat /mnt/nfs/upload/test.txt
else
  echo "Ошибка: файл не доступен"
fi
