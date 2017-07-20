#! /bin/ash

on_terminate () {
    for svc in $(ls -d /etc/service/*); do
        sv stop $svc
    done
}

trap "on_terminate; exit" SIGTERM
runsvdir /etc/service &
wait
