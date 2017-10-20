class evergreen::opensrf (
  $user                             = $evergreen::opensrf::params::user,
  $password                         = $evergreen::opensrf::params::password,
  $home                             = $evergreen::opensrf::params::home,
  $sysdir                           = $evergreen::opensrf::params::sysdir,
  $repository                       = $evergreen::opensrf::params::repository,
  $version                          = $evergreen::opensrf::params::version,
  $public_ip                        = $evergreen::opensrf::params::public_ip,
  $private_ip                       = $evergreen::opensrf::params::private_ip,
  $public_hosts                     = $evergreen::opensrf::params::public_hosts,
  $private_hosts                    = $evergreen::opensrf::params::private_hosts,
  $activeapps                       = $evergreen::opensrf::params::activeapps,
  $max_user_sessions                = $evergreen::opensrf::params::max_user_sessions,
  $max_stanza_size                  = $evergreen::opensrf::params::max_stanza_size,
  $maxrate                          = $evergreen::opensrf::params::maxrate,
  $auth_password_format             = $evergreen::opensrf::params::auth_password_format,

  $enable_apache2                   = $evergreen::opensrf::params::enable_apache2,
  $enable_ejabberd                  = $evergreen::opensrf::params::enable_ejabberd,
  $enable_memcached                 = $evergreen::opensrf::params::enable_memcached,
  $router_password                  = $evergreen::opensrf::params::router_password,
  $opensrf_user                     = $evergreen::opensrf::params::opensrf_user,
  $opensrf_password                 = $evergreen::opensrf::params::opensrf_password,
  $opensrf_host                     = $evergreen::opensrf::params::opensrf_host,

  $openils_cat_marctemplates        = $evergreen::opensrf::params::openils_cat_marctemplates,
  $openils_cat_marctemplates_folder = $evergreen::opensrf::params::openils_cat_marctemplates_folder,
  $openils_auth_proxy_enabled       = $evergreen::opensrf::params::openils_auth_proxy_enabled,

  $memcached_l                      = $evergreen::opensrf::params::memcached_l,
  $memcached_m                      = $evergreen::opensrf::params::memcached_m,

  $max_user_sessions                = $evergreen::opensrf::params::max_user_sessions,
  $max_stanza_size                  = $evergreen::opensrf::params::max_stanza_size,
  $maxrate                          = $evergreen::opensrf::params::maxrate,
  $register                         = $evergreen::opensrf::params::register,

  $proxy                            = $evergreen::opensrf::params::proxy,
  $smtp_server                      = $evergreen::opensrf::params::smtp_server,
  $sender_address                   = $evergreen::opensrf::params::sender_address,

  $database_master_type             = $evergreen::opensrf::params::database_master_type,
  $database_master_host             = $evergreen::opensrf::params::database_master_host,
  $database_master_db               = $evergreen::opensrf::params::database_master_db,
  $database_master_user             = $evergreen::opensrf::params::database_master_user,
  $database_master_pw               = $evergreen::opensrf::params::database_master_pw,
  $database_mirror_type             = $evergreen::opensrf::params::database_mirror_type,
  $database_mirror_host             = $evergreen::opensrf::params::database_mirror_host,
  $database_mirror_db               = $evergreen::opensrf::params::database_mirror_db,
  $database_mirror_user             = $evergreen::opensrf::params::database_mirror_user,
  $database_mirror_pw               = $evergreen::opensrf::params::database_mirror_pw,

  $activeapps                       = $evergreen::opensrf::params::activeapps,
  $log_protect                      = $evergreen::opensrf::params::log_protect,
  $allowed_services                 = $evergreen::opensrf::params::allowed_services,
  $oai                              = $evergreen::opensrf::params::oai,
  $handle                           = $evergreen::opensrf::params::handle,
  $handlesystem_naming_authority    = $evergreen::opensrf::params::handlesystem_naming_authority,
  $authenticators                   = $evergreen::opensrf::params::authenticators,
  $reporter_output_base             = $evergreen::opensrf::params::reporter_output_base,

  $enable_service                   = $evergreen::opensrf::params::enable_service,

  $make_osname                      = $evergreen::opensrf::params::make_osname,
  $make_options                     = $evergreen::opensrf::params::make_options

) inherits evergreen::opensrf::params {

  group {
    $user:
      ensure => present;
  }

  user {
    $user:
      password => $password,
      shell    => '/bin/bash',
      home     => $home,
      gid      => $user;
  }

  file {
    $home:
      ensure => directory,
      owner  => $user,
      group  => $user;
    "${home}.bashrc":
      ensure  => present,
      content => "export PATH=\$PATH:${sysdir}/bin",
      owner   => $user,
      group   => $user;
    "${home}.srfsh.xml":
      ensure  => present,
      owner   => $user,
      content => template('evergreen/srfsh.xml.erb');
    [$sysdir, "${sysdir}/install/", "${sysdir}/bin/", "${sysdir}/conf"]:
      ensure => directory;
    "${sysdir}/install/install-opensrf.sh":
      ensure  => present,
      mode    => 744,
      content => template('evergreen/install-opensrf.sh');
    '/var/log/openils/':
      ensure => link,
      target => "${sysdir}/var/log/";
  }

  # Hosts
  file_line {
    'public':
      path => '/etc/hosts',
      line => "${public_ip} ${public_hosts}";
    'private':
      path => '/etc/hosts',
      line => "${private_ip} ${private_hosts}";
  }

  exec {
    'install-opensrf': # Download and build the opensrf tar
      require => [File["${sysdir}/install/install-opensrf.sh"], User[$user]],
      timeout => 600,
      command => "${sysdir}/install/install-opensrf.sh > ${sysdir}/install/install-opensrf.log";
  }->file {
    "${sysdir}/conf/opensrf_core.xml":
      ensure  => present,
      owner   => $user,
      group   => $user,
      content => template("evergreen/opensrf_core.xml.erb");
    "${sysdir}/conf/opensrf.xml":
      ensure  => present,
      owner   => $user,
      group   => $user,
      content => template("evergreen/opensrf.xml.erb");
    '/etc/init.d/opensrf':
      ensure  => present,
      mode    => 755,
      content => template('evergreen/upstart-opensrf.erb');
    '/etc/ejabberd/ejabberd.yml':
      ensure  => present,
      mode    => 600,
      owner   => 'ejabberd',
      group   => 'ejabberd',
      content => template('evergreen/ejabberd.yml');
    '/etc/memcached.conf':
      ensure  => present,
      content => template('evergreen/memcached.conf.erb');
  }

  service {
    'opensrf':
      enable     => $enable_service,
      path       => '/etc/init.d/',
      hasrestart => true,
      require    => File['/etc/init.d/opensrf'];
  }

  if $enable_apache2 {
    #
  } else {
    package {
      'apache2':
        ensure => purged;
    }
  }

  if $enable_ejabberd {
    #
  } else {
    package {
      'ejabberd':
        ensure => purged;
    }
  }

  if $enable_memcached {
    #
  } else {
    package {
      'memcached':
        ensure => purged;
    }
  }

}