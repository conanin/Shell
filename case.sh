#!/bin/bash
read -p "Please input a number: " n
if [ -z $n ]
then
    echo "Please input a number"
    exit 1
fi
n1=`echo $n|sed 's/[-0-9]//g'`
if [ ! -z $n1 ]
then
    echo "please input a number." 
    exit 1
elif [ $n -lt 0 ] || [ $n -gt 100 ]
then
    echo "The input must be in the range 0-100".
    exit 1
fi

if [ $n -lt 60 ]
then
    flag=1
elif [ $n -ge 60 ] && [ $n -lt 80 ]
then
    flag=2
elif [ $n -ge 80 ] && [ $n -lt 90 ]
then
    flag=3
else
    flag=4
fi

n2=$[$n%2]

case $flag in
    1)
        echo "不及格"
        ;;
    2)
        echo "及格"
        ;;
    3) 
        echo "良好"
        ;;
    4)
        echo "优秀"
        ;;
    *)
        echo "Please input a number"
        ;;
esac
