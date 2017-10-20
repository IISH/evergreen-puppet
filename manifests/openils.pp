class evergreen::openils (
  $user               = $evergreen::openils::params::user,
  $password           = $evergreen::openils::params::password,
  $sysdir             = $evergreen::openils::params::sysdir,
  $repository         = $evergreen::openils::params::repository,
  $version            = $evergreen::openils::params::version,
  $staff_client_stamp = $evergreen::openils::params::staff_client_stamp,
  $apache_version     = $evergreen::openils::params::apache_version,
  $apache_ssl_crt     = $evergreen::openils::params::apache_ssl_crt,
  $apache_ssl_key     = $evergreen::openils::params::apache_ssl_key,
  $apache_offline     = $evergreen::openils::params::apache_offline,
  $apache_ipaddress   = $evergreen::openils::params::apache_ipaddress,
  $apache_servername  = $evergreen::openils::params::apache_servername,
  $apache_keep_alive_timeout                        = $evergreen::openils::params::apache_keep_alive_timeout,
  $apache_apache_max_keep_alive_requests            = $evergreen::openils::params::apache_max_keep_alive_requests,
  $apache_mpm_prefork_module_start_servers          = $evergreen::openils::params::apache_mpm_prefork_module_start_servers,
  $apache_mpm_prefork_module_min_spare_servers      = $evergreen::openils::params::apache_mpm_prefork_module_min_spare_servers,
  $apache_mpm_prefork_module_max_spare_servers      = $evergreen::openils::params::apache_mpm_prefork_module_max_spare_servers,
  $apache_mpm_prefork_module_max_requests_workers   = $evergreen::openils::params::apache_mpm_prefork_module_max_requests_workers,
  $apache_mpm_prefork_module_max_requests_per_child = $evergreen::openils::params::apache_mpm_prefork_module_max_connections_per_child,
  $apache_web_template_path                         = $evergreen::openils::params::apache_web_template_path,
  $apache_websocket_port                            = $evergreen::openils::params::apache_websocket_port,

  $batman_lockfile          = $evergreen::openils::params::batman_lockfile,

  $clark_kent_sleep         = $evergreen::openils::params::clark_kent_sleep,
  $clark_kent_concurrency   = $evergreen::openils::params::clark_kent_concurrency,
  $clark_kent_lockfile      = $evergreen::openils::params::clark_kent_lockfile,

  $david_banner_sleep       = $evergreen::openils::params::david_banner_sleep,
  $david_banner_concurrency = $evergreen::openils::params::david_banner_concurrency,
  $david_banner_lockfile    = $evergreen::openils::params::david_banner_lockfile,
  $david_banner_baseurl     = $evergreen::openils::params::david_banner_baseurl,

  $enable_service           = $evergreen::openils::params::enable_service,
  $co_service               = $evergreen::openils::params::co_service,

  $memcached_server         = $evergreen::openils::params::memcached_server,
  $monitor_path             = $evergreen::openils::params::monitor_path,

  $reporter_output_base     = $evergreen::openils::params::reporter_output_base,

  $make_osname              = $evergreen::openils::params::make_osname,

  $bamboo                   = {}
) inherits evergreen::openils::params {

  case $::osfamily {
    Debian: {
      $global_apache_folder = '/etc/apache2'
    }
    Redhat: {
      $global_apache_folder = '/etc/httpd'
    }
  }

  file {
    ["${sysdir}/var", "${sysdir}/var/web/", "${sysdir}/var/web/xul/", "${sysdir}/var/web/xul/${staff_client_stamp}/", "${sysdir}/var/web/xul/${staff_client_stamp}/server/", "${sysdir}/ssl/", $reporter_output_base]:
      ensure => directory,
      group => $user,
      owner => $user ;
    "${sysdir}/install/install-openils.sh":
      ensure  => present,
      mode    => 744,
      content => template('evergreen/install-openils.sh');
    "${global_apache_folder}/sites-available/eg.conf":
      ensure  => present,
      content => template("evergreen/eg_${apache_version}.conf.erb") ;
    "${global_apache_folder}/sites-enabled/eg.conf":
      ensure => link,
      target => "${global_apache_folder}/sites-available/eg.conf" ;
    "${global_apache_folder}/mods-available/mpm_prefork.conf":
      ensure  => present,
      content => template("evergreen/mpm_prefork.conf.erb") ;
    "${global_apache_folder}/sites-enabled/000-default":
      ensure => absent ;
    "${global_apache_folder}/eg_vhost.conf":
      ensure  => present,
      content => template("evergreen/eg_vhost_${apache_version}.conf.erb") ;
    "${global_apache_folder}/eg_startup":
      ensure  => present,
      content => template('evergreen/eg_startup.erb') ;
    '/var/lock/apache2'    :
      owner => $user ;
    "${sysdir}/var/web/robots.txt":
      ensure  => present,
      content => 'User-agent: *
Disallow: /';
    $monitor_path:
      ensure  => present,
      mode => 744,
      owner => $user,
      content => template('evergreen/monitor.pl.erb');
  '/etc/apache2/ports.conf':
      ensure  => present,
      content => template('evergreen/ports.conf.erb');
    "${global_apache_folder}/apache2.conf":
      ensure  => present,
      content => template("evergreen/apache2_${apache_version}.conf.erb") ;
    '/etc/init.d/clark-kent':
      ensure  => present,
      mode    => 755,
      content => template('evergreen/upstart-clark-kent.erb') ;
    '/etc/init.d/batman':
      ensure  => present,
      mode    => 755,
      content => template('evergreen/upstart-batman.erb') ;
    '/etc/init.d/david-banner':
      ensure  => present,
      mode    => 755,
      content => template('evergreen/upstart-david-banner.erb') ;
    '/etc/init.d/openils':
      ensure  => present,
      mode    => 755,
      content => template('evergreen/upstart-openils.erb') ;
  }

  exec {
    'install-ils': # Download and build the ils tar
      require => File["${sysdir}/install/install-openils.sh"],
      command => "${sysdir}/install/install-openils.sh > ${sysdir}/install/install-openils.log",
      timeout =>  600;
  }


  service {
    'openils':
      enable     => $enable_service ,
      path       => '/etc/init.d/',
      hasrestart => true,
      require    => File['/etc/init.d/openils'] ;
  }

  file_line {
    'apache_envvars-user':
      path => "${global_apache_folder}/envvars",
      line => "export APACHE_RUN_USER=${$user}";
  }

}