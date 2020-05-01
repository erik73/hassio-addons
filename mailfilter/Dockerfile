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
	rspamd@edge=2.5-r3 \
	rspamd-controller@edge=2.5-r3 \
	rspamd-fuzzy@edge=2.5-r3 \
	rspamd-proxy@edge=2.5-r3 \
	rspamd-client@edge=2.5-r3 \
    && rm -f -r \
    /tmp/* \
	&& S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
	&& curl -L -s "https://github.com/just-containers/socklog-overlay/releases/download/v3.1.0-2/socklog-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C /;
# Copy data for add-on
COPY rootfs /
