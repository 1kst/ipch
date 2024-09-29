#!/bin/bash

ADDR="qq.com"
TMPSTR=$(ping -c 1 ${ADDR} | sed '1{s/[^(]*(//;s/).*//;q}')
ports=(22 80 443) # 添加你想要监测的端口 多个端口用空格
check_ip=0

for port in ${ports[@]}
do
    for i in {1..3}
    do
        check=$(nmap ${TMPSTR} -p $port | grep open | wc -l)
        if [ $check -eq 1 ]; then 
            check_ip=1
            break
        fi
        sleep 10
    done
    if [ $check_ip -eq 1 ]; then 
        break
    fi
done

if [ $check_ip -eq 0 ]; then 
    echo "Ports are not open. Triggering curl."
    curl "https://api.pqs.pw/ipch/********" >/dev/null 2>&1 &
    nscd -i hosts
    nscd -i passwd
    nscd -i group
    /etc/init.d/nscd restart
fi

echo "IP Address: ${TMPSTR}"
