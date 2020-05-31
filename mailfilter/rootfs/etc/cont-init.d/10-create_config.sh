#!/usr/bin/with-contenv bashio

    addgroup -S rspamd
    adduser -S -D -H -G rspamd rspamd
    mkdir -p /data/lib/rspamd
    mkdir -p /data/lib/redis
    mkdir -p /data/lib/clamav
    rm -fr /var/lib/rspamd
    rm -fr /var/lib/redis
    rm -fr /var/lib/clamav
    ln -s /data/lib/rspamd /var/lib/rspamd
    ln -s /data/lib/redis /var/lib/redis
    chown -R rspamd:rspamd /var/lib/rspamd/
    chown -R redis:redis /var/lib/redis/
    mkdir /run/clamav
    chown -R clamav:clamav /run/clamav
    ln -s /data/lib/clamav /var/lib/clamav
    chown -R clamav:clamav /var/lib/clamav/
    mkdir /run/rspamd
    
    # Disable DKIM Signing
    # mkdir -p /var/lib/rspamd/dkim/
    # chown rspamd:rspamd /var/lib/rspamd/dkim
    # rspamadm dkim_keygen -b 2048 -s mail -k /var/lib/rspamd/dkim/mail.key | tee -a  /var/lib/rspamd/dkim/mail.pub
    # chown -R rspamd:rspamd /var/lib/rspamd/dkim

#Create rspamd encrypted password and set listening IP
rspamdpw="$(date | md5sum)"
encryptedpw="$(rspamadm pw --encrypt -p ${rspamdpw})"
encryptedenpw="$(rspamadm pw --encrypt -p ${rspamdpw})"
myip="$(ip route get 1 | awk '{print $NF;exit}')"
sed -i "4 s/password = /password = "${encryptedpw}";/g" /etc/rspamd/local.d/worker-controller.inc
sed -i "5 s/enable_password = /enable_password = "${encryptedenpw}";/g" /etc/rspamd/local.d/worker-controller.inc
sed -i '2 s/^bind.*$/bind_socket = "'${myip}:11332'";/g' /etc/rspamd/local.d/worker-proxy.inc

#Remove antivirus service files if disabled
if bashio::config.false "enable_antivirus"; then
    rm -fr /etc/services.d/clamav
    rm -fr /etc/services.d/freshclam
fi

if bashio::config.true "enable_antivirus"; then
    sed -i '1d' /etc/rspamd/local.d/antivirus.conf
    bashio::log.info "Updating antivirus patterns"
    freshclam
fi