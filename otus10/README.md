ДЗ 10.
ДЗ: Systemd - создание unit-файла
Лог vagrant в файле vagrant.log

1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова

   Создаем конфигурационный файл для сервиса мониторинга, описываем сам сервис и создаем watcher для запуска сервиса по таймеру,
   проверяем работоспособность по логу syslog
   
   ![Screenshot from 2025-02-13 19-32-23](https://github.com/user-attachments/assets/be05cc8c-d2f1-4534-bb46-963ef917205f)

2. Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта

Скачиваем необходимые пакеты, создаем конфигурационный и юнит файл для fcgi, запускаем сервис, првоеряем статус

![Screenshot from 2025-02-13 21-06-54](https://github.com/user-attachments/assets/8fa6ca8a-368b-48ae-a383-4197bc4352db)

3. Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно

   Создаем untit файл для возможности запуска 2 конфигов Nginx, создаем 2 кофига с разными портами,
   запускаем сервис systemctl start nginx@first и systemctl start nginx@second, проверяем, что оба сервиса работоспособны

![Screenshot from 2025-02-13 21-07-40](https://github.com/user-attachments/assets/a9340f02-1738-4ff3-a8ee-a371fd61c736)
![Screenshot from 2025-02-13 21-08-18](https://github.com/user-attachments/assets/45cb551b-275c-4418-95e2-b9560f400326)
