ДЗ 13

# Домашнее задание

# Практика с SELinux

# 1. Запустить nginx на нестандартном порту 3-мя разными способами

## Устанавлвиаем centos,ставим nginx, правим конфиг, чтобы запустить службу на 4881 порту.
Пытаемся запустить и получаем ошибку

```bash
default: Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
```

Проверяем журнал, видим ошибки по пермишенам

```bash
Feb 17 17:04:34 selinux systemd[1]: nginx.service: control process exited, code=exited status=1
Feb 17 17:04:34 selinux systemd[1]: Failed to start The nginx HTTP and reverse proxy server.
Feb 17 17:04:34 selinux systemd[1]: Unit nginx.service entered failed state.
```

Смотрим статус selinux, видим, что он включен

```bash
[root@selinux vagrant]# getenforce
Enforcing
```
Проверяем по аудитлогу, что проблема в маркерах

```bash
[root@selinux vagrant]# cat /var/log/audit/audit.log | grep 4881
type=AVC msg=audit(1739811874.022:957): avc:  denied  { name_bind } for  pid=3128 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
```
Передадим аудитлог на анализ утилите audit2why. Видим, что нам предлагают включить бул nis_enabled

```bash
[root@selinux vagrant]#  audit2why < /var/log/audit/audit.log 
type=AVC msg=audit(1739811874.022:957): avc:  denied  { name_bind } for  pid=3128 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0

	Was caused by:
	The boolean nis_enabled was set incorrectly. 
	Description:
	Allow nis to enabled

	Allow access by executing:
	# setsebool -P nis_enabled 1
```

Произведем рекомендуемую настройку, перезапустим nginx, првоерим прослушиваемые порты.
Видим, что все запустилось

```bash
[root@selinux vagrant]# setsebool -P nis_enabled 1
[root@selinux vagrant]# systemctl restart nginx
[root@selinux vagrant]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2025-02-17 17:30:51 UTC; 7s ago
  Process: 3248 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 3244 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 3242 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 3250 (nginx)
   CGroup: /system.slice/nginx.service
           ├─3250 nginx: master process /usr/sbin/nginx
           ├─3251 nginx: worker process
           ├─3252 nginx: worker process
           ├─3253 nginx: worker process
           └─3254 nginx: worker process

Feb 17 17:30:50 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 17 17:30:51 selinux nginx[3244]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 17 17:30:51 selinux nginx[3244]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 17 17:30:51 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
[root@selinux vagrant]# ss -tulpan | grep 4881
tcp    LISTEN     0      128       *:4881                  *:*                   users:(("nginx",pid=3254,fd=6),("nginx",pid=3253,fd=6),("nginx",pid=3252,fd=6),("nginx",pid=3251,fd=6),("nginx",pid=3250,fd=6))
tcp    LISTEN     0      128    [::]:4881               [::]:*                   users:(("nginx",pid=3254,fd=7),("nginx",pid=3253,fd=7),("nginx",pid=3252,fd=7),("nginx",pid=3251,fd=7),("nginx",pid=3250,fd=7))
```

## Разрешим работу NGINX c помощью добавления нужного порта в semanage

Откатим настройки була

```bash
[root@selinux vagrant]# setsebool -P nis_enabled 0
[root@selinux vagrant]# systemctl restart nginx
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
```

Найдем необходимый тип, включающий в себя 80 порт

```bash
[root@selinux vagrant]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
```
Добавим 4881 порт в нужный тип и перезапустим nginx, видим, что все запустилось без ошибок

```bash
[root@selinux vagrant]# semanage port -a -t http_port_t -p tcp 4881
[root@selinux vagrant]# semanage port -l | grep  http_port_t
http_port_t                    tcp      4881, 80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
root@selinux vagrant]# systemctl restart nginx
[root@selinux vagrant]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2025-02-17 17:45:00 UTC; 9s ago
  Process: 3317 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 3312 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 3311 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 3319 (nginx)
   CGroup: /system.slice/nginx.service
           ├─3319 nginx: master process /usr/sbin/nginx
           ├─3320 nginx: worker process
           ├─3321 nginx: worker process
           ├─3322 nginx: worker process
           └─3323 nginx: worker process

Feb 17 17:45:00 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 17 17:45:00 selinux nginx[3312]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 17 17:45:00 selinux nginx[3312]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 17 17:45:00 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
```

## Разрешим работу nginx с помощью модуля selinux

Откатим решение с предыдущего пункта, првоерим, что nginx не стартует

```bash
[root@selinux vagrant]# semanage port -d -t http_port_t -p tcp 4881
[root@selinux vagrant]# systemctl restart nginx
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
```
Воспользуемся утилитой audit2allow 

```bash
[root@selinux vagrant]# audit2allow -M nginx < /var/log/audit/audit.log
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i nginx.pp
```

Запустим предлагаемый модуль и проверим, решил ли он проблему, видим, что nginx заработал

```bash
[root@selinux vagrant]# semodule -i nginx.pp
[root@selinux vagrant]# systemctl restart nginx
[root@selinux vagrant]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Mon 2025-02-17 17:53:48 UTC; 6s ago
  Process: 3388 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 3384 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 3382 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 3390 (nginx)
   CGroup: /system.slice/nginx.service
           ├─3390 nginx: master process /usr/sbin/nginx
           ├─3391 nginx: worker process
           ├─3392 nginx: worker process
           ├─3393 nginx: worker process
           └─3394 nginx: worker process

Feb 17 17:53:48 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Feb 17 17:53:48 selinux nginx[3384]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Feb 17 17:53:48 selinux nginx[3384]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Feb 17 17:53:48 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
```

## Решение проблем из репозитория

Скачаем vagrant c github, запустим

После того, как стенд развернется, проверим ВМ с помощью команды: vagrant status
```bash
Current machine states:

ns01                      running (virtualbox)
client                    running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

Подключимся к клиенту, внесем изменения в зону: nsupdate -k /etc/named.zonetransfer.key

```bash
[root@client ~]$ nsupdate -k /etc/named.zonetransfer.key
> server 192.168.56.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.56.15
> send
update failed: SERVFAIL
> quit
```

Dоспользуемся утилитой audit2why для анализа accesslog

```bash
[root@client ~]# audit2why < /var/log/audit/audit.log
```

Тут мы видим, что на клиенте отсутствуют ошибки.

Подключимся к серверу ns01 и проверим аудитлог

```bash
[root@ns01 ~]# audit2why < /var/log/audit/audit.log
type=AVC msg=audit(1683032642.511:1908): avc:  denied  { create } for  pid=5154 comm="isc-worker0000" name="named.ddns.lab.jnl" scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:etc_t:s0 tclass=file permissive=0

	Was caused by:
		Missing type enforcement (TE) allow rule.

		You can use audit2allow to generate a loadable module to allow this access.


    Was caused by:
        Missing type enforcement (TE) allow rule.


        You can use audit2allow to generate a loadable module to allow this access.
```

В логах мы видим, что ошибка в контексте безопасности. Вместо типа named_t используется тип etc_t


Посмотрим, какой тип должн быть по умолчанию через semanage

```bash
[root@ns01 ~]# sudo semanage fcontext -l | grep named
/etc/rndc.*              regular file       system_u:object_r:named_conf_t:s0 
/var/named(/.*)?         all files          system_u:object_r:named_zone_t:s0 
```

Изменим тип для каталога /etc/named
```bash
[root@ns01 ~]# sudo chcon -R -t named_zone_t /etc/named
[root@ns01 ~]# ls -laZ /etc/named
drw-rwx---. root named system_u:object_r:named_zone_t:s0 .
drwxr-xr-x. root root  system_u:object_r:etc_t:s0       ..
drw-rwx---. root named unconfined_u:object_r:named_zone_t:s0 dynamic
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.50.168.192.rev
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.dns.lab.view1
-rw-rw----. root named system_u:object_r:named_zone_t:s0 named.newdns.lab
```
Попробуем снова внести изменения с клиента. Видим, что зона обновилась

```bash
[vagrant@client ~]$ nsupdate -k /etc/named.zonetransfer.key
> server 192.168.56.10
> zone ddns.lab
> update add www.ddns.lab. 60 A 192.168.56.15
> send
> quit 
[vagrant@client ~]$ dig @192.168.56.10 www.ddns.lab

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.el7_9.13 <<>> @192.168.56.10 www.ddns.lab
; (1 server found)
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 63187
;; flags: qr aa rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 1, ADDITIONAL: 2

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.ddns.lab.			IN	A

;; ANSWER SECTION:
www.ddns.lab.		60	IN	A	192.168.56.15

;; AUTHORITY SECTION:
ddns.lab.		3600	IN	NS	ns01.dns.lab.

;; ADDITIONAL SECTION:
ns01.dns.lab.		3600	IN	A	192.168.50.10
```
