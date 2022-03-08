FROM debian:bullseye-slim AS build

RUN apt-get -y update && \
	apt-get install -y \
		libavutil-dev \
		libavformat-dev \
		libavcodec-dev \
		libmicrohttpd-dev \
		libjansson-dev \
		libssl-dev \
		libsofia-sip-ua-dev \
		libglib2.0-dev \
		libopus-dev \
		libogg-dev \
		libcurl4-openssl-dev \
		liblua5.3-dev \
		libconfig-dev \
		libusrsctp-dev \
		libwebsockets-dev \
		libnanomsg-dev \
		librabbitmq-dev \
		pkg-config \
		gengetopt \
		libtool \
		automake \
		build-essential \
		wget \
		git \
		gtk-doc-tools


RUN cd /tmp && \
	wget https://github.com/cisco/libsrtp/archive/v2.3.0.tar.gz && \
	tar xfv v2.3.0.tar.gz && \
	cd libsrtp-2.3.0 && \
	./configure --prefix=/usr --enable-openssl && \
	make shared_library && \
	make install

# Install build dependencies of libnice
RUN \
  apt-get update && \
  apt-get install -y \
          libssl-dev \
    libglib2.0-dev \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    ninja-build \
    gtk-doc-tools && \
  pip3 install meson

# Build libnice from sources as one shipped with ubuntu is a bit outdated
RUN \
  cd /tmp && \
  git clone --branch 0.1.18 https://gitlab.freedesktop.org/libnice/libnice.git && \
  cd libnice && \
  meson builddir && \
  ninja -C builddir && \
  ninja -C builddir install

RUN cd /tmp && \
	git clone https://github.com/meetecho/janus-gateway && \
        cd janus-gateway && \
        git checkout tags/v1.0.0 -b v1.0.0 && \
	/tmp/janus-gateway/autogen.sh && \
	/tmp/janus-gateway/configure --enable-post-processing --disable-rabbitmq --prefix=/usr/local && \
	make && \
	make install && \
	make configs

RUN	apt-get clean && \
	rm -rf /var/lib/apt/lists/*


FROM debian:bullseye-slim

RUN apt-get -y update && \
	apt-get install -y \
		libmicrohttpd12 \
		libavutil-dev \
		libavformat-dev \
		libavcodec-dev \
		libjansson4 \
		libssl1.1 \
		libsofia-sip-ua0 \
		libglib2.0-0 \
		libopus0 \
		libogg0 \
		libcurl4 \
		liblua5.3-0 \
		libconfig9 \
		libusrsctp1 \
		libwebsockets16 \
		libwebsockets-dev \
		libnanomsg5 \
		librabbitmq4 && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*


# Copy all built packages
COPY --from=build /usr/local /usr/local
COPY --from=build /usr/lib/libsrtp2.so.1 /usr/lib/libsrtp2.so.1
RUN ln -s /usr/lib/libsrtp2.so.1 /usr/lib/libsrtp2.so
COPY --from=build /usr/local/lib/x86_64-linux-gnu/libnice.so.10.11.0 /usr/lib/libnice.so.10.11.0
RUN ln -s /usr/lib/libnice.so.10.11.0 /usr/lib/libnice.so.10
RUN ln -s /usr/lib/libnice.so.10.11.0 /usr/lib/libnice.so


RUN adduser --gecos '' --disabled-password --uid 1500 --system --no-create-home janus

# install entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chown janus:root /entrypoint.sh && \
    chmod 500 /entrypoint.sh
RUN mkdir -p /usr/local/share/janus/demos/voicemail/ && chown -R janus:root /usr/local/share/janus/demos/voicemail/
RUN mkdir -p /usr/local/lib/janus/loggers && chown -R janus:root /usr/local/lib/janus/loggers
USER janus
ENTRYPOINT [ "/entrypoint.sh" ]
HEALTHCHECK --interval=30s --timeout=4s CMD nc -z localhost 8188 || exit 1
