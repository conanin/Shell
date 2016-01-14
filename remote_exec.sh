#!/bin/bash
for ip in `cat ip.list`
do
    echo $ip
    ./remote_exec.expect $ip "w;free -m; ls /tmp"
    
done
