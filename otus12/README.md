ДЗ 12
ДЗ: Работа с процессами

Парсим содержимое proc/$i/stat с помощью статьи https://stackoverflow.com/questions/39066998/what-are-the-meaning-of-values-at-proc-pid-stat
для сопоставления с выводом команды ps ax
Для расчета времени, выводимого в ps - необходимо сложить stime и utime и разделить на время процессора в тиках sysconf(_SC_CLK_TCK)

![image](https://github.com/user-attachments/assets/b525b6e0-541f-4015-995e-2f6bd5aa28a3)
