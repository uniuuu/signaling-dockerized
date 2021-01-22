FROM nats:alpine

# install updates
RUN apk update && \
    apk upgrade --no-cache

# fix permissions and ownerships
RUN adduser -g '' -h / -s /bin/ash -H -D -u 1500 nats && \
    chown root:nats /etc/nats/nats-server.conf /usr/local/bin/docker-entrypoint.sh && \
    chmod 640 /etc/nats/nats-server.conf && \
    chmod 750 /usr/local/bin/docker-entrypoint.sh

USER nats
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["nats-server", "--config", "/etc/nats/nats-server.conf"]
HEALTHCHECK --interval=30s --timeout=4s CMD nc -z localhost 4222 || exit 1
