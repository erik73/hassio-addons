#!/bin/sh
PERCENT=$1
USER=$2
cat << EOF | /usr/libexec/dovecot/dovecot-lda -d $USER -o "log_path=/proc/1/fd/2" -o "info_log_path=/proc/1/fd/1" -o "plugin/quota=dict:User quota::noenforcing:proxy::sqlquota"
From: postmaster
Subject: Quota warning

Your mailbox is now $PERCENT% full.
EOF