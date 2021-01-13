FROM caddy:latest

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache sudo

COPY entrypoint.sh /entrypoint.sh
RUN adduser -g '' -h / -s /bin/ash -H -D -u 1500 caddy && \
    chown root:caddy -R /entrypoint.sh && \
    chmod 650 /entrypoint.sh

COPY sudoers /etc/sudoers
RUN chown root:root /etc/sudoers && \
    chmod 640 /etc/sudoers

USER caddy

ENV XDG_CONFIG_HOME /config
ENV XDG_DATA_HOME /data

ENTRYPOINT [ "/entrypoint.sh" ]
