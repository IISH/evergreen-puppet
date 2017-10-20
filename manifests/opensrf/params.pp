class evergreen::opensrf::params() {
  $user                   = 'opensrf'
  $password               = 'opensrf'
  $home                   = '/home/opensrf/'
  $sysdir                 = '/openils'
  $public_ip              = '127.0.1.2'
  $private_ip             = '127.0.1.3'
  $public_hosts           = 'public.realm'
  $private_hosts          = 'private.realm'
  $max_user_sessions      = 10000
  $max_stanza_size        = 2000000
  $max_rate               = 500000
  $auth_password_format   = 'plain'
  $router_password        = 'router'
  $opensrf_user           = 'opensrf'
  $opensrf_password       = 'opensrf'
  $opensrf_host           = $::fqdn

  $proxy                  = 'http://localhost'
  $smtp_server            = 'localhost'
  $sender_address         = 'evergreen'

  $database_master_type     = 'master'
  $database_master_host     = 'localhost'
  $database_master_db       = 'evergreen'
  $database_master_user     = 'evergreen'
  $database_master_pw       = 'evergreen'
  $database_mirror_type     = 'mirror'
  $database_mirror_host     = 'localhost'
  $database_mirror_db       = 'evergreen'
  $database_mirror_user     = 'evergreen'
  $database_mirror_pw       = 'evergreen'


  $openils_cat_marctemplates = 'k_book'
  $openils_cat_marctemplates_folder         = 'templates'

  $oai = {
    base_url              => 'http://localhost/opac/extras/oai',
    repository_name       => 'Some organization' ,
    admin_email           => 'maintainer@localhost.org',
    max_count             => 100,
    deleted_record        => 'yes' ,
    repository_identifier => 'localhost' ,
    sample_identifier     => 'oai:localhost:12345',
    list_sets             => false
  }

  $handle = {
    endpoint            => 'http://localhost/',
    authorization       => 'bearer key',
    bind_url_available  => 'http://localhost/%',
    bind_url_deleted    => 'http://localhost/',
    timeout             => 5
  }

  $handlesystem_naming_authority = '12345'

  $openils_auth_proxy_enabled = false
  $authenticators         = [{ name=>'native' }]
  $reporter_output_base   = '/openils/var/web/reporter'

  $repository             = 'https://evergreen-ils.org/downloads/opensrf-2.5.2.tar.gz'
  $version                = '2.5.2'

  $register               = {
    admin => {
      username  => 'admin',
      host      => 'localhost',
      password  => 'admin',
      role      => 'admin'
    }
  }

  $memcached_l = '127.0.0.1'
  $memcached_m = '64'

  $enable_service         = true
  $enable_apache2         = true
  $enable_ejabberd        = true
  $enable_memcached       = true

  $activeapps             = [
    'opensrf.settings',
    'opensrf.math',
    'opensrf.dbmath',
    'open-ils.acq',
    'open-ils.booking',
    'open-ils.cat',
    'open-ils.supercat',
    'open-ils.search',
    'open-ils.circ',
    'open-ils.actor',
    'open-ils.auth',
    'open-ils.auth_internal',
    'open-ils.auth_proxy',
    'open-ils.storage',
    'open-ils.justintime',
    'open-ils.cstore',
    'open-ils.collections',
    'open-ils.reporter',
    'open-ils.reporter-store',
    'open-ils.permacrud',
    'open-ils.pcrud',
    'open-ils.trigger',
    'open-ils.url_verify',
    'open-ils.fielder',
    'open-ils.vandelay',
    'open-ils.serial',
    'open-ils.hold-targeter'
  ]

  $log_protect              = [
    'open-ils.auth.authenticate.verify',
    'open-ils.auth.authenticate.complete',
    'open-ils.auth_proxy.login',
    'open-ils.auth.login',
    'open-ils.actor.patron.password_reset.commit',
    'open-ils.actor.user.password',
    'open-ils.actor.user.username',
    'open-ils.actor.user.email',
    'open-ils.actor.patron.update',
    'open-ils.cstore.direct.actor.user.create',
    'open-ils.cstore.direct.actor.user.update',
    'open-ils.cstore.direct.actor.user.delete',
    'open-ils.search.z3950.apply_credentials']

  $allowed_services = [
    'opensrf.math',
    'opensrf.dbmath',
    'open-ils.cat',
    'open-ils.search',
    'open-ils.circ',
    'open-ils.actor',
    'open-ils.auth',
    'open-ils.auth_internal',
    'open-ils.auth_proxy',
    'open-ils.collections',
    'open-ils.justintime',
  ]

  $router_services = [
    'opensrf.math',
    'open-ils.actor',
    'open-ils.acq',
    'open-ils.auth',
    'open-ils.auth_internal',
    'open-ils.auth_proxy',
    'open-ils.booking',
    'open-ils.cat',
    'open-ils.circ',
    'open-ils.collections',
    'open-ils.fielder',
    'open-ils.pcrud',
    'open-ils.permacrud',
    'open-ils.reporter',
    'open-ils.resolver',
    'open-ils.search',
    'open-ils.batch-update',
    'open-ils.batch-enrich',
    'open-ils.handle',
    'open-ils.oai',
    'open-ils.supercat',
    'open-ils.vandelay',
    'open-ils.serial']

  $gateway_services = [
    'opensrf.math',
    'opensrf.dbmath',
    'open-ils.cat',
    'open-ils.search',
    'open-ils.circ',
    'open-ils.actor',
    'open-ils.auth',
    'open-ils.auth_proxy',
    'open-ils.collections',
    'open-ils.reporter']

  $opensrf_config         = 'opensrf'

  $make_osname            = 'ubuntu-xenial'
  $make_options           = '--enable-python'
}