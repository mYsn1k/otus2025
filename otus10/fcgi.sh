
#обновляем список пакетов
apt update
#Устанавлвиаем необходимые пакеты
apt install spawn-fcgi php php-cgi php-cli apache2 libapache2-mod-fcgid -y

# поднимаем сервисы fcgi
mkdir /etc/spawn-fcgi/
cp /vagrant/fcgi/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
cp /vagrant/fcgi/spawn-fcgi.conf /etc/spawn-fcgi/fcgi.conf

systemctl daemon-reload
systemctl start spawn-fcgi.service

