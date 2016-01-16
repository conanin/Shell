#!/bin/bash
#The script is for nagios, should located in /usr/lib/nagios/plugins.
row=`df -hP | wc -l`
for i in `seq 2 $row`
do
    # Available space
    available=`df -hP | sed -n "$i"p | awk '{print $4}'`
    # Disk usage percentage.
    usage_percentage=`df -hP |  sed -n "$i"p | sed -n "s/\%//"p|awk '{print $5}'`
#    echo "磁盘使用率：$i $usage_percentage"
#    echo "OK"
    # Mount point.
    p_p=`df -h -P | sed -n "$i"p |awk '{print $6}'`
    if [ "$usage_percentage" -gt "97" ]
    then
        echo -n -e "$p_p\tCRITICAL\t$usage_percentage%\t$available\n"
        sta[$i]=2
    elif [ "$usage_percentage" -gt "95" ]
    then
        echo -n -e "$p_p\tWARNING\t$usage_percentage%\t$available\n"
        sta[$i]=1
    else
        echo -n -e "$p_p\tOK \t$usage_percentage% \t$available\n"
        sta[$i]=0
    fi
done
n=0
for j in `seq 2 $row`
do
#    echo "$j EMMA: ${sta[$j]}"
    if [ "${sta[$j]}" -gt $n  ]
    then
        n=${sta[$j]}
    fi
done
# echo "n is $n"
exit $n
