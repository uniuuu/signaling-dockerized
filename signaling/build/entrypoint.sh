#!/bin/ash

cp /etc/signaling/server.conf.template /config/server.conf

sed -i "s|TURNSECRET|${TURN_API_KEY}|g" /config/server.conf
sed -i "s|HASHKEY|${HASH_KEY}|g" /config/server.conf
sed -i "s|BLOCKKEY|${BLOCK_KEY}|g" /config/server.conf
sed -i "s|JANUSKEY|${JANUS_API_KEY}|g" /config/server.conf

cat /etc/signaling/nextcloud.conf.template >> /config/server.conf

/usr/local/signaling --config=/config/server.conf
