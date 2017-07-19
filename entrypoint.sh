#! /bin/bash

function on-terminate () {
    for svc in $(ls -d /etc/service/*); do
        sv stop $svc
    done
}

trap "on-terminate; exit" SIGTERM
runsvdir /etc/service &
wait
