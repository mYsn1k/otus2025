# ДЗ 14. Docker

1. Устанавливаем docker на ubuntu из репозитория ubuntu
```bash
root@vagrant:/docker# apt install docker.io
```

2.  Создаем папку для нашего докера
```bash
mkdir /docker
```
4. В ней создаем Dockerfile и index.html c необходимыми данными
5. Запускаем наш контейнер для оценки правильности настроек. В браузере переходим на 127.0.0.1 и видим кастомную страницу
```bash
root@vagrant:/docker# docker run -dt -p 80:80 otus:nginx
bd47ad0a61d115a67939ef145c6e4c2c5bf7f4bf04d16bdaccea877da16838c5
```
![image](https://github.com/user-attachments/assets/d3e78c65-c7ff-47b3-a497-ab148e656f62)

6.  Логинимся в репозиторий
```bash
root@vagrant:/docker# docker login -u mysn1k
Password: 
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
```
7. Вешаем на наш образ тэг по имени репозитория и пушим
```bash
root@vagrant:/docker# root@vagrant:/docker# docker image tag otus:nginx mysn1k/otus:otus14
root@vagrant:/docker# docker push mysn1k/otus:otus14
The push refers to repository [docker.io/mysn1k/otus]
19b7f185b3ca: Pushed 
c18897d5e3dd: Pushed 
9af9e76ea07f: Pushed 
f1f70b13aacc: Pushed 
252b6db79fae: Pushed 
c9ce8cb4e76a: Pushed 
8f3c313eb124: Pushed 
c1761f3c364a: Pushed 
08000c18d16d: Pushed 
otus14: digest: sha256:18af14f02f5d068d77d994fbec6908f46a9393236f800857c9592aca1d1733ee size: 2196
```
8. Проверяем репозиторий через веб
   
https://hub.docker.com/r/mysn1k/otus/tags

## Ответы на вопросы:
1. Образ — это шаблон, Контейнер — это запущенный экземпляр образа
2. В контейнере нельзя собрать ядро,они используют ядро операционной системы через демон докера
 
