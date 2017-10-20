# Evergreen ILS configuration
# Example configuration

node 'acceptance-node-1' {

  # --------------------------------------------------------------------------------------------------------------------
  # Main class
  # --------------------------------------------------------------------------------------------------------------------
  include evergreen


  # --------------------------------------------------------------------------------------------------------------------
  # Postgresql
  # Install the database and set directories for the data and xlog files.
  #
  # After the first installation, the following must be set to make use of the disks:
  # 1. Add two disks
  # a. 200GB and mount to /data/postgresql
  # b.  10GB and mount to /data/pg_xlog
  #
  # 2. Move the postgresql files to the disks:
  # service postgresql stop
  # mv /var/lib/postgresql/9.5 /data/postgresql
  # ln -s /data/postgresql/9.5 /var/lib/postgresql/9.5
  # mv /data/postgresql/9.5/main/pg_xlog/* /data/pg_xlog/
  # rm -rf /data/postgresql/9.5/main/pg_xlog/
  # ln -s /data/pg_xlog /data/postgresql/9.5/main/pg_xlog
  #
  # 3. Import the database
  # service postgresql start
  # sudo -u evergreen psql -f [filename of the database dump]
  # --------------------------------------------------------------------------------------------------------------------
  class {
    ::evergreen::pg:
      require => Class['evergreen'];
  } -> file {
    ['/data']:
      ensure => directory,
      group  => 'root',
      mode   => '755',
      owner  => 'root';
    ['/data/pg_xlog/', '/data/postgresql/']:
      ensure => directory,
      group  => 'postgres',
      owner  => 'postgres';
  }


  # --------------------------------------------------------------------------------------------------------------------
  # OPENSRF Router
  # --------------------------------------------------------------------------------------------------------------------
  class {
    ::evergreen::opensrf:
      require => Class['evergreen'];
  }


  # --------------------------------------------------------------------------------------------------------------------
  # OPENILS catalog
  # --------------------------------------------------------------------------------------------------------------------

  class {
    ::evergreen::openils:
      apache_offline    => false,
      require           => [Class['evergreen::opensrf']];
  }


}