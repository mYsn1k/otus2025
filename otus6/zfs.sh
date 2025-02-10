#!/bin/bash

#Создаем пулы
zpool create compres1 mirror /dev/sdc /dev/sdd
zpool create compres2 mirror /dev/sde /dev/sdf
zpool create compres3 mirror /dev/sdg /dev/sdh
zpool create compres4 mirror /dev/sdi /dev/sdj

#Добавляем сжатие
zfs set compression=gzip compres1
zfs set compression=zle compres2
zfs set compression=lzjb compres3
zfs set compression=lz4 compres4


#Качаем файл, проверяем сжатие
for i in {1..4}; do wget https://link.testfile.org/PDF10MB -P /compres$i; done
zfs get all | grep compress



#Определение настроек пула
cd /tmp
#Скачиваем архив
wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
#Разархивируем
tar -xzvf archive.tar.gz
#Смотрим имя пула
pool=$(zpool import -d zpoolexport/ | awk '/pool:/ {print $2}')
#Импортируем пул
zpool import -d zpoolexport/ $pool
#Определяем настройки пула
zpool get all $pool


#Работа со снапшотом, поиск сообщения от преподавателя
#Скачиваем снапшот
wget -O otus_task2.file --no-check-certificate 'https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download'
#Восстанавливаем
zfs receive otus/test@today < otus_task2.file
#ищем в каталоге /otus/test файл с именем “secret_message”"
find /otus/test -name "secret_message"
#Выводим содержимое
cat /otus/test/task1/file_mess/secret_message
