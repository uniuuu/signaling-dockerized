#!/bin/bash

# install configuration
cp /etc/janus/*.jcfg /janustmp/
cp /etc/janus/janus.jcfg.template /janustmp/janus.jcfg
chmod 640 /janustmp/*.jcfg

# fix parameters in config
sed -i "s|TURNAPIKEY|${TURN_API_KEY}|g" /janustmp/janus.jcfg
sed -i "s|SIGNALINGDOMAIN|${SIGNALING_HOSTNAME}|g" /janustmp/janus.jcfg
sed -i "s|JANUSSECRET|${JANUS_API_KEY}|g" /janustmp/janus.jcfg

janus -C /janustmp/janus.jcfg
