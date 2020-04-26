#!/usr/bin/with-contenv bashio

export SERVICE_HOST
export SERVICE_PASSWORD
export SERVICE_PORT
export SERVICE_USERNAME

SERVICE_HOST=$(bashio::services "mysql" "host")
SERVICE_PASSWORD=$(bashio::services "mysql" "password")
SERVICE_PORT=$(bashio::services "mysql" "port")
SERVICE_USERNAME=$(bashio::services "mysql" "username")

domain=$(bashio::config 'domain_name')
relayhost=$(bashio::config 'smtp_relayhost')

sed -i 's/^user .*$/user = '$SERVICE_USERNAME'/' /etc/postfix/sql/*.cf
sed -i 's/^password .*$/password = '$SERVICE_PASSWORD'/' /etc/postfix/sql/*.cf
sed -i 's/^hosts .*$/hosts = '$SERVICE_HOST'/' /etc/postfix/sql/*.cf
sed -i 's/^connect .*$/connect = host='$SERVICE_HOST' dbname=postfixadmin user='$SERVICE_USERNAME' password='$SERVICE_PASSWORD'/' /etc/dovecot/*.ext

sed -i "s/postmaster_address = postmaster/postmaster_address = postmaster@${domain}/g" /etc/dovecot/conf.d/20-lmtp.conf
sed -i "s/From: postmaster/From: postmaster@${domain}/g" /usr/local/bin/quota-warning.sh
sed -i "s/@domain/@${domain}/g" /var/www/postfixadmin/config.local.php
sed -i "s/relayhost =/relayhost = ${relayhost}/g" /etc/postfix/main.cf
sed -i "s/myhostname =/myhostname = ${domain}/g" /etc/postfix/main.cf

newaliases

if bashio::config.false "enable_antivirus"; then
  rm -f -r \
  /etc/services.d/freshclam \
  /etc/services.d/clamd \
  /etc/services.d/clamsmtpd
fi

if bashio::config.true "enable_antivirus"; then
    bashio::log.info "Antivirus enabled. Setting up ClamAV and Postfix"
    cat << EOF >> /etc/postfix/main.cf
content_filter = scan:127.0.0.1:10025
receive_override_options = no_address_mappings
EOF

    cat << EOF >> /etc/postfix/master.cf
# AV scan filter (used by content_filter)
scan      unix  -       -       n       -       16      smtp
  -o smtp_send_xforward_command=yes
# For injecting mail back into postfix from the filter
127.0.0.1:10026 inet  n -       n       -       16      smtpd
  -o content_filter=
  -o receive_override_options=no_unknown_recipient_checks,no_header_body_checks
  -o smtpd_helo_restrictions=
  -o smtpd_client_restrictions=
  -o smtpd_sender_restrictions=
  -o smtpd_recipient_restrictions=permit_mynetworks,reject
  -o mynetworks_style=host
  -o smtpd_authorized_xforward_hosts=127.0.0.0/8
EOF
    mkdir /run/clamav
    chown clamav:clamav /run/clamav
    bashio::log.info "Updating antivirus patterns"
    freshclam >/dev/null 2>&1
fi