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

if ! bashio::fs.file_exists '/var/mail/vmail/sieve/global/spam-global.sieve'; then
cat << EOF >> /var/mail/vmail/sieve/global/spam-global.sieve
require ["fileinto","mailbox"];

if anyof(
    header :contains ["X-Spam-Flag"] "YES",
    header :contains ["X-Spam"] "Yes",
    header :contains ["Subject"] "*** SPAM ***"
    )
{
    fileinto :create "Spam";
    stop;
}
EOF

  cat << EOF >> /var/mail/vmail/sieve/global/report-spam.sieve
require ["vnd.dovecot.pipe", "copy", "imapsieve"];
pipe :copy "rspamc" ["learn_spam"];
EOF

  cat << EOF >> /var/mail/vmail/sieve/global/report-ham.sieve
require ["vnd.dovecot.pipe", "copy", "imapsieve"];
pipe :copy "rspamc" ["learn_ham"];
EOF

chown -R vmail:postdrop /var/mail/

fi

if bashio::config.false "enable_antivirus"; then
  rm -f -r \
  /etc/services.d/freshclam \
  /etc/services.d/clamav \
  /etc/services.d/rspamd \
  /etc/services.d/redis-server \
  /etc/dovecot/conf.d/20-managesieve.conf \
  /etc/dovecot/conf.d/90-sieve.conf
fi

if bashio::config.true "enable_antivirus"; then
    bashio::log.info "Antivirus enabled. Setting up ClamAV and Postfix"
    cat << EOF >> /etc/postfix/main.cf
milter_protocol = 6
milter_mail_macros = i {mail_addr} {client_addr} {client_name} {auth_authen}
milter_default_action = accept
smtpd_milters = inet:127.0.0.1:11332
non_smtpd_milters = inet:127.0.0.1:11332
EOF

    sed -i 's/^  mail.*/& sieve/' /etc/dovecot/conf.d/20-lmtp.conf
    sed -i 's/^  mail.*/& imap_sieve/' /etc/dovecot/conf.d/20-imap.conf
    mkdir -p /data/lib/rspamd
    mkdir -p /data/lib/redis
    mkdir -p /data/lib/clamav
    rm -fr /var/lib/rspamd
    rm -fr /var/lib/redis
    rm -fr /var/lib/clamav
    ln -s /data/lib/rspamd /var/lib/rspamd
    ln -s /data/lib/redis /var/lib/redis
    chown rspamd:rspamd /var/lib/rspamd
    chown redis:redis /var/lib/redis
    # Disable DKIM Signing
    # mkdir -p /var/lib/rspamd/dkim/
    # chown rspamd:rspamd /var/lib/rspamd/dkim
    # rspamadm dkim_keygen -b 2048 -s mail -k /var/lib/rspamd/dkim/mail.key | tee -a  /var/lib/rspamd/dkim/mail.pub
    # chown -R rspamd:rspamd /var/lib/rspamd/dkim
    mkdir /run/clamav
    chown clamav:clamav /run/clamav
    ln -s /data/lib/clamav /var/lib/clamav
    chown clamav:clamav /var/lib/clamav
    mkdir /run/rspamd
    bashio::log.info "Updating antivirus patterns"
    freshclam >/dev/null 2>&1
fi