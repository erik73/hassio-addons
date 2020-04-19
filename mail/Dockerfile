ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

# Install mailserver
RUN apk add --no-cache \
    mariadb-client \
	nginx \ 
	php7-fpm \
	php7-cli \
	php7-imap \
	php7-session \
	php7-curl \
	php7-json \
	php7-opcache \
	php7-mbstring \
    php7-mysqli \
	php7-gd \
	php7 \
    postfix \
	postfix-mysql \
	dovecot \
	dovecot-lmtpd \
	dovecot-mysql \
    && curl -L -s -o postfixadmin.tar.gz "https://github.com/postfixadmin/postfixadmin/archive/postfixadmin-3.2.3.tar.gz"; \
	mkdir /var/www/postfixadmin; \
	tar -xf postfixadmin.tar.gz -C /var/www/postfixadmin --strip-components=1; \
	rm postfixadmin.tar.gz; \
	# Does not exist in tarball but is required
        mkdir -p /var/www/postfixadmin/templates_c; \
        chown -R nginx: /var/www/postfixadmin; \
        addgroup vmail; \
	mkdir -p /etc/postfix/sql \
    && rm -f -r \
        /tmp/* 

# Copy data for add-on
COPY rootfs /
