<?php
$CONF['configured'] = true;

$CONF['database_type'] = 'mysqli';
$CONF['database_host'] = getenv("SERVICE_HOST");
$CONF['database_user'] = getenv("SERVICE_USERNAME");
$CONF['database_password'] = getenv("SERVICE_PASSWORD");
$CONF['database_port'] = getenv("SERVICE_PORT");
$CONF['database_name'] = 'postfixadmin';

$CONF['default_aliases'] = array (
  'abuse'      => 'abuse@hilton.zapto.org',
  'hostmaster' => 'hostmaster@hilton.zapto.org',
  'postmaster' => 'postmaster@hilton.zapto.org',
  'webmaster'  => 'webmaster@hilton.zapto.org'
);

$CONF['fetchmail'] = 'NO';
$CONF['show_footer_text'] = 'NO';

$CONF['quota'] = 'YES';
$CONF['domain_quota'] = 'YES';
$CONF['quota_multiplier'] = '1024000';
$CONF['used_quotas'] = 'YES';
$CONF['new_quota_table'] = 'YES';

$CONF['aliases'] = '0';
$CONF['mailboxes'] = '0';
$CONF['maxquota'] = '0';
$CONF['domain_quota_default'] = '0';
?>
