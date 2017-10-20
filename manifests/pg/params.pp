class evergreen::pg::params() {
  $database         = 'evergreen'
  $encoding         = 'UTF8'
  $locale           = 'en_US.UTF-8'
  $user             = 'evergreen'
  $password         = 'evergreen'
  $version          = '9.5'
  $method           = 'md5'
  $config_entry   = {}
  $pg_hba_rule    = {
    "Access from ${::ipaddress}" => {
      description=> "Open up postgresql for access from ${::ipaddress}",
      type=> 'host',
      database=>$database,
      user=> $user,
      address=> "${::ipaddress}/32",
      auth_method=>$method
    }
  }
  $declare_extensions = false
}