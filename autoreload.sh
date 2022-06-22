#!/bin/bash
time_total=0
function list {
    file_list=''
    cd /etc/nginx/conf.d
    file_list="$(ls *.conf|sort)"
    echo $file_list
}

function list_date {
    file_list=''
    cd /etc/nginx/conf.d
    file_list="$(ls --full-time|grep nginx.conf$)"
    file_list2="$(ls --full-time *.conf)"
    file_list="$file_list $file_list2"
    echo $file_list
}

list_info=$(list)
list_info_date=$(list_date)
while :
do
    sleep 3
    list_info_new=$(list)
    if [ "$list_info" != "$list_info_new" ]; then
        echo "new file!"
        while :
        do
            nginx -t && nginx -s stop && break
            sleep 2
        done
        list_info=$(list)
    else
        echo "not change."
    fi

    list_info_new=$(list_date)
    if [ "$list_info_date" != "$list_info_new" ]; then
        echo "file change!"
        while :
        do
            nginx -t && nginx -s reload && break
            sleep 2
        done
        list_info_date=$(list_date)
    else
        echo "not change."
    fi
done
