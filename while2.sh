#!/bin/bash
while :
do
    read -p "Please input a number: " n
    # 判断输入是否为空
    if [ -z $n ]
    then
        echo "Attention: Please input a number. Please try again. "
        continue
    fi
    n1=`echo $n|sed 's/[-0-9]//g'`
    # 判断输入是否为纯数字
    if [ ! -z $n1 ]
    then
        echo "Attention: Please input a number. Please try again. "
        continue
    fi
    break
done
echo "Hello World"
