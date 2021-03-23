#!/bin/bash

if [[ "$(basename $(pwd))" != "signaling-dockerized" ]]
then
	echo "Please enter the signaling-dockerized directory first!"
	exit 1
fi

# basedir
chown 0:0 . fixPermissions.sh
chmod 0700 . fixPermissions.sh

# caddy
chown 1500:0 caddy/Caddyfile
chmod 0640 caddy/Caddyfile

# coturn
chown 100:0 coturn/turnserver.conf
chmod 0640 coturn/turnserver.conf

# janus
chown 1500:0 janus/janus.*
chmod 0640 janus/janus.*

# nats
chown 1500:0 nats/gnatsd.conf
chmod 0640 nats/gnatsd.conf

# signaling
chown 1500:0 signaling/server.conf signaling/nextcloud.conf
chmod 0640 signaling/server.conf signaling/nextcloud.conf
