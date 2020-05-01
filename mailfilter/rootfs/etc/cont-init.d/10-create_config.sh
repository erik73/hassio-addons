#!/usr/bin/with-contenv bashio

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
if bashio::config.false "enable_antivirus"; then
    rm -fr /etc/services.d/clamav
    rm -fr /etc/services.d/freshclam
fi
    mkdir /run/clamav
    chown clamav:clamav /run/clamav
    ln -s /data/lib/clamav /var/lib/clamav
    chown clamav:clamav /var/lib/clamav
    mkdir /run/rspamd
if bashio::config.true "enable_antivirus"; then
    sed -i '1d' /etc/rspamd/local.d/antivirus.conf
    bashio::log.info "Updating antivirus patterns"
    freshclam >/dev/null 2>&1
fi