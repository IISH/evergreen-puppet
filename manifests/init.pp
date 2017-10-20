class evergreen {

  exec { 'apt-get-update':
    command => '/usr/bin/apt-get update',
    onlyif  => "/bin/sh -c '[ ! -f /var/cache/apt/pkgcache.bin ] || /usr/bin/find /etc/apt/* -cnewer /var/cache/apt/pkgcache.bin | /bin/grep . > /dev/null'",
  }

  package {
    [
      'gcc',
      'git',
      'git-core',
      'make',
      'autoconf',
      'automake',
      'libtool',
      'perl-modules',
      'libbusiness-isbn-perl',
      'libjson-xs-perl',
      'liblibrary-callnumber-lc-perl',
      'libmarc-record-perl',
      'libmarc-xml-perl',
      'librose-uri-perl',
      'libuuid-tiny-perl',
      'libxml-libxml-perl',
      'libxml-libxslt-perl',
      'python',
      'wget']:
	require  => Exec['apt-get-update'],
	ensure  => present ;
  }

  class {
    'cpan':
      manage_package => false;
  }

  cpan { ['HTTP::OAI', 'Data::UUID']:
    ensure  => present,
    require => Class['::cpan'],
    force   => true,
  }

}
