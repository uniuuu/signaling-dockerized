#!/bin/ash

sudo /bin/chown -R 1500:0 /data/

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
