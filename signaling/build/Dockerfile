# Build the spreed-backend
From golang:alpine AS builder

# install updates
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache --upgrade make bash git

# get the current signaling release and unpack it
WORKDIR /workdir
#RUN wget https://github.com/strukturag/nextcloud-spreed-signaling/releases/download/v0.2.0/nextcloud-spreed-signaling-v0.2.0.tar.gz
#RUN tar xf nextcloud-spreed-signaling-v0.2.0.tar.gz
#WORKDIR /workdir/nextcloud-spreed-signaling-v0.2.0

# compile signaling backend and performance test client
RUN git clone https://github.com/strukturag/nextcloud-spreed-signaling.git
WORKDIR /workdir/nextcloud-spreed-signaling
RUN make build && \
    make client

# run the spreed-backend
FROM alpine:3.12

# install updates
RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache ca-certificates libc6-compat libstdc++

# copy dependencies in image
COPY --from=builder /workdir/nextcloud-spreed-signaling/bin/signaling /usr/local/signaling
COPY --from=builder /workdir/nextcloud-spreed-signaling/bin/client /usr/local/signaling-client
COPY entrypoint.sh /entrypoint.sh

# fix permissions and ownership
RUN adduser -D -H -s /bin/ash -g '' -u 1500 spreedbackend && \
    chown root:spreedbackend /usr/local/signaling /usr/local/signaling-client && \
    chmod 650 /usr/local/signaling /usr/local/signaling-client && \
    chmod 655 /entrypoint.sh

USER spreedbackend

ENTRYPOINT [ "/entrypoint.sh" ]
