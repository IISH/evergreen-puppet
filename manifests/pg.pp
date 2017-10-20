class evergreen::pg (
  $database                 = $evergreen::pg::params::database,
  $user                     = $evergreen::pg::params::user,
  $password                 = $evergreen::pg::params::password,
  $pg_hba_rule              = $evergreen::pg::pg_hba_rule,
  $encoding                 = $evergreen::pg::encoding,
  $locale                   = $evergreen::pg::locale,
  $config_entry             = $evergreen::pg::config_entry,
  $declare_extensions       = $evergreen::pg::declare_extensions,
  $version                  = $evergreen::pg::version,
) inherits evergreen::pg::params {

  class {
    'postgresql::globals':
       version => '9.5',
  }->class {
    ['postgresql::server', 'postgresql::server::contrib', 'postgresql::server::plperl']:
  }

  postgresql::server::role {
    $user:
      password_hash => postgresql_password($user, $password),
      login         => true,
      superuser     => true,
      replication   => false;
  }->postgresql::server::database {
    $database:
      owner    => $user,
      encoding => $encoding,
      locale   => $locale ;
  }

  if ( $declare_extensions ) {
    exec {
      'declare-extensions':
        require => Postgresql::Server::Database[$database],
        command => "/usr/bin/sudo -u postgres psql ${database} -c 'CREATE OR REPLACE LANGUAGE plperlu; CREATE EXTENSION IF NOT EXISTS tablefunc; CREATE EXTENSION IF NOT EXISTS xml2; CREATE EXTENSION IF NOT EXISTS hstore; CREATE EXTENSION IF NOT EXISTS intarray;'" ;
    }
  }

  create_resources( postgresql::server::config_entry, $config_entry )
  create_resources( postgresql::server::pg_hba_rule, $pg_hba_rule)

  group {
    $user:
      ensure => present ;
  }
  user {
    $user:
      ensure => present,
      home   => "/home/${user}/",
      shell  => '/bin/false',
      gid    => $user ;
  }
  file {
    "/home/${user}/":
      ensure => directory,
      owner  => $user,
      group  => $user ;
  }

}
