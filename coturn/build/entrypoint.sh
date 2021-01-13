#!/bin/ash

cp /etc/turnserver.conf.template /turntmp/turnserver.conf

sed -i "s|TURNAPIKEY|${TURN_API_KEY}|g" /turntmp/turnserver.conf
sed -i "s|SIGNALINGDOMAIN|${SIGNALING_HOSTNAME}|g" /turntmp/turnserver.conf

turnserver -c /turntmp/turnserver.conf
