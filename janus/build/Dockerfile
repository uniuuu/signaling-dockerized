FROM ubuntu:20.04

# pre-configure Timezone, install updates and install janus
ENV DEBIAN_FRONTEND=noninteractive
ADD https://packaging.gitlab.io/janus/gpg.key /etc/apt/trusted.gpg.d/janus.asc
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && \
    echo "$TZ" > /etc/timezone && \
    chmod 444 /etc/apt/trusted.gpg.d/janus.asc && \
    apt-get update && \
    apt-get upgrade -y --no-install-recommends --no-install-suggests && \
    apt-get install -y --no-install-recommends --no-install-suggests netcat-openbsd ca-certificates && \
    . /etc/lsb-release && \
    echo "deb [arch=amd64] https://packaging.gitlab.io/janus/$DISTRIB_CODENAME $DISTRIB_CODENAME main" | tee /etc/apt/sources.list.d/janus.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests lua-json lua-ansicolors janus && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --gecos '' --disabled-password --uid 1500 --system --no-create-home janus

# install entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chown janus:root /entrypoint.sh && \
    chmod 500 /entrypoint.sh
USER janus
ENTRYPOINT [ "/entrypoint.sh" ]
HEALTHCHECK --interval=30s --timeout=4s CMD nc -z localhost 8188 || exit 1
