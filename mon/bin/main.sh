#!/bin/bash
# the switch if send mail
export send=1
# filt ip address
export addr=`/sbin/ifconfig|grep -A1 'eth0' | awk '{print $2}'|awk -F: '{print $2}'`
dir=`pwd`
# z只需要最后一级目录名
last_dir=`echo $dir|awk -F '/' '{print $NF}'`
# 保证执行脚本的时候必须位于bin目录下。
if [ $last_dir == "bin" ] || [ $last_dir == "bin/" ];then
    conf_file="../conf/mon.conf"
else
    echo "you should cd bin dir"
    exit
fi
exec 1>>../log/mon.log 2>>../log/err.log

echo "`date+"%F %T"` load average"
/bin/bash ../shares/load.sh

# Check if monitor 502 in the configure file.
if grep -q 'to_mon_502' $conf_file
then
    export log=`grep 'logfile=' $conf_file | awk -F '=' '{print $2}' | sed 's/ //g'`
    /bin/bash ../shares/502.sh
