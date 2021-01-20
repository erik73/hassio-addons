ARG BUILD_FROM=ghcr.io/hassio-addons/base/amd64:9.0.1
FROM ${BUILD_FROM}

ARG JEMALLOC_VERSION
ARG BUILD_ARCH

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Setup base
RUN apk add --no-cache \
    nginx \ 
    clamav-libs \
    freshclam \
    clamav-scanner \
    clamav-daemon \
    clamav \
    clamav-libunrar \
    redis \
    libsodium \
    sqlite-libs \
    glib \
    icu-libs \
    lua5.1 \
&& apk add --no-cache --virtual .build-dependencies \
    build-base \
    cmake \
    curl-dev \
    file-dev \
    gd-dev \
    glib-dev \
    icu-dev \
    libsodium-dev \
    openssl-dev \
    pcre2-dev \
    perl \
    ragel \
    sqlite-dev \
    lua5.1-dev \
    git \
    && mkdir -p /usr/src \
    && curl -L -s https://github.com/jemalloc/jemalloc/releases/download/${JEMALLOC_VERSION}/jemalloc-${JEMALLOC_VERSION}.tar.bz2 | tar -xjf - -C /usr/src \
    && cd /usr/src/jemalloc-${JEMALLOC_VERSION} \
    && ./configure \
    && make \
    && make install \
    && cd /usr/src \
    && git clone -b 2.7 --recursive https://github.com/rspamd/rspamd \
    && cd rspamd \
    && cmake -DCMAKE_INSTALL_PREFIX= . -DENABLE_JEMALLOC=ON -DENABLE_LUAJIT=OFF \
    && make install \
    && apk del .build-dependencies \
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

# Build arguments
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Mailfilter" \
    io.hass.description="Mailfilter: Rspamd Mailfilter for Home Assistant" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Erik Hilton <erikhilton73@gmail.com>" \
    org.opencontainers.image.title="Mailfilter" \
    org.opencontainers.image.description="Mailfilter: Rspamd Mailfilter for Home Assistant" \
    org.opencontainers.image.vendor="Erik73 Hassio-Addons" \
    org.opencontainers.image.authors="Erik Hilton <erikhilton73@gmail.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}