#!/bin/bash
num=$[$RANDOM%100]
echo $num
while :
do
    read -p "Please input a number: " input
    num2=$( echo $input | sed 's/[0-9]//g' )
    echo $num2

    if [ ! -z $num2 ]
    then
        echo "Your input is not a number, please try again."
        continue

    else
        if [[ $num2 -eq $num ]]
        then
            echo "Your input is right."
            break
        elif [[ $num2 -gt $num ]]
        then
            echo "input is bigger."
            continue
        else
            echo "input is smaller."
            continue
        fi
     fi
done
