# class psick_profile::sensu::uchiwa
#
class psick_profile::sensu::uchiwa (
  Stdlib::Compat::Ip_address $host = '0.0.0.0',
  Integer $port                    = 3000,
  Variant[String,Sensitive] $user  = 'sensu',
  Variant[String,Sensitive] $pass  = 'sensu',
  Hash $api_endpoints              = {},
  Optional[String] $datacenter     = undef,

  Boolean $manage      = $::psick::manage,
  Boolean $noop_manage = $::psick::noop_manage,
  Boolean $noop_value  = $::psick::noop_value,
) {
  if $manage {
    if $noop_manage {
      noop($noop_value)
    }

    $default_api_endpoint = [{
        name     => $datacenter,
        ssl      => false,
        host     => $psick_profile::sensu::api_host,
        port     => $psick_profile::sensu::api_port,
        user     => $psick_profile::sensu::api_user,
        pass     => $psick_profile::sensu::api_password,
        path     => '',
        timeout  => 5,
    }]
    class { 'uchiwa':
      host                => $host,
      port                => $port,
      user                => $user,
      pass                => $pass,
      sensu_api_endpoints => $default_api_endpoint + $api_endpoints,
    }
  }
}
