class evergreen::openils::params() {
  $user                   = 'opensrf'
  $password               = 'opensrf'
  $sysdir                 = '/openils'
  $repository             = 'https://github.com/evergreen-library-system/Evergreen/archive/tags/rel_2_12_6.tar.gz'
  $version                = '2.12.6'
  $staff_client_stamp     = 'rel_2_12_6'
  $apache_version         = '24'
  $apache_ssl_crt         = "/etc/ssl/certs/${::fqdn}.crt"
  $apache_ssl_key         = "/etc/ssl/private/${::fqdn}.key"
  $apache_offline         = 'Allow from 10.0.0.0/8'
  $apache_ipaddress       = $::ipaddress
  $apache_servername      = $::fqdn
  $apache_keep_alive_timeout                           = 1
  $apache_max_keep_alive_requests                      = 100
  $apache_mpm_prefork_module_start_servers             = 15
  $apache_mpm_prefork_module_min_spare_servers         = 5
  $apache_mpm_prefork_module_max_spare_servers         = 15
  $apache_mpm_prefork_module_max_requests_workers      = 500
  $apache_mpm_prefork_module_max_connections_per_child = 10
  $apache_web_template_path                            = undef
  $apache_websocket_port                               = 8000

  $enable_service         = true
  $co_service             = ['clark-kent', 'apache2']

  $clark_kent_sleep       = 10
  $clark_kent_concurrency = 1
  $clark_kent_lockfile    = '/tmp/reporter-LOCK'

  $david_banner_sleep       = 10
  $david_banner_concurrency = 1
  $david_banner_lockfile    = '/tmp/enricher-LOCK'
  $david_banner_baseurl     = "https://${::ipaddress}/opac/extras/oai/biblio"

  $batman_sleep           = 10
  $batman_concurrency     = 1
  $batman_lockfile        = '/tmp/batch-LOCK'

  $monitor_path           = "${sysdir}/bin/monitor"

  $reporter_output_base   = '/openils/var/web/reporter'

  $memcached_server       = "${::ipaddress}"

  $make_osname            = 'ubuntu-xenial'
}