#!/bin/bash
for ip in `cat ip.list`
do
    echo $ip
    ./rsync.expect $ip list.txt
done
