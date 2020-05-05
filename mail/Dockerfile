ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

ARG BUILD_ARCH

# Install mailserver
RUN apk add --no-cache \
    mariadb-client \
	nginx \ 
	php7-fpm \
	php7-cli \
	php7-imap \
	php7-session \
	php7-json \
	php7-opcache \
	php7-mbstring \
    php7-mysqli \
    postfix \
	postfix-mysql \
	dovecot \
	dovecot-lmtpd \
	dovecot-mysql \
	dovecot-pigeonhole-plugin \
	rspamd-client@edge=2.5-r3 \
    && curl -L -s -o postfixadmin.tar.gz "https://github.com/postfixadmin/postfixadmin/archive/postfixadmin-3.2.3.tar.gz"; \
	mkdir /var/www/postfixadmin; \
	tar -xf postfixadmin.tar.gz -C /var/www/postfixadmin --strip-components=1; \
	rm postfixadmin.tar.gz; \
	# Does not exist in tarball but is required
    mkdir -p /var/www/postfixadmin/templates_c; \
    chown -R nginx: /var/www/postfixadmin; \
	mkdir -p /etc/postfix/sql \
    && rm -f -r \
    /tmp/* \
	&& S6_ARCH="${BUILD_ARCH}" \
    && if [ "${BUILD_ARCH}" = "i386" ]; then S6_ARCH="x86"; fi \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then S6_ARCH="arm"; fi \
	&& curl -L -s "https://github.com/just-containers/socklog-overlay/releases/download/v3.1.0-2/socklog-overlay-${S6_ARCH}.tar.gz" \
        | tar zxvf - -C /;
# Copy data for add-on
COPY rootfs /
