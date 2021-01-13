FROM alpine:3.12

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
