#!/bin/bash

clk_tck=`getconf CLK_TCK`

(
echo "PID|TTY|STAT|TIME|COMMAND";
for i in `ls /proc | grep -E "^[0-9]+$"|sort -n`; do
    if [ -d /proc/$i ]; then
        file=$(</proc/$i/stat)
        command=$(echo $file | awk '{print $2}' )
        state=$(echo $file | awk '{print $3}' )
        tty=$(echo $file | awk '{print $7}')

        utime=$(echo $file | awk '{print $14}')
        stime=$(echo $file | awk '{print $15}')
        ttime=$((utime + stime))
        live_time=$((ttime / clk_tck))

        echo "${i}|${tty}|${state}|${live_time}|${command}"
    fi
done
) | column -t -s "|"
