ARG BUILD_FROM=hassioaddons/base:7.1.1
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

ARG BUILD_ARCH
ARG JEMALLOC_VERSION

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base system
ARG BUILD_ARCH=amd64


# Install mailserver
RUN apk add --no-cache \
        luarocks \
		nginx \ 
		clamav \
		clamav-libunrar \
		redis \
		libsodium \
		lua5.1 \
		sqlite-libs \
		glib \
		icu-libs \
		libssl1.1=1.1.1g-r0 \
		libcrypto1.1=1.1.1g-r0 \
    && apk add --no-cache --virtual .build-dependencies \
		build-base \
		cmake \
		curl-dev \
		file-dev \
		gd-dev \
		glib-dev \
		lua5.1-dev \
		icu-dev \
		libsodium-dev \
		openssl-dev=1.1.1g-r0 \
		pcre2-dev \
		perl \
		ragel \
		sqlite-dev \
		git \
    && mkdir -p /usr/src \
    && curl -L -s https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2 | tar -xjf - -C /usr/src \
    && cd /usr/src/jemalloc-${JEMALLOC_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd /usr/src \
    && git clone -b 2.5 --recursive https://github.com/rspamd/rspamd \
    && cd rspamd \
    && cmake -DCMAKE_INSTALL_PREFIX= . -DENABLE_JEMALLOC=ON \
    && make install \
    && apk del .build-dependencies \
    && rm -rf /usr/src/rspamd \
    && cd / \
    && rm -f -r \
    /tmp/* \
    /usr/src/rspamd \
    /usr/src/jemalloc-${JEMALLOC_VERSION} \
    && S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
	&& curl -L -s "https://github.com/just-containers/socklog-overlay/releases/download/v3.1.0-2/socklog-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C /;
ENV LD_PRELOAD="/usr/local/lib/libjemalloc.so.2"
# Copy data for add-on
COPY rootfs /
