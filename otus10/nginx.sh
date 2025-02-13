#!/bin/bash

mkdir /etc/nginx
cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf

apt install nginx -y

cp /vagrant/nginx/nginx@.service /etc/systemd/system/nginx@.service

cp /vagrant/nginx/nginx-first.conf /etc/nginx/nginx-first.conf

cp /vagrant/nginx/nginx-second.conf /etc/nginx/nginx-second.conf

systemctl start nginx
