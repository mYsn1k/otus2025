#!/bin/bash
#Создаем файл с конфигурацией сервиса мониторинга слова
{
echo "WORD="vagrant""
echo "LOG=/var/log/watchlog.log"
} > /etc/default/watchlog

#Создаем файл watchlog.log
cp /var/log/syslog /var/log/watchlog.log

# Создаем  логгер для journactl
{
echo '#!/bin/bash'
echo 'WORD=$1'
echo 'LOG=$2'
echo 'DATE=`date`'
echo 'if grep $WORD $LOG &> /dev/null'
echo 'then'
echo 'logger "$DATE: I found word, Master!"'
echo "else"
echo "exit 0"
echo "fi"
} > /opt/watchlog.sh

#Добавляем парва на запуск
chmod +x /opt/watchlog.sh

#Создаем watchlog service
{
echo "[Unit]"
echo "Description=My watchlog service"
echo "[Service]"
echo "Type=oneshot"
echo "EnvironmentFile=/etc/default/watchlog"
echo 'ExecStart=/opt/watchlog.sh $WORD $LOG'
} > /etc/systemd/system/watchlog.service

#Создаем таймер отслеживания
{
echo "[Unit]"
echo "Description=Run watchlog script every 30 second"
echo "[Timer]"
echo "OnUnitActiveSec=30"
echo "Unit=watchlog.service"
echo "[Install]"
echo "WantedBy=multi-user.target"
} > /etc/systemd/system/watchlog.timer

#Запускаем сервис
systemctl daemon-reload

systemctl start watchlog.timer
systemctl start watchlog.service


