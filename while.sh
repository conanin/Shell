#!/bin/bash
while :
do
    load=`w|head -1|awk -F 'load average: ' '{print $2}' | cut -d. -f1`
    if [ $load -gt 10 ]
    then
        top|mail -s "load is high: $load" gang.yin@hp.com
    fi
    sleep 3
done
