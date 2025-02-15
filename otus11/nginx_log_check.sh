#!/bin/bash


LOG_FILE="/var/log/monitoring_nginx.log"
LOG_FILE_TEMP="/var/log/monitoring_nginx_temp.log"
nginx_log_file="/var/log/nginx/access.log"
DATE_START="момента установки NGINX"
SUBJECT="Стастистика nginx c $DATE_START по $DATE_END"
EMAIL="root"
LAST_log=""

# Запускаем скрипт:

  CHECK=$(pgrep -f "nginx_log_check.sh" | wc -l)
  if [ "$CHECK" -gt "2" ]
    then
      echo "Еще не завершилась предыдущая итерация скрипта!"
      exit 1
  fi


  if test -f $LOG_FILE
    then
      # Получаем лог на котором остановились в последний раз
      LAST_log=$(grep "LAST_log" $LOG_FILE | tail -n 1 | sed -e "s/LAST_log = /""/g")
      DATE_START=$(echo $LAST_log | awk '{print $4}' | sed -e "s/\[/""/g")
      # Получаем номер строки последнего лога в файле логов nginx
      NumberLine=$(grep -n -F "$LAST_log" $nginx_log_file | tail -n 1 | awk -F":" '{print $1}')
      # Прибавляем к нему 1.
      NumberLine=$((NumberLine + 1))
      # Копируем строки из оригинального файла логов nginx начиная со следующей после последнего лога во временный файл
      tail -n +$NumberLine $nginx_log_file > $LOG_FILE_TEMP
      LAST_log=$(tail -n 1 $LOG_FILE_TEMP)
      echo "LAST_log = "$LAST_log >> $LOG_FILE
    else
      cat $nginx_log_file > $LOG_FILE_TEMP
      LAST_log=$(tail -n 1 $LOG_FILE_TEMP)
      echo "LAST_log = "$LAST_log >> $LOG_FILE
      DATE_END=$(echo $LAST_log | awk '{print $4}' | sed -e "s/\[/""/g")
  fi

echo "Обрабатываемый временной диапазон с "$DATE_START" по "$DATE_END >> $LOG_FILE

  echo "Список Наиболее обращающиеся ip" >> $LOG_FILE
  awk '{print $1}' $LOG_FILE_TEMP | sort | uniq -c | sort -nr | head -n 10 >> $LOG_FILE

  echo "Список наиболее запрашиваемых url" >> $LOG_FILE
  awk '{print $7}' $LOG_FILE_TEMP | sort | uniq -c | sort -nr | head -n 10 >> $LOG_FILE

  echo "Ошибки ответа nginx" >> $LOG_FILE
  grep -P '\" 404 ' $LOG_FILE_TEMP >> $LOG_FILE

  echo "Список всех кодов ответа nginx" >> $LOG_FILE
  awk '{print $9}' $LOG_FILE_TEMP | sort | uniq -c | sort -nr | head -n 10 >> $LOG_FILE


# Отправляем письмо руту
#mail -A "$LOG_FILE" -s "$SUBJECT" -t "$EMAIL" 

#echo 'tail -5 /var/log/mail.log'

