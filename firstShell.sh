#!/bin/bash
# First shell script written by Conanin.  2016-01-04.
# $0	命令本身
# $1	命令第一个参数。
# $2  命令第二个参数。
# $#	一共使用了几个参数
echo "\$1=$1"
echo "\$2=$2"
echo "\$#=$#"
echo "\$0=$0"
echo "Hello World!"
# 数学运算。
a=1;b=2
c=$[$a+$b]
echo 'c='$c
read -p 'please input one number:  ' str
# echo $str
value=`echo $str | grep -E [^0-9]|wc -l`
if [ $value -eq 1 ]
then
    echo $str 'is not valid number'
    exit 1
fi

num=$[$str%2]
if [ $num -eq 0 ]
then
   echo '$str is even'
else
   echo '$str is odd.'
fi
