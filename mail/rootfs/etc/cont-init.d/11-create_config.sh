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

#Reove old sieve files so that we always have the correct ones

rm -f /var/mail/vmail/sieve/global/*

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
pipe :copy "rspamc" ["-h", "32b8266a-mailfilter:11334", "learn_ham"];
EOF

  cat << EOF >> /var/mail/vmail/sieve/global/report-ham.sieve
require ["vnd.dovecot.pipe", "copy", "imapsieve"];
pipe :copy "rspamc" ["-h", "32b8266a-mailfilter:11334", "learn_ham"];
EOF

chown -R vmail:postdrop /var/mail/

fi

if bashio::config.false "enable_mailfilter"; then
  rm -f -r \
  /etc/dovecot/conf.d/20-managesieve.conf \
  /etc/dovecot/conf.d/90-sieve.conf
fi

if bashio::config.true "enable_mailfilter"; then
    bashio::log.info "Mailfilter enabled."
    bashio::log.info "Configuring connection to Mailfilter addon"
    cat << EOF >> /etc/postfix/main.cf
milter_protocol = 6
milter_mail_macros = i {mail_addr} {client_addr} {client_name} {auth_authen}
milter_default_action = accept
smtpd_milters = inet:32b8266a-mailfilter:11332
non_smtpd_milters = inet:32b8266a-mailfilter:11332
EOF

    sed -i 's/^  mail.*/& sieve/' /etc/dovecot/conf.d/20-lmtp.conf
    sed -i 's/^  mail.*/& imap_sieve/' /etc/dovecot/conf.d/20-imap.conf
    # Disable DKIM Signing
    # mkdir -p /var/lib/rspamd/dkim/
    # chown rspamd:rspamd /var/lib/rspamd/dkim
    # rspamadm dkim_keygen -b 2048 -s mail -k /var/lib/rspamd/dkim/mail.key | tee -a  /var/lib/rspamd/dkim/mail.pub
    # chown -R rspamd:rspamd /var/lib/rspamd/dkim

fi