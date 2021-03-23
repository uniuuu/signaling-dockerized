FROM alpine:3.13

# update packages and install coturn + sed
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache coturn sed

# install entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chown root:turnserver /entrypoint.sh && \
    chmod 650 /entrypoint.sh
USER turnserver
ENTRYPOINT [ "/entrypoint.sh" ]
HEALTHCHECK --interval=30s --timeout=4s CMD nc -z localhost 3478 || exit 1
