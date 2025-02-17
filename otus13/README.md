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





