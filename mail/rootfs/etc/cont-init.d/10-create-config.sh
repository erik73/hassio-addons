#!/usr/bin/with-contenv bashio
# ==============================================================================
# Home Assistant Add-on: Mailserver
# Configures mailserver
# ==============================================================================

export host
export password
export port
export username
export database

host=$(bashio::services "mysql" "host")
password=$(bashio::services "mysql" "password")
port=$(bashio::services "mysql" "port")
username=$(bashio::services "mysql" "username")
relayhost=$(bashio::config 'smtp_relayhost')
postfixadmin=$(bashio::config 'admin_user')
postfixpassword=$(bashio::config 'admin_password')
domain=$(bashio::config 'domain_name')

chmod +x /usr/local/bin/quota-warning.sh
chown vmail:dovecot /etc/dovecot/users
chmod 440 /etc/dovecot/users

# Ensures the data of the Postfix and Dovecot is stored outside of the container
if ! bashio::fs.directory_exists '/data/mail'; then
    mkdir -p /data/mail
fi
addgroup vmail
rm -fr /var/mail
ln -s /data/mail /var/mail
mkdir -p /var/mail/vmail/sieve/global
chown -R vmail:postdrop /var/mail
mkdir -p /var/www/postfixadmin/templates_c; \
chown -R nginx: /var/www/postfixadmin; \

# Modify config files
sed -i 's/^user .*$/user = '$username'/' /etc/postfix/sql/*.cf
sed -i 's/^password .*$/password = '$password'/' /etc/postfix/sql/*.cf
sed -i 's/^hosts .*$/hosts = '$host'/' /etc/postfix/sql/*.cf
sed -i 's/^connect .*$/connect = host='$host' dbname=postfixadmin user='$username' password='$password'/' /etc/dovecot/*.ext
sed -i "s/postmaster_address = postmaster/postmaster_address = postmaster@${domain}/g" /etc/dovecot/conf.d/20-lmtp.conf
sed -i "s/From: postmaster/From: postmaster@${domain}/g" /usr/local/bin/quota-warning.sh
sed -i "s/@domain/@${domain}/g" /var/www/postfixadmin/config.local.php
sed -i "s/relayhost =/relayhost = ${relayhost}/g" /etc/postfix/main.cf
sed -i "s/myhostname =/myhostname = ${domain}/g" /etc/postfix/main.cf

database=$(\
    mysql \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
        --skip-column-names \
        -e "SHOW DATABASES LIKE 'postfixadmin';"
)

if ! bashio::var.has_value "${database}"; then
    bashio::log.info "Creating database for postfixadmin"
    mysql \
        -u "${username}" -p"${password}" \
        -h "${host}" -P "${port}" \
            < /etc/postfix/createdb.sql
php /var/www/postfixadmin/public/upgrade.php
/var/www/postfixadmin/scripts/postfixadmin-cli admin add ${postfixadmin}@${domain} --superadmin 1 --active 1 --password ${postfixpassword} --password2 ${postfixpassword}
/var/www/postfixadmin/scripts/postfixadmin-cli domain add ${domain}
fi

newaliases

#Remove old sieve files so that we always have the correct ones

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
fi
