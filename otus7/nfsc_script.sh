#!/bin/bash
sleep 30
# Проверяем, что файл доступен на клиенте
if [ -f /mnt/nfs/upload/testfile.txt ]; then
  echo "Файл доступен"
  echo "Содержимое файла:"
  cat /mnt/nfs/upload/testfile.txt
else
  echo "Ошибка: файл не доступен"
fi
