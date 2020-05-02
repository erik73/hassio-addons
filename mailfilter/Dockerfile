ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ARG BUILD_ARCH

# Install mailserver
RUN apk add --no-cache \
        luarocks \
    && apk add --no-cache --virtual .build-dependencies \
		build-base \
		cmake \
		curl-dev \
		file-dev \
		gd-dev \
		glib-dev \
		icu-dev@edge \
		libevent-dev \
		libsodium-dev \
		openssl-dev \
		luajit-dev \
		pcre2-dev \
		perl \
		ragel \
		sqlite-dev \
		git \
    && mkdir -p /usr/src \
    && cd /usr/src \
    && git clone -b 2.5 --recursive https://github.com/rspamd/rspamd \
    && cd rspamd \
	&& make . \
    && make install \
    && apk del .build-dependencies \
    && rm -rf /usr/src/rspamd \
    && cd / \
    && rm -f -r \
    /tmp/* \
	&& S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
	&& curl -L -s "https://github.com/just-containers/socklog-overlay/releases/download/v3.1.0-2/socklog-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C /;
# Copy data for add-on
COPY rootfs /
