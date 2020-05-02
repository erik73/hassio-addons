ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ARG BUILD_ARCH

# Install mailserver
RUN apk add --no-cache \
	nginx \ 
	clamav \
	clamav-libunrar \
	redis@edge=5.0.9-r0 \
	rspamd \
	rspamd-controller \
	rspamd-fuzzy \
	rspamd-proxy \
	rspamd-client \
    && rm -f -r \
    /tmp/* \
	&& S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
	&& curl -L -s "https://github.com/just-containers/socklog-overlay/releases/download/v3.1.0-2/socklog-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C /;
# Copy data for add-on
COPY rootfs /
