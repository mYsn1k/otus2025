ДЗ 9. Загрузка системы 

1. Включить отображение меню Grub.

Выполняем скрипт grub.sh, перезагружаемся - видим окно grub

![image](https://github.com/user-attachments/assets/e2de6421-d903-4024-8c81-8665ebfb7966)

2. Попасть в систему без пароля несколькими способами.

A) Попадаем в консоль с рут правами через Advanced menu загрузчика и сбрасываем пароль у пользователя andrey.

Видим, что для логина и повышения прав необходлим пароль

![image](https://github.com/user-attachments/assets/a1afbca9-1365-43d4-9492-c29551bca198)

После сброса вход в систему и повышение происходит без пароля

![image](https://github.com/user-attachments/assets/301a2f98-2379-4958-b42a-ddc4f3279aee)


Б) Отредактируем параметры загрузки Ubuntu.
Для этого выбираем пункт Ubuntu, нажимаем "e", в параметрах загрузки в конце строки Linux удаляем ro quiet splash и пишем rw init=/bin/bash, жмем f10, загружаемся в консоль, создаем пользователя otus,
продолжаем загрузку через exec /sbin/init, смотрим, что в /etc/passwd появился новый пользователь

![image](https://github.com/user-attachments/assets/dbfdc5ca-f4e1-4906-8b0f-cc6d44c82c0d)



